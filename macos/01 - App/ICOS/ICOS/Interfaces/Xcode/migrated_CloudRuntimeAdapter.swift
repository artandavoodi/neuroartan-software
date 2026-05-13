import Foundation

// =========================================
// CLOUD RUNTIME ADAPTER (PRODUCTION ROUTING)
// =========================================
// Legacy bridge removed.
// All cloud execution must route through RuntimeManager.

final class CloudRuntimeAdapter {

    // MARK: - Execute

    func execute(prompt: String) async -> String {
        let processedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !processedPrompt.isEmpty else {
            return ""
        }

        return await routeToRuntimeManager(prompt: processedPrompt)
    }

    // MARK: - Runtime Routing

    private func routeToRuntimeManager(prompt: String) async -> String {
        return await RuntimeManager.shared.execute(
            prompt: prompt,
            runtime: .cloud
        )
    }

    // MARK: - Hard Block (Legacy Bridge)

    @available(*, deprecated, message: "ICOSRuntimeBridge is deprecated. Use RuntimeManager.")
    private func executeWithBridge(prompt: String) async -> String {
        return "Legacy bridge execution is disabled. Use RuntimeManager."
    }
}
