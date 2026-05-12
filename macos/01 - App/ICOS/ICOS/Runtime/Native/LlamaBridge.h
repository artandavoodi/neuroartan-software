#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void *llama_bridge_create(const char *model_path);
const char *llama_bridge_infer(void *bridge, const char *prompt);
void llama_bridge_destroy(void *bridge);

#ifdef __cplusplus
}
#endif
