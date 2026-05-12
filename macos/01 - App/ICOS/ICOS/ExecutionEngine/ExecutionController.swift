import Foundation
import Combine

// MARK: - Execution Controller (RR-Execution Layer)

final class ExecutionController {
    
    private let inferenceGateway = InferenceGateway()

    private func extractUserInput(from prompt: String) -> String {
        if let range = prompt.range(of: "USER INPUT:") {
            let tail = prompt[range.upperBound...]
            return tail.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        // Fallback: return full prompt instead of empty
        return prompt.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func execute(input: String, appState: ICOSAppState) async -> String {
        let output = await inferenceGateway.execute(
            prompt: input,
            runtime: appState.runtime
        )

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
