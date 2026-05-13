import Foundation

// MARK: - Streaming Response Controller (Production Core)
// Single streaming pathway for all inference output.
// No blocking responses. No batch return as primary mode.

final class StreamingResponseController {

    // MARK: - Stream

    func stream(
        prompt: String,
        runtime: RuntimeEngine,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void
    ) async {
        let controller = ICOSExecutionController.shared

        do {
            let response = try await controller.execute(input: prompt)
            await emit(response: response, onToken: onToken)
            onComplete()
        } catch {
            await emit(response: "Execution failed: \(error.localizedDescription)", onToken: onToken)
            onComplete()
        }
    }

    // MARK: - Token Emission

    private func emit(
        response: String,
        onToken: @escaping (String) -> Void
    ) async {
        guard !response.isEmpty else { return }

        let tokens = response.split(separator: " ", omittingEmptySubsequences: false)

        for token in tokens {
            onToken(String(token) + " ")
            await Task.yield()
        }
    }
}
