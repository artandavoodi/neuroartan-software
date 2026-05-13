import Foundation

// =========================================
// CLOUD RUNTIME ADAPTER (PRODUCTION ROUTING)
// =========================================
// Legacy bridge removed.
// All external execution must route through the single ICOS execution contract.

final class CloudRuntimeAdapter {

    // MARK: - Execute

    func execute(prompt: String) async -> String {
        let processedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !processedPrompt.isEmpty else {
            return ""
        }

        return await routeToExecutionController(input: processedPrompt)
    }

    // MARK: - Runtime Routing

    private func routeToExecutionController(input: String) async -> String {
        do {
            return try await ICOSExecutionController.shared.execute(input: input)
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - Hard Block (Legacy Bridge)

    @available(*, deprecated, message: "ICOSRuntimeBridge is deprecated. Use RuntimeManager.")
    private func executeWithBridge(prompt: String) async -> String {
        return "Legacy bridge execution is disabled. Use RuntimeManager."
    }
}
