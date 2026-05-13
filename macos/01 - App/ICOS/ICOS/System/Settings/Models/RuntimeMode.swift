import Foundation

// MARK: - Runtime Mode
// Defines how ICOS routes inference between local and cloud.

public enum RuntimeMode: String, CaseIterable, Identifiable, Codable {
    case local = "local"
    case cloud = "cloud"
    case auto = "auto"

    public var id: String { rawValue }

    // MARK: - Display

    var title: String {
        switch self {
        case .local:
            return "Local"
        case .cloud:
            return "Cloud"
        case .auto:
            return "Auto"
        }
    }

    var description: String {
        switch self {
        case .local:
            return "Runs entirely on-device using local models."
        case .cloud:
            return "Uses cloud frontier models for maximum capability."
        case .auto:
            return "Automatically selects the best provider based on task complexity."
        }
    }
}
