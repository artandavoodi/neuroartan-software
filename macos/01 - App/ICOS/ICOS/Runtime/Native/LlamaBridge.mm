#include "llama.h"

#include <algorithm>
#include <cstdint>
#include <cstring>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace {

std::once_flag g_backend_once;
std::mutex g_result_mutex;
std::string g_result_buffer;

const char *bridge_result(const std::string &value) {
    std::lock_guard<std::mutex> lock(g_result_mutex);
    g_result_buffer = value;
    return g_result_buffer.c_str();
}

const char *bridge_error(const std::string &message) {
    return bridge_result("ICOS runtime error: " + message);
}

class LlamaRuntimeSession {
public:
    explicit LlamaRuntimeSession(const char *model_path) {
        std::call_once(g_backend_once, [] {
            llama_backend_init();
        });

        if (model_path == nullptr || std::strlen(model_path) == 0) {
            initialization_error = "empty model path";
            return;
        }

        llama_model_params model_params = llama_model_default_params();
        model = llama_model_load_from_file(model_path, model_params);
        if (model == nullptr) {
            initialization_error = "failed to load model";
            return;
        }

        vocab = llama_model_get_vocab(model);
        if (vocab == nullptr) {
            initialization_error = "failed to resolve llama vocabulary";
            llama_model_free(model);
            model = nullptr;
            return;
        }

        llama_context_params context_params = llama_context_default_params();
        context_params.n_ctx = 2048;
        context_params.n_batch = 128;
        context_params.n_threads = std::max(1u, std::thread::hardware_concurrency());
        context_params.n_threads_batch = context_params.n_threads;

        context = llama_init_from_model(model, context_params);
        if (context == nullptr) {
            initialization_error = "failed to create llama context";
            llama_model_free(model);
            model = nullptr;
            return;
        }

        sampler = llama_sampler_chain_init(llama_sampler_chain_default_params());
        if (sampler == nullptr) {
            initialization_error = "failed to create llama sampler";
            llama_free(context);
            llama_model_free(model);
            context = nullptr;
            model = nullptr;
            return;
        }

        llama_sampler_chain_add(sampler, llama_sampler_init_greedy());
    }

    ~LlamaRuntimeSession() {
        if (sampler != nullptr) {
            llama_sampler_free(sampler);
            sampler = nullptr;
        }

        if (context != nullptr) {
            llama_free(context);
            context = nullptr;
        }

        if (model != nullptr) {
            llama_model_free(model);
            model = nullptr;
        }
    }

    bool is_ready() const {
        return model != nullptr && context != nullptr && vocab != nullptr && sampler != nullptr;
    }

    std::string infer(const char *prompt) {
        std::lock_guard<std::mutex> lock(inference_mutex);

        if (!is_ready()) {
            return "ICOS runtime error: " + initialization_error;
        }

        if (prompt == nullptr || std::strlen(prompt) == 0) {
            return "ICOS runtime error: empty prompt";
        }

        const int32_t context_size = llama_n_ctx(context);
        if (context_size <= 0) {
            return "ICOS runtime error: invalid context size";
        }

        llama_sampler_reset(sampler);

        const int prompt_length = static_cast<int>(std::strlen(prompt));
        int token_count = -llama_tokenize(vocab, prompt, prompt_length, nullptr, 0, true, true);

        if (token_count <= 0) {
            return "ICOS runtime error: tokenization failed";
        }

        if (token_count >= context_size) {
            return "ICOS runtime error: prompt exceeds context window";
        }

        std::vector<llama_token> prompt_tokens(static_cast<size_t>(token_count));
        const int written_tokens = llama_tokenize(
            vocab,
            prompt,
            prompt_length,
            prompt_tokens.data(),
            static_cast<int>(prompt_tokens.size()),
            true,
            true
        );

        if (written_tokens <= 0) {
            return "ICOS runtime error: tokenization produced no tokens";
        }

        prompt_tokens.resize(static_cast<size_t>(written_tokens));

        if (static_cast<int32_t>(prompt_tokens.size()) >= context_size) {
            return "ICOS runtime error: prompt exceeds context window";
        }

        constexpr int32_t decode_batch_size = 128;
        int32_t decoded_position = 0;

        while (decoded_position < static_cast<int32_t>(prompt_tokens.size())) {
            const int32_t remaining_tokens = static_cast<int32_t>(prompt_tokens.size()) - decoded_position;
            const int32_t current_batch_size = std::min(decode_batch_size, remaining_tokens);

            llama_batch prompt_batch = llama_batch_init(current_batch_size, 0, 1);

            if (prompt_batch.token == nullptr ||
                prompt_batch.pos == nullptr ||
                prompt_batch.n_seq_id == nullptr ||
                prompt_batch.seq_id == nullptr ||
                prompt_batch.logits == nullptr) {
                llama_batch_free(prompt_batch);
                return "ICOS runtime error: failed to allocate prompt batch";
            }

            prompt_batch.n_tokens = current_batch_size;

            for (int32_t i = 0; i < current_batch_size; ++i) {
                const int32_t token_index = decoded_position + i;
                prompt_batch.token[i] = prompt_tokens[static_cast<size_t>(token_index)];
                prompt_batch.pos[i] = token_index;
                prompt_batch.n_seq_id[i] = 1;
                prompt_batch.seq_id[i][0] = 0;
                prompt_batch.logits[i] = false;
            }

            if (decoded_position + current_batch_size == static_cast<int32_t>(prompt_tokens.size())) {
                prompt_batch.logits[current_batch_size - 1] = true;
            }

            if (prompt_batch.n_tokens <= 0 || prompt_batch.n_tokens > decode_batch_size) {
                llama_batch_free(prompt_batch);
                return "ICOS runtime error: invalid prompt batch size";
            }

            const int prompt_decode_status = llama_decode(context, prompt_batch);
            llama_batch_free(prompt_batch);

            if (prompt_decode_status != 0) {
                return "ICOS runtime error: prompt decode failed";
            }

            decoded_position += current_batch_size;
        }

        std::string output;
        int32_t position = static_cast<int32_t>(prompt_tokens.size());
        constexpr int32_t max_generated_tokens = 256;

        for (int32_t generated = 0; generated < max_generated_tokens; ++generated) {
            if (position >= context_size) {
                break;
            }

            llama_token next_token = llama_sampler_sample(sampler, context, -1);
            llama_sampler_accept(sampler, next_token);

            if (llama_vocab_is_eog(vocab, next_token)) {
                break;
            }

            char token_buffer[256];
            const int token_length = llama_token_to_piece(
                vocab,
                next_token,
                token_buffer,
                sizeof(token_buffer),
                0,
                true
            );

            if (token_length > 0) {
                output.append(token_buffer, static_cast<size_t>(token_length));
            }

            llama_batch token_batch = llama_batch_init(1, 0, 1);

            if (token_batch.token == nullptr ||
                token_batch.pos == nullptr ||
                token_batch.n_seq_id == nullptr ||
                token_batch.seq_id == nullptr ||
                token_batch.logits == nullptr) {
                llama_batch_free(token_batch);
                return "ICOS runtime error: failed to allocate generation batch";
            }

            token_batch.n_tokens = 1;
            token_batch.token[0] = next_token;
            token_batch.pos[0] = position;
            token_batch.n_seq_id[0] = 1;
            token_batch.seq_id[0][0] = 0;
            token_batch.logits[0] = true;

            if (token_batch.n_tokens != 1) {
                llama_batch_free(token_batch);
                return "ICOS runtime error: invalid generation batch";
            }

            const int decode_status = llama_decode(context, token_batch);
            llama_batch_free(token_batch);

            if (decode_status != 0) {
                return "ICOS runtime error: token decode failed";
            }

            position += 1;
        }

        if (output.empty()) {
            return "ICOS runtime error: empty model response";
        }

        return output;
    }

private:
    llama_model *model = nullptr;
    llama_context *context = nullptr;
    const llama_vocab *vocab = nullptr;
    llama_sampler *sampler = nullptr;
    std::mutex inference_mutex;
    std::string initialization_error = "llama session is not initialized";
};

} // namespace

extern "C" void *llama_bridge_create(const char *model_path) {
    return new LlamaRuntimeSession(model_path);
}

extern "C" const char *llama_bridge_infer(void *bridge, const char *prompt) {
    if (bridge == nullptr) {
        return bridge_error("missing llama runtime session");
    }

    auto *session = static_cast<LlamaRuntimeSession *>(bridge);
    return bridge_result(session->infer(prompt));
}

extern "C" void llama_bridge_destroy(void *bridge) {
    if (bridge == nullptr) {
        return;
    }

    auto *session = static_cast<LlamaRuntimeSession *>(bridge);
    delete session;
}
