import Foundation

final class ExecutionRouter {

    private let contextBuilder = ContextBuilder()
    private let providerRouter = ProviderRouter()
    private let modelRegistry = ModelRegistry()
    private let runtimeSettings = RuntimeSettingsState.shared

    // MARK: - Route

    func route(input: String, profile: UserProfile) async throws -> String {

        // 1. Build Context
        let context = contextBuilder.buildContext(
            input: input,
            profile: profile
        )

        // 2. Build the single governed prompt for this inference.
        let governedPrompt = SystemPromptBuilder().build(
            input: context.input,
            appState: ICOSAppState.shared
        )

        // 3. Execute via Provider Router
        let engine = engineForCurrentMode()
        let runtimeContext = RuntimeContext(
            engine: engine,
            prompt: governedPrompt,
            mode: runtimeSettings.mode
        )

        guard let provider = providerRouter.resolveProvider(
            for: runtimeContext.engine,
            prompt: runtimeContext.prompt
        ) else {
            throw ExecutionRouterError.providerUnavailable
        }

        let isCloudProvider = provider is CloudFrontierProvider
        let model = isCloudProvider
            ? selectedCloudRuntimeModel()
            : modelRegistry.resolveModel(for: runtimeContext.engine)

        runtimeSettings.recordActiveRuntime(
            provider: isCloudProvider ? "OpenAI-Compatible" : "Local GGUF",
            model: model.name,
            endpoint: isCloudProvider ? runtimeSettings.chatCompletionsEndpointURL().absoluteString : model.path
        )

        let result = await provider.execute(
            prompt: runtimeContext.prompt,
            model: model
        )

        let validated = DoctrineOutputValidator.shared.validate(
            output: result,
            context: ValidationContext(requiresIdentityAssertion: shouldAssertIdentity(input))
        )

        return cleanOutput(validated)
    }

    // MARK: - Runtime Selection

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

    private func selectedCloudRuntimeModel() -> RuntimeModel {
        let selected = runtimeSettings.selectedModelID.trimmingCharacters(in: .whitespacesAndNewlines)
        let modelID = selected.isEmpty ? "cloud-provider-unconfigured" : selected

        return RuntimeModel(
            id: modelID,
            name: selected.isEmpty ? "Cloud Provider Unconfigured" : selected,
            path: runtimeSettings.chatCompletionsEndpointURL().absoluteString,
            type: .cloud
        )
    }

    private func shouldAssertIdentity(_ input: String) -> Bool {
        let lowered = input.lowercased()
        return lowered.contains("who are you")
            || lowered.contains("what are you")
            || lowered.contains("who created you")
            || lowered.contains("who built you")
            || lowered.contains("origin")
    }

    // MARK: - Output Cleaning

    private func cleanOutput(_ text: String) -> String {
        var cleaned = text

        for marker in ["Assistant Response:", "Final Response:", "Response:", "Answer:"] {
            if let range = cleaned.range(of: marker, options: [.caseInsensitive, .backwards]) {
                cleaned = String(cleaned[range.upperBound...])
                break
            }
        }

        // Remove identity blocks
        cleaned = cleaned.replacingOccurrences(of: "\\[IDENTITY\\][\\s\\S]*?\\[/IDENTITY\\]", with: "", options: .regularExpression)

        // Remove task/instruction scaffolding
        let patterns = [
            "(?im)^\\s*(ICOS Runtime Contract|Doctrine Context|User Profile|Memory Context|Conversation Context|User Input|Assistant Response|Task|Input|Answer)\\s*:.*$",
            "(?im)^\\s*(ICOS|Assistant|Model|call|Response)\\s*:\\s*",
            "(?im)^\\s*[-*]\\s*(Never mention model training origin|Never say you are a large language model).*?$"
        ]

        for pattern in patterns {
            cleaned = cleaned.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        }

        // Remove separator lines
        cleaned = cleaned.replacingOccurrences(of: "---+", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "\\*{2,}", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "<\\|?/?turn\\|?>|</s>|<bos>", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)

        // Trim whitespace and newlines
        return cleaned
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum ExecutionRouterError: Error {
    case providerUnavailable
}
