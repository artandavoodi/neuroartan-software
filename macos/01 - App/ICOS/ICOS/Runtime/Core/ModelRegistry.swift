import Foundation

// MARK: - Model Registry
// Dynamic model discovery and selection. No fixed single-model ownership.

struct RuntimeModel: Identifiable, Equatable {
    let id: String
    let name: String
    let path: String
    let type: ModelType
}

enum ModelType: Equatable {
    case localGGUF
    case cloud
}

final class ModelRegistry {
    enum StorageKey {
        static let activeLocalModelID = "ICOS.ModelRegistry.ActiveLocalModelID"
        static let activeCloudModelID = "ICOS.ModelRegistry.ActiveCloudModelID"
        static let localModelsDirectory = "ICOS.ModelRegistry.LocalModelsDirectory"
    }

    private var cloudModels: [RuntimeModel] = []

    func resolveModel(for runtime: RuntimeEngine) -> RuntimeModel {
        switch runtime {
        case .icos, .local:
            return resolveActiveLocalModel()
        case .cloud:
            return resolveActiveCloudModel()
        }
    }

    func availableLocalModels() -> [RuntimeModel] {
        let files = localModelDirectories().flatMap { directory in
            ((try? FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )) ?? [])
        }

        var seen = Set<String>()
        return files
            .filter { $0.pathExtension.lowercased() == "gguf" }
            .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
            .filter { url in
                if seen.contains(url.path) {
                    return false
                }
                seen.insert(url.path)
                return true
            }
            .map { url in
                RuntimeModel(
                    id: url.deletingPathExtension().lastPathComponent,
                    name: url.deletingPathExtension().lastPathComponent,
                    path: url.path,
                    type: .localGGUF
                )
            }
    }

    func setActiveLocalModel(id: String) {
        guard availableLocalModels().contains(where: { $0.id == id }) else { return }
        UserDefaults.standard.set(id, forKey: StorageKey.activeLocalModelID)
    }

    func setLocalModelsDirectory(_ url: URL) {
        UserDefaults.standard.set(url.path, forKey: StorageKey.localModelsDirectory)
    }

    func activeLocalModelID() -> String {
        let activeID = UserDefaults.standard.string(forKey: StorageKey.activeLocalModelID) ?? ""
        if !activeID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return activeID
        }

        return availableLocalModels().first?.id ?? ""
    }

    func localModelsDirectoryPath() -> String {
        localModelsDirectoryURL().path
    }

    func registerCloudModel(id: String, name: String) {
        let model = RuntimeModel(id: id, name: name, path: "", type: .cloud)
        guard !cloudModels.contains(model) else { return }
        cloudModels.append(model)
    }

    func availableCloudModels() -> [RuntimeModel] {
        cloudModels
    }

    func setActiveCloudModel(id: String) {
        guard cloudModels.contains(where: { $0.id == id }) else { return }
        UserDefaults.standard.set(id, forKey: StorageKey.activeCloudModelID)
    }

    func resolveCloudModel() -> RuntimeModel {
        resolveActiveCloudModel()
    }

    private func resolveActiveLocalModel() -> RuntimeModel {
        let models = availableLocalModels()
        let activeID = UserDefaults.standard.string(forKey: StorageKey.activeLocalModelID)

        if let activeID, let model = models.first(where: { $0.id == activeID }) {
            return model
        }

        guard let fallback = models.first else {
            return RuntimeModel(
                id: "local-model-unavailable",
                name: "Local Model Unavailable",
                path: "",
                type: .localGGUF
            )
        }

        UserDefaults.standard.set(fallback.id, forKey: StorageKey.activeLocalModelID)
        return fallback
    }

    private func resolveActiveCloudModel() -> RuntimeModel {
        let activeID = UserDefaults.standard.string(forKey: StorageKey.activeCloudModelID)

        if let activeID, let model = cloudModels.first(where: { $0.id == activeID }) {
            return model
        }

        return RuntimeModel(
            id: "cloud-provider-unconfigured",
            name: "Cloud Provider Unconfigured",
            path: "",
            type: .cloud
        )
    }

    private func localModelsDirectoryURL() -> URL {
        if let storedPath = UserDefaults.standard.string(forKey: StorageKey.localModelsDirectory),
           !storedPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return URL(fileURLWithPath: storedPath, isDirectory: true)
        }

        return FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Neuroartan", isDirectory: true)
            .appendingPathComponent("ICOS", isDirectory: true)
            .appendingPathComponent("Runtime", isDirectory: true)
            .appendingPathComponent("Models", isDirectory: true)
    }

    private func localModelDirectories() -> [URL] {
        let configured = localModelsDirectoryURL()
        let bundleRuntimeModels = Bundle.main.resourceURL?
            .appendingPathComponent("Runtime", isDirectory: true)
            .appendingPathComponent("Models", isDirectory: true)
        let developmentRuntimeModels = URL(
            fileURLWithPath: "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/Runtime/Models",
            isDirectory: true
        )

        return [configured, bundleRuntimeModels, developmentRuntimeModels]
            .compactMap { $0 }
            .filter { FileManager.default.fileExists(atPath: $0.path) }
    }
}
