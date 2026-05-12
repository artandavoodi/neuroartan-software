import Foundation

enum ConnectorKind: String, Codable, CaseIterable, Identifiable {
    case email
    case github
    case googleDrive
    case calendar
    case contacts
    case localFilesystem
    case vsCode
    case terminal
    case lmStudio
    case openRouter
    case huggingFace
    case futureRegistry

    var id: String { rawValue }

    var title: String {
        switch self {
        case .email: return "Email"
        case .github: return "GitHub"
        case .googleDrive: return "Google Drive"
        case .calendar: return "Calendar"
        case .contacts: return "Contacts"
        case .localFilesystem: return "Local Filesystem"
        case .vsCode: return "VS Code"
        case .terminal: return "Terminal"
        case .lmStudio: return "LM Studio"
        case .openRouter: return "OpenRouter"
        case .huggingFace: return "Hugging Face"
        case .futureRegistry: return "Future Connector Registry"
        }
    }

    var credentialAccount: String { "connector.\(rawValue).credential" }
}

enum ConnectorAuthenticationState: String, Codable {
    case notConfigured = "Not Configured"
    case configured = "Configured"
    case verified = "Verified"
    case failed = "Failed"
}

enum ConnectorPermissionState: String, Codable {
    case disabled = "Disabled"
    case userOnly = "User Only"
    case agentAllowed = "Agent Allowed"
}

struct ConnectorConfiguration: Identifiable, Codable, Hashable {
    var id: ConnectorKind { kind }
    var kind: ConnectorKind
    var isEnabled: Bool
    var endpoint: String
    var usernameOrAccount: String
    var authenticationState: ConnectorAuthenticationState
    var permissionState: ConnectorPermissionState
    var lastError: String
    var lastTestedAt: Date?
    var logs: [String]

    static func defaults(for kind: ConnectorKind) -> ConnectorConfiguration {
        ConnectorConfiguration(
            kind: kind,
            isEnabled: defaultEnabled(for: kind),
            endpoint: defaultEndpoint(for: kind),
            usernameOrAccount: "",
            authenticationState: .notConfigured,
            permissionState: defaultEnabled(for: kind) ? .userOnly : .disabled,
            lastError: "",
            lastTestedAt: nil,
            logs: []
        )
    }

    private static func defaultEnabled(for kind: ConnectorKind) -> Bool {
        switch kind {
        case .localFilesystem, .terminal, .vsCode, .lmStudio:
            return true
        default:
            return false
        }
    }

    private static func defaultEndpoint(for kind: ConnectorKind) -> String {
        switch kind {
        case .github: return "https://api.github.com"
        case .lmStudio: return "http://127.0.0.1:1234/v1"
        case .openRouter: return "https://openrouter.ai/api/v1"
        case .huggingFace: return "https://huggingface.co/api"
        case .localFilesystem: return "/Users/artan/Neuroartan-software"
        default: return ""
        }
    }
}
