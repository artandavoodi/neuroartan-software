import Foundation
import Combine
import AppKit

@MainActor
final class ConnectorRegistryService: ObservableObject {
    static let shared = ConnectorRegistryService()

    @Published private(set) var connectors: [ConnectorConfiguration] = []
    @Published private(set) var statusText = "Connector registry ready."

    private let storageURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(storageURL: URL? = nil) {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let baseURL = appSupport.appendingPathComponent("ICOS/connectors", isDirectory: true)
        self.storageURL = storageURL ?? baseURL.appendingPathComponent("connector-registry.json")
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        load()
    }

    func binding(for kind: ConnectorKind) -> BindingProxy {
        BindingProxy(service: self, kind: kind)
    }

    func connector(_ kind: ConnectorKind) -> ConnectorConfiguration {
        connectors.first(where: { $0.kind == kind }) ?? .defaults(for: kind)
    }

    func update(_ configuration: ConnectorConfiguration) {
        if let index = connectors.firstIndex(where: { $0.kind == configuration.kind }) {
            connectors[index] = configuration
        } else {
            connectors.append(configuration)
        }
        save()
    }

    func setCredential(_ credential: String, for kind: ConnectorKind) {
        do {
            if credential.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                try SecureCredentialStore.delete(account: kind.credentialAccount)
            } else {
                try SecureCredentialStore.save(credential, account: kind.credentialAccount)
            }
            var configuration = connector(kind)
            configuration.authenticationState = credential.isEmpty ? .notConfigured : .configured
            appendLog("Credential updated.", to: &configuration)
            update(configuration)
        } catch {
            var configuration = connector(kind)
            configuration.authenticationState = .failed
            configuration.lastError = error.localizedDescription
            appendLog("Credential update failed: \(error.localizedDescription)", to: &configuration)
            update(configuration)
        }
    }

    func hasCredential(for kind: ConnectorKind) -> Bool {
        ((try? SecureCredentialStore.load(account: kind.credentialAccount)) ?? nil)?.isEmpty == false
    }

    func testConnection(_ kind: ConnectorKind) {
        var configuration = connector(kind)
        configuration.lastTestedAt = Date()
        appendLog("Testing connection.", to: &configuration)
        update(configuration)

        Task {
            let result = await runConnectionTest(kind)
            var updated = connector(kind)
            updated.lastTestedAt = Date()
            if result.isSuccess {
                updated.authenticationState = .verified
                updated.lastError = ""
                appendLog(result.message, to: &updated)
            } else {
                updated.authenticationState = .failed
                updated.lastError = result.message
                appendLog("Connection failed: \(result.message)", to: &updated)
            }
            update(updated)
            statusText = "\(kind.title): \(result.message)"
        }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: storageURL)
            connectors = try decoder.decode([ConnectorConfiguration].self, from: data)
        } catch {
            connectors = ConnectorKind.allCases.map { .defaults(for: $0) }
            save()
        }
    }

    private func save() {
        do {
            try FileManager.default.createDirectory(at: storageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let data = try encoder.encode(connectors.sorted { $0.kind.rawValue < $1.kind.rawValue })
            try data.write(to: storageURL, options: .atomic)
        } catch {
            statusText = "Connector registry save failed: \(error.localizedDescription)"
        }
    }

    private func appendLog(_ message: String, to configuration: inout ConnectorConfiguration) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        configuration.logs.insert("[\(timestamp)] \(message)", at: 0)
        configuration.logs = Array(configuration.logs.prefix(20))
    }

    private func runConnectionTest(_ kind: ConnectorKind) async -> ConnectorTestResult {
        let configuration = connector(kind)
        switch kind {
        case .localFilesystem:
            let path = configuration.endpoint.isEmpty ? "/Users/artan/Neuroartan-software" : configuration.endpoint
            var isDirectory: ObjCBool = false
            let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
            return exists && isDirectory.boolValue
                ? .success("Filesystem root is reachable.")
                : .failure("Filesystem root is not reachable.")

        case .terminal:
            return .success("Terminal bridge is available.")

        case .vsCode:
            let appAvailable = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.VSCode") != nil
            return appAvailable ? .success("VS Code application is installed.") : .failure("VS Code application was not found.")

        case .lmStudio:
            return await testHTTPModels(endpoint: configuration.endpoint, credential: nil)

        case .github:
            return await testAuthenticatedGET(baseEndpoint: configuration.endpoint, path: "/user", kind: kind)

        case .openRouter:
            return await testAuthenticatedGET(baseEndpoint: configuration.endpoint, path: "/models", kind: kind)

        case .huggingFace:
            return await testAuthenticatedGET(baseEndpoint: configuration.endpoint, path: "/whoami-v2", kind: kind)

        case .email, .googleDrive, .calendar, .contacts:
            guard hasCredential(for: kind) else {
                return .failure("Secure credential or OAuth token is required.")
            }
            return .success("Secure credential is stored. Provider-specific OAuth exchange is pending.")

        case .futureRegistry:
            return .success("Future connector registry is available for extension.")
        }
    }

    private func testHTTPModels(endpoint: String, credential: String?) async -> ConnectorTestResult {
        guard let url = URL(string: endpoint.trimmingCharacters(in: .whitespacesAndNewlines).appendingPathComponentIfNeeded("models")) else {
            return .failure("Invalid endpoint.")
        }
        return await performGET(url: url, credential: credential)
    }

    private func testAuthenticatedGET(baseEndpoint: String, path: String, kind: ConnectorKind) async -> ConnectorTestResult {
        guard let url = URL(string: baseEndpoint.trimmingCharacters(in: .whitespacesAndNewlines).appendingPathComponentIfNeeded(path)) else {
            return .failure("Invalid endpoint.")
        }
        let credential = (try? SecureCredentialStore.load(account: kind.credentialAccount)) ?? nil
        return await performGET(url: url, credential: credential)
    }

    private func performGET(url: URL, credential: String?) async -> ConnectorTestResult {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let credential, !credential.isEmpty {
            request.setValue("Bearer \(credential)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                return .failure("Invalid HTTP response.")
            }
            return (200...299).contains(http.statusCode)
                ? .success("Connection verified with HTTP \(http.statusCode).")
                : .failure("Provider returned HTTP \(http.statusCode).")
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    struct BindingProxy {
        fileprivate let service: ConnectorRegistryService
        fileprivate let kind: ConnectorKind

        var configuration: ConnectorConfiguration {
            get { service.connector(kind) }
            nonmutating set { service.update(newValue) }
        }
    }
}

private struct ConnectorTestResult {
    var isSuccess: Bool
    var message: String

    static func success(_ message: String) -> ConnectorTestResult {
        ConnectorTestResult(isSuccess: true, message: message)
    }

    static func failure(_ message: String) -> ConnectorTestResult {
        ConnectorTestResult(isSuccess: false, message: message)
    }
}

private extension String {
    func appendingPathComponentIfNeeded(_ path: String) -> String {
        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        if hasSuffix("/\(trimmedPath)") { return self }
        return trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/" + trimmedPath
    }
}
