import Foundation

// MARK: - Inference Gateway
// Routes inference through RuntimeManager. CLI / Process execution is disallowed.

final class InferenceGateway {
    func execute(prompt: String, runtime: RuntimeEngine) async -> String {
        do {
            RuntimeSettingsState.shared.mode = mode(for: runtime)
            RuntimeSettingsState.shared.save()
            return try await RuntimeManager.shared.execute(prompt: prompt)
        } catch {
            return error.localizedDescription
        }
    }

    private func mode(for runtime: RuntimeEngine) -> RuntimeMode {
        switch runtime {
        case .local:
            return .local
        case .cloud:
            return .cloud
        case .icos:
            return .auto
        }
    }
}
