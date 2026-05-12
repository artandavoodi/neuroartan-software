import Foundation

// MARK: - Runtime Manager
// Central execution authority for ICOS runtime.

final class RuntimeManager {
    static let shared = RuntimeManager()

    private static var executionDepth: Int = 0

    private let modelRegistry: ModelRegistry
    private let providerRouter: ProviderRouter
    private let promptBuilder = SystemPromptBuilder()
    private let runtimeSettings = RuntimeSettingsState.shared

    private init() {
        self.modelRegistry = ModelRegistry()
        self.providerRouter = ProviderRouter()
    }

    func execute(prompt: String) async throws -> String {
        if Self.executionDepth > 0 {
            throw NSError(
                domain: "RuntimeManager",
                code: 99,
                userInfo: [NSLocalizedDescriptionKey: "Recursive execution blocked"]
            )
        }

        Self.executionDepth += 1
        defer { Self.executionDepth -= 1 }

        let runtime = engineForCurrentMode()

        guard let provider = providerRouter.resolveProvider(for: runtime, prompt: prompt) else {
            throw NSError(
                domain: "RuntimeManager",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No provider available"]
            )
        }

        let model = provider is CloudFrontierProvider
            ? modelRegistry.resolveCloudModel()
            : modelRegistry.resolveModel(for: runtime)

        let governedPrompt = promptBuilder.build(input: prompt, appState: ICOSAppState.shared)
        let rawOutput = await provider.execute(prompt: governedPrompt, model: model)

        let context = ValidationContext(
            requiresIdentityAssertion: shouldAssertIdentity(prompt)
        )

        return DoctrineOutputValidator.shared.validate(output: rawOutput, context: context)
    }

    private func engineForCurrentMode() -> RuntimeEngine {
        switch runtimeSettings.mode {
        case .local:
            return .local
        case .cloud:
            return .cloud
        case .auto:
            return .icos
        }
    }

    private func shouldAssertIdentity(_ prompt: String) -> Bool {
        let p = prompt.lowercased()
        return p.contains("who are you")
            || p.contains("what are you")
            || p.contains("who created you")
            || p.contains("who built you")
            || p.contains("origin")
    }
}
