import Foundation

// MARK: - Local Runtime Service
// Native execution layer for llama.cpp.

final class LocalRuntimeService: RuntimeProvider {
    private static let inferenceQueue = DispatchQueue(label: "llama.inference.serial")

    func execute(prompt: String, model: RuntimeModel) async -> String {
        guard model.type == .localGGUF else {
            return "Invalid model type for local runtime."
        }

        guard !model.path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Local model path unavailable."
        }

        guard FileManager.default.fileExists(atPath: model.path) else {
            return "Local model file not found: \(model.path)"
        }

        return await performNativeInference(prompt: prompt, modelPath: model.path)
    }

    private func performNativeInference(prompt: String, modelPath: String) async -> String {
        await withCheckedContinuation { continuation in
            Self.inferenceQueue.async { [self] in
                guard let context = llama_bridge_create(modelPath) else {
                    continuation.resume(returning: "Failed to create native llama context.")
                    return
                }

                defer {
                    llama_bridge_destroy(context)
                }

                guard let rawOutput = llama_bridge_infer(context, prompt) else {
                    continuation.resume(returning: "Native llama bridge returned no output.")
                    return
                }

                let output = String(cString: rawOutput)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                continuation.resume(returning: cleanOutput(output))
            }
        }
    }

    private func cleanOutput(_ text: String) -> String {
        var cleaned = text
        cleaned = cleaned.replacingOccurrences(of: "\\[IDENTITY\\][\\s\\S]*?\\[/IDENTITY\\]", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "Response Generation:.*", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "Task:.*", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "Input:.*", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "Answer:.*", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "---+", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "\\*{1,}", with: "", options: .regularExpression)

        let lines = cleaned
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        guard var first = lines.first else { return "" }
        first = first.replacingOccurrences(of: "^Answer:\\s*", with: "", options: .regularExpression)
        first = first.replacingOccurrences(of: "^User:\\s*", with: "", options: .regularExpression)

        return first.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
