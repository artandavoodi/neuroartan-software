import Foundation
import AppKit
import UniformTypeIdentifiers

/* =============================================================================
   00) ACTIVE FILE STATE
============================================================================= */
struct ActiveFileContext {
    let path: String
    let fileName: String
    let workspaceRoot: String
    let detectedAt: Date
    let content: String
    let fileExtension: String
    let fileType: String
}

/* =============================================================================
   00A) FILE TYPE RESOLUTION
============================================================================= */
private func resolveFileType(path: String) -> String {

    let fileExtension = URL(fileURLWithPath: path)
        .pathExtension
        .lowercased()

    switch fileExtension {
    case "swift":
        return "swift_source"

    case "js", "mjs", "ts", "tsx":
        return "javascript_runtime"

    case "css":
        return "style_source"

    case "md":
        return "documentation"

    case "json":
        return "configuration"

    default:
        return "generic_source"
    }
}

/* =============================================================================
   01) ACTIVE FILE BRIDGE
============================================================================= */
final class ActiveFileBridge {

    static let shared = ActiveFileBridge()

    private(set) var activeContext: ActiveFileContext?

    private init() {}

    /* -------------------------------------------------------------------------
       ACTIVE FILE DETECTION
    ------------------------------------------------------------------------- */
    func refreshActiveFile() {

        guard let editor = NSWorkspace.shared
            .frontmostApplication else {
            return
        }

        let applicationName = editor.localizedName ?? "Unknown"

        RuntimeEventBus.shared.emit(
            type: .activeFileChanged,
            payload: [
                "application": applicationName,
                "status": "editor_detected"
            ]
        )
    }

    /* -------------------------------------------------------------------------
       ACTIVE FILE REGISTRATION
    ------------------------------------------------------------------------- */
    func register(
        path: String,
        workspaceRoot: String
    ) {

        let content = (
            try? String(
                contentsOfFile: path,
                encoding: .utf8
            )
        ) ?? ""

        let fileExtension = URL(fileURLWithPath: path)
            .pathExtension
            .lowercased()

        let context = ActiveFileContext(
            path: path,
            fileName: URL(fileURLWithPath: path)
                .lastPathComponent,
            workspaceRoot: workspaceRoot,
            detectedAt: Date(),
            content: content,
            fileExtension: fileExtension,
            fileType: resolveFileType(path: path)
        )

        self.activeContext = context

        RuntimeEventBus.shared.emit(
            type: .activeFileChanged,
            payload: [
                "path": path,
                "workspaceRoot": workspaceRoot,
                "fileName": context.fileName,
                "fileExtension": context.fileExtension,
                "fileType": context.fileType,
                "contentLength": String(context.content.count)
            ]
        )
    }

    /* -------------------------------------------------------------------------
       ACTIVE FILE CONTENT ACCESS
    ------------------------------------------------------------------------- */
    func currentFileContent() -> String? {
        activeContext?.content
    }

    func currentFileType() -> String? {
        activeContext?.fileType
    }

    func currentFileExtension() -> String? {
        activeContext?.fileExtension
    }

    /* -------------------------------------------------------------------------
       ACTIVE FILE ACCESS
    ------------------------------------------------------------------------- */
    func currentFilePath() -> String? {
        activeContext?.path
    }

    func currentWorkspaceRoot() -> String? {
        activeContext?.workspaceRoot
    }

    func currentFileName() -> String? {
        activeContext?.fileName
    }

    func hasActiveFile() -> Bool {
        activeContext != nil
    }
}
