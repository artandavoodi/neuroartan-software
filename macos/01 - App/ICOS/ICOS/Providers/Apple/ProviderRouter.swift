import Foundation
import Combine

// MARK: - Provider Router (Production Core)
// Resolves correct execution provider based on runtime state.

protocol RuntimeProvider {
    func execute(prompt: String, model: RuntimeModel) async -> String
}

final class ProviderRouter {

    // MARK: - Providers

    private let localProvider: LocalRuntimeService
    private let cloudProvider: CloudFrontierProvider
    private let settings: RuntimeSettingsState

    // MARK: - Init

    init(settings: RuntimeSettingsState = .shared) {
        self.settings = settings
        self.localProvider = LocalRuntimeService()
        self.cloudProvider = CloudFrontierProvider()
    }

    // MARK: - Resolve

    func resolveProvider(for runtime: RuntimeEngine, prompt: String) -> RuntimeProvider? {
        let task = TaskClassifier.classify(prompt)

        if !settings.hasEnabledProvider {
            return nil
        }

        if !settings.localProviderEnabled && settings.externalProviderEnabled {
            return cloudProvider
        }

        if settings.localProviderEnabled && !settings.externalProviderEnabled {
            return localProvider
        }

        // MARK: - Settings Override Layer
        switch settings.mode {
        case .local:
            return localProvider

        case .cloud:
            return cloudProvider

        case .auto:
            break
        }

        // MARK: - Engine + Task Logic (Auto Mode Only)
        switch runtime {
        case .cloud:
            return cloudProvider

        case .icos, .local:
            switch task {
            case .general:
                return localProvider
            case .coding, .complex:
                return cloudProvider
            }
        }
    }
}
