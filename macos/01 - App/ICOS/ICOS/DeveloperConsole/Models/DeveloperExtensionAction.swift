import Foundation

enum DeveloperExtensionAction: String, CaseIterable, Identifiable {
    case attachFile = "Attach File"
    case activeFile = "Read Active File"
    case terminal = "Terminal"
    case visualStudioCode = "VS Code"
    case syncVSCode = "Sync VS Code"
    case xcode = "Xcode"
    case textEdit = "TextEdit"
    case webSearch = "Web Search"

    case voice = "Voice"

    static let allCases: [DeveloperExtensionAction] = [
        .attachFile,
        .activeFile,
        .terminal,
        .visualStudioCode,
        .syncVSCode,
        .xcode,
        .textEdit,
        .webSearch,
        .voice
    ]

    var id: String { rawValue }

    var icon: ICOSIcon {
        switch self {
        case .attachFile:
            return .file
        case .activeFile:
            return .file
        case .terminal:
            return .terminal
        case .visualStudioCode:
            return .fileManager
        case .syncVSCode:
            return .sync
        case .xcode:
            return .workspace
        case .textEdit:
            return .file
        case .webSearch:
            return .browserUse
        case .voice:
            return .voice
        }
    }
}

enum DeveloperComposerMode: String, CaseIterable, Identifiable {
    case ask = "Ask"
    case edit = "Edit"
    case review = "Review"
    case terminal = "Terminal"
    case debug = "Debug"

    var id: String { rawValue }

    var icon: ICOSIcon {
        switch self {
        case .ask: return .ask
        case .edit: return .rename
        case .review: return .review
        case .terminal: return .terminal
        case .debug: return .bug
        }
    }
}
