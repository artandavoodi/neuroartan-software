import Foundation
import Combine

// MARK: - Runtime Settings State
// Central control layer for ICOS execution mode and provider configuration.

final class RuntimeSettingsState: ObservableObject {
    static let shared = RuntimeSettingsState()

    // MARK: - Published State

    @Published var mode: RuntimeMode = .local

    @Published var cloudAPIKey: String = ""
    @Published var cloudEndpoint: String = ""
    @Published var selectedModelID: String = ""
    @Published var localProviderEnabled: Bool = false
    @Published var externalProviderEnabled: Bool = false
    @Published var selectedLocalModelID: String = ""
    @Published private(set) var localModels: [RuntimeModel] = []
    @Published private(set) var localModelStatus: String = "Local models have not been scanned."
    @Published private(set) var discoveredModels: [ExternalRuntimeModel] = []
    @Published private(set) var modelDiscoveryStatus: String = "No external model scan has run."
    @Published private(set) var isDiscoveringModels: Bool = false
    @Published private(set) var activeProviderTitle: String = "Not mounted"
    @Published private(set) var activeModelTitle: String = "No active model"
    @Published private(set) var activeEndpointTitle: String = "No active endpoint"

    // MARK: - Persistence Keys

    private enum Keys {
        static let mode = "ICOS.RuntimeSettings.Mode"
        static let apiKey = "ICOS.CloudFrontierProvider.APIKey"
        static let apiKeyCredentialAccount = "runtime.openai-compatible.api-key"
        static let endpoint = "ICOS.CloudFrontierProvider.Endpoint"
        static let model = "ICOS.CloudFrontierProvider.Model"
        static let localProviderEnabled = "ICOS.RuntimeSettings.LocalProviderEnabled"
        static let externalProviderEnabled = "ICOS.RuntimeSettings.ExternalProviderEnabled"
    }

    private let defaultChatCompletionsEndpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
    private let modelRegistry = ModelRegistry()

    // MARK: - Init

    private init() {
        load()
    }

    // MARK: - Load / Save

    func load() {
        if let raw = UserDefaults.standard.string(forKey: Keys.mode),
           let m = RuntimeMode(rawValue: raw) {
            mode = m
        }

        cloudAPIKey = (try? SecureCredentialStore.load(account: Keys.apiKeyCredentialAccount)) ?? nil
            ?? UserDefaults.standard.string(forKey: Keys.apiKey)
            ?? ""
        cloudEndpoint = UserDefaults.standard.string(forKey: Keys.endpoint)
            ?? UserDefaults.standard.string(forKey: "ICOS.Cloud.Endpoint")
            ?? ""
        selectedModelID = UserDefaults.standard.string(forKey: Keys.model)
            ?? UserDefaults.standard.string(forKey: "ICOS.Cloud.Model")
            ?? ""
        localProviderEnabled = UserDefaults.standard.object(forKey: Keys.localProviderEnabled) as? Bool ?? false
        externalProviderEnabled = UserDefaults.standard.object(forKey: Keys.externalProviderEnabled) as? Bool ?? false
        selectedLocalModelID = UserDefaults.standard.string(forKey: ModelRegistry.StorageKey.activeLocalModelID) ?? ""
        refreshLocalModels()
        synchronizeActiveRuntimeSummary()
    }

    func save() {
        UserDefaults.standard.set(mode.rawValue, forKey: Keys.mode)
        UserDefaults.standard.set(cloudEndpoint, forKey: Keys.endpoint)
        UserDefaults.standard.set(selectedModelID, forKey: Keys.model)
        UserDefaults.standard.set(localProviderEnabled, forKey: Keys.localProviderEnabled)
        UserDefaults.standard.set(externalProviderEnabled, forKey: Keys.externalProviderEnabled)
        UserDefaults.standard.removeObject(forKey: Keys.apiKey)
        let trimmedAPIKey = cloudAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAPIKey.isEmpty {
            try? SecureCredentialStore.delete(account: Keys.apiKeyCredentialAccount)
        } else {
            try? SecureCredentialStore.save(trimmedAPIKey, account: Keys.apiKeyCredentialAccount)
        }
        if !selectedLocalModelID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            modelRegistry.setActiveLocalModel(id: selectedLocalModelID)
        }
        synchronizeActiveRuntimeSummary()
    }

    // MARK: - Helpers

    var isCloudEnabled: Bool {
        externalProviderEnabled && (mode == .cloud || mode == .auto)
    }

    var isLocalForced: Bool {
        localProviderEnabled && mode == .local
    }

    var hasEnabledProvider: Bool {
        localProviderEnabled || externalProviderEnabled
    }

    var activeRoutingSummary: String {
        if localProviderEnabled && externalProviderEnabled {
            return mode == .auto ? "Hybrid: local + external" : "\(mode.title): local + external enabled"
        }

        if localProviderEnabled {
            return "Local provider only"
        }

        if externalProviderEnabled {
            return "External OpenAI-compatible only"
        }

        return "No provider enabled"
    }

    // MARK: - OpenAI-Compatible Endpoint Resolution

    func chatCompletionsEndpointURL() -> URL {
        normalizedEndpoint(from: cloudEndpoint, target: .chatCompletions)
            ?? normalizedEndpoint(
                from: UserDefaults.standard.string(forKey: Keys.endpoint) ?? "",
                target: .chatCompletions
            )
            ?? defaultChatCompletionsEndpoint
    }

    func modelsEndpointURL() -> URL? {
        normalizedEndpoint(from: cloudEndpoint, target: .models)
            ?? normalizedEndpoint(
                from: UserDefaults.standard.string(forKey: Keys.endpoint) ?? "",
                target: .models
            )
    }

    func resolvedAPIKey() -> String {
        let current = cloudAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if !current.isEmpty {
            return current
        }

        if let stored = (try? SecureCredentialStore.load(account: Keys.apiKeyCredentialAccount)) ?? nil,
           !stored.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return stored.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    }

    func requiresAPIKey(endpoint: URL) -> Bool {
        endpoint == defaultChatCompletionsEndpoint
    }

    func recordActiveRuntime(provider: String, model: String, endpoint: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activeProviderTitle = provider
            self?.activeModelTitle = model
            self?.activeEndpointTitle = endpoint
        }
    }

    func refreshLocalModels() {
        localModels = modelRegistry.availableLocalModels()

        if selectedLocalModelID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            selectedLocalModelID = modelRegistry.activeLocalModelID()
        }

        if selectedLocalModelID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let first = localModels.first {
            selectedLocalModelID = first.id
            modelRegistry.setActiveLocalModel(id: first.id)
        }

        localModelStatus = localModels.isEmpty
            ? "No local GGUF provider models found. Add models to \(modelRegistry.localModelsDirectoryPath())."
            : "Found \(localModels.count) local provider model\(localModels.count == 1 ? "" : "s")."
        synchronizeActiveRuntimeSummary()
    }

    func selectLocalModel(id: String) {
        activateLocalModel(id: id)
    }

    func activateLocalModel(id: String) {
        selectedLocalModelID = id
        selectedModelID = ""
        localProviderEnabled = true
        externalProviderEnabled = false
        mode = .local
        modelRegistry.setActiveLocalModel(id: id)
        save()
        refreshLocalModels()
        synchronizeActiveRuntimeSummary()
    }

    func enableLMStudioPreset() {
        cloudEndpoint = "http://localhost:1234/v1"
        externalProviderEnabled = true
        localProviderEnabled = false
        mode = .cloud
        save()
    }

    func selectExternalModel(id: String) {
        activateExternalModel(id: id)
    }

    func activateExternalModel(id: String) {
        selectedModelID = id
        selectedLocalModelID = ""
        externalProviderEnabled = true
        localProviderEnabled = false
        mode = .cloud
        save()
        synchronizeActiveRuntimeSummary()
    }

    func refreshExternalModels() async {
        guard let endpoint = modelsEndpointURL() else {
            discoveredModels = []
            modelDiscoveryStatus = "Enter an OpenAI-compatible endpoint before scanning models."
            return
        }

        isDiscoveringModels = true
        modelDiscoveryStatus = "Scanning \(endpoint.absoluteString)"
        defer { isDiscoveringModels = false }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let apiKey = resolvedAPIKey()
        if !apiKey.isEmpty {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                discoveredModels = []
                modelDiscoveryStatus = "Model scan returned an invalid response."
                return
            }

            guard (200...299).contains(http.statusCode) else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown provider error."
                discoveredModels = []
                modelDiscoveryStatus = "Model scan failed \(http.statusCode): \(message)"
                return
            }

            let decoded = try JSONDecoder().decode(OpenAIModelsResponse.self, from: data)
            discoveredModels = decoded.data
                .map { ExternalRuntimeModel(id: $0.id, owner: $0.ownedBy ?? "external") }
                .sorted { $0.id.localizedStandardCompare($1.id) == .orderedAscending }

            if selectedModelID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               let first = discoveredModels.first {
                selectedModelID = first.id
                save()
            }

            modelDiscoveryStatus = discoveredModels.isEmpty
                ? "Provider returned no models."
                : "Found \(discoveredModels.count) model\(discoveredModels.count == 1 ? "" : "s")."
            synchronizeActiveRuntimeSummary()
        } catch {
            discoveredModels = []
            modelDiscoveryStatus = "Model scan failed: \(error.localizedDescription)"
            synchronizeActiveRuntimeSummary()
        }
    }

    func synchronizeActiveRuntimeSummary() {
        let localModel = localModels.first(where: { $0.id == selectedLocalModelID }) ?? localModels.first
        let externalModel = selectedModelID.trimmingCharacters(in: .whitespacesAndNewlines)
        let endpoint = chatCompletionsEndpointURL().absoluteString

        if !hasEnabledProvider {
            activeProviderTitle = "No provider enabled"
            activeModelTitle = "No active model"
            activeEndpointTitle = "No active endpoint"
            return
        }

        switch mode {
        case .local:
            activeProviderTitle = localProviderEnabled ? "Local GGUF" : "Local disabled"
            activeModelTitle = localProviderEnabled ? (localModel?.name ?? "No local model") : "No active model"
            activeEndpointTitle = localModel?.path ?? "No local model path"

        case .cloud:
            activeProviderTitle = externalProviderEnabled ? "OpenAI-Compatible" : "External disabled"
            activeModelTitle = externalProviderEnabled ? (externalModel.isEmpty ? "No external model" : externalModel) : "No active model"
            activeEndpointTitle = endpoint

        case .auto:
            if localProviderEnabled && externalProviderEnabled {
                activeProviderTitle = "Hybrid"
                let localTitle = localModel?.name ?? "No local model"
                let cloudTitle = externalModel.isEmpty ? "No external model" : externalModel
                activeModelTitle = "\(localTitle) + \(cloudTitle)"
                activeEndpointTitle = endpoint
            } else if localProviderEnabled {
                activeProviderTitle = "Local GGUF"
                activeModelTitle = localModel?.name ?? "No local model"
                activeEndpointTitle = localModel?.path ?? "No local model path"
            } else {
                activeProviderTitle = "OpenAI-Compatible"
                activeModelTitle = externalModel.isEmpty ? "No external model" : externalModel
                activeEndpointTitle = endpoint
            }
        }
    }

    private enum EndpointTarget {
        case chatCompletions
        case models

        var pathComponent: String {
            switch self {
            case .chatCompletions:
                return "chat/completions"
            case .models:
                return "models"
            }
        }
    }

    private func normalizedEndpoint(from value: String, target: EndpointTarget) -> URL? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let base = trimmed.hasSuffix("/") ? String(trimmed.dropLast()) : trimmed

        if base.hasSuffix("/chat/completions") {
            return URL(string: base.replacingOccurrences(
                of: "/chat/completions",
                with: target == .chatCompletions ? "/chat/completions" : "/models"
            ))
        }

        if base.hasSuffix("/models") {
            return URL(string: base.replacingOccurrences(
                of: "/models",
                with: target == .chatCompletions ? "/chat/completions" : "/models"
            ))
        }

        if base.hasSuffix("/v1") {
            return URL(string: "\(base)/\(target.pathComponent)")
        }

        return URL(string: target == .chatCompletions ? base : "\(base)/models")
    }
}

struct ExternalRuntimeModel: Identifiable, Equatable {
    let id: String
    let owner: String
}

private struct OpenAIModelsResponse: Decodable {
    let data: [OpenAIModelRecord]
}

private struct OpenAIModelRecord: Decodable {
    let id: String
    let ownedBy: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case ownedBy = "owned_by"
    }
}
