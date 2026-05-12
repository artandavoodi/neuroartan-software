import Foundation
import AppKit
import Combine

struct ExternalEditorState: Codable, Equatable {
    var editor: String
    var activeFilePath: String
    var workspaceRoot: String
    var updatedAt: Date
}

@MainActor
final class ExternalEditorBridge: ObservableObject {
    static let shared = ExternalEditorBridge()

    @Published private(set) var statusText = "Editor bridge idle."
    @Published private(set) var vscodeAvailable = false
    @Published private(set) var xcodeAvailable = false
    @Published private(set) var lastEditorState: ExternalEditorState?

    private let fileManager = FileManager.default
    private let appSupportDirectory: URL
    private let bridgeDirectory: URL
    private let activeStateURL: URL

    init() {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ICOS", isDirectory: true)
        self.appSupportDirectory = base
        self.bridgeDirectory = base.appendingPathComponent("editor_bridge", isDirectory: true)
        self.activeStateURL = bridgeDirectory.appendingPathComponent("active-editor-state.json")
        ensureBridgeDirectory()
        refreshAvailability()
        refreshActiveEditorState()
    }

    var vscodeExtensionBridgePath: String {
        activeStateURL.path
    }

    func refreshAvailability() {
        vscodeAvailable = fileManager.fileExists(atPath: "/Applications/Visual Studio Code.app")
            || executableExists("code")
        xcodeAvailable = fileManager.fileExists(atPath: "/Applications/Xcode.app")
    }

    func refreshActiveEditorState() {
        guard let data = try? Data(contentsOf: activeStateURL),
              let state = try? JSONDecoder().decode(ExternalEditorState.self, from: data) else {
            lastEditorState = nil
            return
        }
        lastEditorState = state
        statusText = "Active \(state.editor) file: \(URL(fileURLWithPath: state.activeFilePath).lastPathComponent)"
    }

    func openInVSCode(target: URL?, workspaceRoot: URL?) {
        refreshAvailability()

        guard let target = target ?? workspaceRoot else {
            statusText = "Select a file or import a workspace before opening VS Code."
            return
        }

        if executableExists("code") {
            runDetached("/usr/bin/env", arguments: ["code", target.path], success: "Opened in VS Code.")
            return
        }

        openWithApplication(
            applicationPath: "/Applications/Visual Studio Code.app",
            target: target,
            success: "Opened in Visual Studio Code.",
            failurePrefix: "Could not open Visual Studio Code"
        )
    }

    func openInXcode(workspaceRoot: URL?, selectedFile: URL?) {
        refreshAvailability()

        guard let workspaceRoot else {
            statusText = "Import a workspace before opening Xcode."
            return
        }

        let projectTarget = xcodeProjectTarget(in: workspaceRoot) ?? selectedFile ?? workspaceRoot
        openWithApplication(
            applicationPath: "/Applications/Xcode.app",
            target: projectTarget,
            success: "Opened in Xcode.",
            failurePrefix: "Could not open Xcode"
        )
    }

    func openInTextEdit(target: URL?) {
        guard let target else {
            statusText = "Select a file before opening TextEdit."
            return
        }

        openWithApplication(
            applicationPath: "/System/Applications/TextEdit.app",
            target: target,
            success: "Opened in TextEdit.",
            failurePrefix: "Could not open TextEdit"
        )
    }

    func writeActiveEditorState(editor: String, activeFile: URL, workspaceRoot: URL) {
        ensureBridgeDirectory()
        let state = ExternalEditorState(
            editor: editor,
            activeFilePath: activeFile.path,
            workspaceRoot: workspaceRoot.path,
            updatedAt: Date()
        )

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            try encoder.encode(state).write(to: activeStateURL, options: [.atomic])
            lastEditorState = state
            statusText = "Editor bridge state updated."
        } catch {
            statusText = "Could not write editor bridge state: \(error.localizedDescription)"
        }
    }

    private func openWithApplication(applicationPath: String, target: URL, success: String, failurePrefix: String) {
        let applicationURL = URL(fileURLWithPath: applicationPath)
        guard fileManager.fileExists(atPath: applicationURL.path) else {
            statusText = "\(failurePrefix): application not installed."
            return
        }

        NSWorkspace.shared.open([target], withApplicationAt: applicationURL, configuration: NSWorkspace.OpenConfiguration()) { _, error in
            Task { @MainActor in
                self.statusText = error.map { "\(failurePrefix): \($0.localizedDescription)" } ?? success
            }
        }
    }

    private func runDetached(_ executable: String, arguments: [String], success: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments

        do {
            try process.run()
            statusText = success
        } catch {
            statusText = "Editor command failed: \(error.localizedDescription)"
        }
    }

    private func xcodeProjectTarget(in root: URL) -> URL? {
        let children = (try? fileManager.contentsOfDirectory(
            at: root,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )) ?? []

        return children.first { $0.pathExtension.lowercased() == "xcworkspace" }
            ?? children.first { $0.pathExtension.lowercased() == "xcodeproj" }
    }

    private func executableExists(_ executable: String) -> Bool {
        let paths = ["/usr/local/bin", "/opt/homebrew/bin", "/usr/bin", "/bin"]
        return paths.contains { fileManager.isExecutableFile(atPath: "\($0)/\(executable)") }
    }

    private func ensureBridgeDirectory() {
        if !fileManager.fileExists(atPath: appSupportDirectory.path) {
            try? fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true)
        }
        if !fileManager.fileExists(atPath: bridgeDirectory.path) {
            try? fileManager.createDirectory(at: bridgeDirectory, withIntermediateDirectories: true)
        }
    }
}
