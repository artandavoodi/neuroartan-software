import Foundation
import AppKit
import Combine

struct FileNode: Identifiable, Hashable {
    let id: URL
    let url: URL
    let name: String
    let isDirectory: Bool
    let children: [FileNode]
}

@MainActor
final class WorkspaceFileService: ObservableObject {
    @Published var rootURL: URL?
    @Published var rootNode: FileNode?
    @Published var selectedURL: URL?
    @Published var statusText = ""
    @Published var isRenaming = false
    @Published var renameText = ""
    @Published var activeFiles: [URL] = []
    @Published var filePreview = ""
    @Published var editableContent = ""
    @Published var isFileDirty = false
    @Published var terminalCommand = ""
    @Published var terminalOutput = ""
    @Published var isRunningCommand = false
    @Published var terminalStatus: TerminalExecutionStatus = .idle
    @Published var terminalHistory: [TerminalStreamEvent] = []
    @Published var lastPatchStatus = ""
    @Published var pendingDeleteURL: URL?
    private var terminalCancellationRequested = false

    private let permissionService: PermissionService
    private let externalEditorBridge: ExternalEditorBridge
    private let workspaceRootKey = "ICOS.WorkspaceFileService.ActiveRootPath"
    private let blockedTerminalMarkers = [
        "rm -rf",
        "sudo ",
        "mkfs",
        "diskutil erase",
        "shutdown",
        "reboot",
        ":(){",
    ]

    init(permissionService: PermissionService, externalEditorBridge: ExternalEditorBridge) {
        self.permissionService = permissionService
        self.externalEditorBridge = externalEditorBridge
        restorePersistedWorkspace()
    }

    func loadPreviewWorkspace() {
        guard let rootURL else {
            statusText = "No active workspace selected."
            return
        }

        reload()
        selectedURL = rootURL
        filePreview = "Directory: \(rootURL.path)"
        editableContent = filePreview
        activeFiles = []
        statusText = "Active workspace: \(rootURL.lastPathComponent)"
    }

    var selectedIsDirectory: Bool {
        guard let selectedURL else { return false }
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: selectedURL.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }

    func importDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            PermissionGate.shared.registerAuthorizedRoot(url.path)
            guard permissionService.validate(.fileRead, action: "import-directory", url: url) else {
                statusText = "Directory import blocked by permission policy."
                return
            }

            setWorkspaceRoot(url)
        }
    }

    func setWorkspaceRoot(_ url: URL) {
        let standardized = url.standardizedFileURL
        guard permissionService.validate(.fileRead, action: "set-workspace-root", url: standardized) else {
            statusText = "Workspace selection blocked by permission policy."
            return
        }

        rootNode = nil
        selectedURL = nil
        activeFiles = []
        filePreview = ""
        editableContent = ""
        isFileDirty = false

        rootURL = standardized
        selectedURL = standardized
        UserDefaults.standard.set(standardized.path, forKey: workspaceRootKey)
        WorkspaceGraph.shared.registerWorkspace(root: standardized.path)
        reload()
        statusText = "Active workspace: \(standardized.lastPathComponent)"
    }

    func attachFileUsingPanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        if let rootURL {
            panel.directoryURL = rootURL
        }

        if panel.runModal() == .OK, let url = panel.url {
            if rootURL == nil {
                PermissionGate.shared.registerAuthorizedRoot(url.deletingLastPathComponent().path)
                setWorkspaceRoot(url.deletingLastPathComponent())
            }

            guard permissionService.validate(.fileRead, action: "attach-file", url: url) else {
                statusText = "Attach file blocked by permission policy."
                return
            }

            selectedURL = url
            addSelectedToActiveFiles()
            loadSelectedPreview()
            reload()
            statusText = "Attached \(url.lastPathComponent)."
        }
    }

    func reload() {
        guard let rootURL else { return }
        guard permissionService.validate(.fileRead, action: "reload-tree", url: rootURL) else {
            statusText = "Reload blocked by permission policy."
            return
        }
        WorkspaceGraph.shared.registerWorkspace(root: rootURL.path)
        WorkspaceGraph.shared.indexWorkspace()
        rootNode = buildNode(url: rootURL)
        statusText = "Workspace indexed: \(WorkspaceGraph.shared.totalFiles()) files."
    }

    func select(_ url: URL) {
        guard validateInsideWorkspace(url) else {
            statusText = "Selection blocked outside active workspace."
            return
        }
        selectedURL = url
        isRenaming = false
        statusText = ""
        isFileDirty = false
        loadSelectedPreview()
        registerActiveContextIfNeeded(url)
    }

    func createFile() {
        guard permissionService.validate(.fileWrite, action: "create-file", url: selectedURL) else {
            statusText = "Create file blocked by permission policy."
            return
        }
        guard let directory = targetDirectory() else { return }
        let url = uniqueURL(in: directory, base: "Untitled", extensionName: "md")
        let created = FileManager.default.createFile(atPath: url.path, contents: Data(), attributes: nil)
        statusText = created ? "Created \(url.lastPathComponent)" : "Could not create file."
        reload()
    }

    func addSelectedToActiveFiles() {
        guard let selectedURL, !selectedIsDirectory else {
            attachFileUsingPanel()
            return
        }
        if !activeFiles.contains(selectedURL) {
            activeFiles.append(selectedURL)
        }
        registerActiveContextIfNeeded(selectedURL)
        statusText = "Added active file: \(selectedURL.lastPathComponent)"
    }

    func removeActiveFile(_ url: URL) {
        activeFiles.removeAll { $0 == url }
    }

    func openSelectedInVSCode() {
        guard let targetURL = selectedURL ?? rootURL else {
            attachFileUsingPanel()
            return
        }
        externalEditorBridge.openInVSCode(target: targetURL, workspaceRoot: rootURL)
        statusText = externalEditorBridge.statusText
    }

    func openRootInTerminal() {
        guard let rootURL else { return }
        NSWorkspace.shared.open(rootURL)
        statusText = "Opened workspace directory."
    }

    func openRootInXcode() {
        guard let rootURL else {
            importDirectory()
            return
        }
        externalEditorBridge.openInXcode(workspaceRoot: rootURL, selectedFile: selectedURL)
        statusText = externalEditorBridge.statusText
    }

    func openSelectedInTextEdit() {
        guard let selectedURL, !selectedIsDirectory else {
            attachFileUsingPanel()
            return
        }
        externalEditorBridge.openInTextEdit(target: selectedURL)
        statusText = externalEditorBridge.statusText
    }

    func syncActiveFileFromVSCode() {
        externalEditorBridge.refreshActiveEditorState()
        guard let state = externalEditorBridge.lastEditorState else {
            statusText = "No VS Code active-file bridge state found."
            return
        }

        let activeURL = URL(fileURLWithPath: state.activeFilePath)
        let root = URL(fileURLWithPath: state.workspaceRoot, isDirectory: true)
        setWorkspaceRoot(root)
        selectedURL = activeURL
        addSelectedToActiveFiles()
        loadSelectedPreview()
        statusText = "Synced active file from \(state.editor): \(activeURL.lastPathComponent)"
    }

    func updateEditableContent(_ content: String) {
        editableContent = content
        isFileDirty = editableContent != filePreview
    }

    func saveSelectedFile() {
        guard let selectedURL, !selectedIsDirectory else { return }
        guard permissionService.validate(.fileWrite, action: "save-file", url: selectedURL) else {
            statusText = "Save blocked by permission policy."
            return
        }

        RollbackManager.shared.createSnapshot(filePath: selectedURL.path)
        let result = PatchEngine.shared.applyPatch(filePath: selectedURL.path, updatedContent: editableContent)
        lastPatchStatus = result.message

        if result.success {
            filePreview = editableContent
            isFileDirty = false
            statusText = "Applied patch to \(selectedURL.lastPathComponent)."
            reload()
        } else {
            statusText = "Patch failed: \(result.message)"
        }
    }

    func rollbackSelectedFile() {
        guard let selectedURL, !selectedIsDirectory else { return }
        guard permissionService.validate(.fileWrite, action: "rollback-file", url: selectedURL) else {
            statusText = "Rollback blocked by permission policy."
            return
        }

        let result = RollbackManager.shared.rollback(filePath: selectedURL.path)
        lastPatchStatus = result.message
        statusText = result.message
        if result.success {
            loadSelectedPreview()
            reload()
        }
    }

    func runTerminalCommand() {
        let command = terminalCommand.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !command.isEmpty else { return }
        guard let rootURL else {
            terminalOutput = "Import a workspace directory before running commands."
            terminalStatus = .failed
            return
        }
        guard permissionService.validate(.terminalExecution, action: "terminal-command", url: rootURL) else {
            terminalOutput = "Terminal execution blocked. Grant terminal permission first."
            terminalStatus = .failed
            return
        }

        let lower = command.lowercased()
        guard !blockedTerminalMarkers.contains(where: { lower.contains($0) }) else {
            terminalOutput = "Command blocked by local safety policy."
            terminalStatus = .failed
            return
        }

        isRunningCommand = true
        terminalCancellationRequested = false
        terminalStatus = .running
        terminalOutput = "Running: \(command)\n"

        TerminalBridge.shared.execute(
            command: command,
            workingDirectory: rootURL.path,
            onOutput: { event in
                Task { @MainActor in
                    self.terminalOutput = event.output
                }
            }
        ) { event in
            Task { @MainActor in
                self.terminalOutput = event.output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? "Command completed with no output."
                    : event.output
                self.terminalHistory.insert(event, at: 0)
                self.terminalHistory = Array(self.terminalHistory.prefix(40))
                self.isRunningCommand = false
                if self.terminalCancellationRequested {
                    self.terminalStatus = .cancelled
                    self.terminalCancellationRequested = false
                } else {
                    self.terminalStatus = event.exitCode == 0 ? .completed : .failed
                }
            }
        }
    }

    func cancelTerminalCommand() {
        guard isRunningCommand else { return }
        terminalCancellationRequested = true
        TerminalBridge.shared.cancelCurrentCommand()
        isRunningCommand = false
        terminalStatus = .cancelled
        terminalOutput += terminalOutput.hasSuffix("\n") ? "Command cancelled.\n" : "\nCommand cancelled.\n"
    }

    func clearTerminalOutput() {
        terminalOutput = ""
        terminalStatus = .idle
    }

    func copyTerminalOutput() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(terminalOutput, forType: .string)
        statusText = "Copied terminal output."
    }

    func createFolder() {
        guard permissionService.validate(.fileWrite, action: "create-folder", url: selectedURL) else {
            statusText = "Create folder blocked by permission policy."
            return
        }
        guard let directory = targetDirectory() else { return }
        let url = uniqueURL(in: directory, base: "New Folder", extensionName: nil)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
            statusText = "Created \(url.lastPathComponent)"
        } catch {
            statusText = error.localizedDescription
        }
        reload()
    }

    func prepareRename() {
        guard let selectedURL else { return }
        renameText = selectedURL.lastPathComponent
        isRenaming = true
    }

    func commitRename() {
        guard permissionService.validate(.fileWrite, action: "rename", url: selectedURL) else {
            statusText = "Rename blocked by permission policy."
            return
        }
        guard let selectedURL else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let destination = selectedURL.deletingLastPathComponent().appendingPathComponent(trimmed)
        do {
            try FileManager.default.moveItem(at: selectedURL, to: destination)
            self.selectedURL = destination
            statusText = "Renamed to \(trimmed)"
        } catch {
            statusText = error.localizedDescription
        }
        isRenaming = false
        reload()
    }

    func cancelRename() {
        isRenaming = false
        renameText = ""
    }

    func deleteSelected() {
        pendingDeleteURL = selectedURL
    }

    func requestDelete(_ url: URL) {
        guard validateInsideWorkspace(url) else {
            statusText = "Delete blocked outside active workspace."
            return
        }
        selectedURL = url
        pendingDeleteURL = url
    }

    func cancelPendingDelete() {
        pendingDeleteURL = nil
    }

    func confirmPendingDelete() {
        guard let pendingDeleteURL else { return }
        selectedURL = pendingDeleteURL
        self.pendingDeleteURL = nil
        deleteSelectedImmediately()
    }

    private func deleteSelectedImmediately() {
        guard permissionService.validate(.fileWrite, action: "delete", url: selectedURL) else {
            statusText = "Delete blocked by permission policy."
            return
        }
        guard let selectedURL, selectedURL != rootURL else { return }
        do {
            try FileManager.default.trashItem(at: selectedURL, resultingItemURL: nil)
            self.selectedURL = rootURL
            statusText = "Moved to Trash."
        } catch {
            statusText = error.localizedDescription
        }
        reload()
    }

    func moveSelected() {
        guard permissionService.validate(.fileWrite, action: "move", url: selectedURL) else {
            statusText = "Move blocked by permission policy."
            return
        }
        guard let selectedURL, selectedURL != rootURL else { return }

        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Move Here"

        guard panel.runModal() == .OK, let destinationDirectory = panel.url else { return }
        let destination = destinationDirectory.appendingPathComponent(selectedURL.lastPathComponent)

        do {
            try FileManager.default.moveItem(at: selectedURL, to: destination)
            self.selectedURL = destination
            statusText = "Moved to \(destinationDirectory.lastPathComponent)."
        } catch {
            statusText = error.localizedDescription
        }
        reload()
    }

    func revealInFinder(_ url: URL? = nil) {
        let target = url ?? selectedURL ?? rootURL
        guard let target else { return }
        NSWorkspace.shared.activateFileViewerSelecting([target])
        statusText = "Revealed \(target.lastPathComponent) in Finder."
    }

    func copyRelativePath(_ url: URL? = nil) {
        let target = url ?? selectedURL
        guard let target else { return }
        let text = relativePath(for: target)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        statusText = "Copied relative path: \(text)"
    }

    func relativePath(for url: URL) -> String {
        guard let rootURL else { return url.path }
        let rootPath = rootURL.standardizedFileURL.path
        let path = url.standardizedFileURL.path
        guard path.hasPrefix(rootPath) else { return path }
        let relative = path.dropFirst(rootPath.count).trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return relative.isEmpty ? "." : String(relative)
    }

    func metadata(for url: URL) -> WorkspaceFileMetadata {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        let values = try? url.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey])
        let itemCount: Int
        if isDirectory.boolValue {
            itemCount = ((try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []).count
        } else {
            itemCount = 0
        }

        let lineCount: Int?
        if !isDirectory.boolValue,
           let data = try? Data(contentsOf: url, options: [.mappedIfSafe]),
           let text = String(data: data.prefix(120_000), encoding: .utf8) {
            lineCount = text.components(separatedBy: .newlines).count
        } else {
            lineCount = nil
        }

        return WorkspaceFileMetadata(
            name: url.lastPathComponent,
            absolutePath: url.path,
            relativePath: relativePath(for: url),
            isDirectory: isDirectory.boolValue,
            fileExtension: url.pathExtension,
            byteSize: values?.fileSize,
            lineCount: lineCount,
            itemCount: itemCount,
            modifiedAt: values?.contentModificationDate
        )
    }

    func runtimeContextSnapshot(
        userInput: String,
        project: ICOSProject?,
        agent: AgentProfile?,
        runtime: RuntimeSettingsState,
        mode: DeveloperComposerMode?,
        webSearchEnabled: Bool
    ) -> String {
        let selectedFileBlock = selectedFileContextBlock()
        let activeFileBlock = activeFilesContextBlock(excluding: selectedURL)
        let treeBlock = workspaceTreeContextBlock()
        let projectBlock = projectContextBlock(project)
        let agentBlock = agentContextBlock(agent)

        return """
        ICOS Runtime Context:
        ICOS has already read the local workspace context below through its native file, project, terminal, model, and agent services. Use this context directly. If a selected workspace, project, file, or file snippet is present, do not claim that you cannot access local files.

        Execution:
        - Composer Mode: \(mode?.rawValue ?? "Session")
        - Web Search Enabled: \(webSearchEnabled ? "yes" : "no")
        - Provider: \(runtime.activeProviderTitle)
        - Model: \(runtime.activeModelTitle)
        - Endpoint: \(runtime.activeEndpointTitle)

        Workspace:
        - Active Root: \(rootURL?.path ?? "none")
        - Selected Path: \(selectedURL?.path ?? "none")
        - Terminal CWD: \(rootURL?.path ?? "none")
        - Terminal Status: \(terminalStatus.rawValue)
        - Terminal Last Output:
        \(bounded(terminalOutput, limit: 2_000))

        \(projectBlock)

        \(agentBlock)

        Workspace Tree:
        \(treeBlock)

        Selected File Context:
        \(selectedFileBlock)

        Active File Context:
        \(activeFileBlock)

        User Request:
        \(userInput)
        """
    }

    private func targetDirectory() -> URL? {
        guard let selectedURL else { return rootURL }
        return selectedIsDirectory ? selectedURL : selectedURL.deletingLastPathComponent()
    }

    private func restorePersistedWorkspace() {
        guard let path = UserDefaults.standard.string(forKey: workspaceRootKey), !path.isEmpty else { return }
        let url = URL(fileURLWithPath: path, isDirectory: true)
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else { return }
        rootURL = url
        selectedURL = url
        WorkspaceGraph.shared.registerWorkspace(root: url.path)
        reload()
    }

    private func validateInsideWorkspace(_ url: URL) -> Bool {
        guard let rootURL else { return true }
        let rootPath = rootURL.standardizedFileURL.path
        let candidate = url.standardizedFileURL.path
        return candidate == rootPath || candidate.hasPrefix(rootPath + "/")
    }

    private func loadSelectedPreview() {
        guard let selectedURL else {
            filePreview = ""
            return
        }

        if selectedIsDirectory {
            filePreview = "Directory: \(selectedURL.path)"
            editableContent = filePreview
            isFileDirty = false
            return
        }

        guard let data = try? Data(contentsOf: selectedURL, options: [.mappedIfSafe]) else {
            filePreview = "Preview unavailable."
            return
        }

        let limited = data.prefix(80_000)
        filePreview = String(data: limited, encoding: .utf8) ?? "Binary or unsupported file preview."
        editableContent = filePreview
        isFileDirty = false
    }

    private func registerActiveContextIfNeeded(_ url: URL) {
        guard !selectedIsDirectory, let rootURL else { return }
        ActiveFileBridge.shared.register(path: url.path, workspaceRoot: rootURL.path)
    }

    private func buildNode(url: URL) -> FileNode {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)

        let children: [FileNode]
        if isDirectory.boolValue {
            let urls = (try? FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )) ?? []

            children = urls
                .sorted { lhs, rhs in
                    lhs.lastPathComponent.localizedStandardCompare(rhs.lastPathComponent) == .orderedAscending
                }
                .prefix(200)
                .map { buildNode(url: $0) }
        } else {
            children = []
        }

        return FileNode(id: url, url: url, name: url.lastPathComponent, isDirectory: isDirectory.boolValue, children: children)
    }

    private func uniqueURL(in directory: URL, base: String, extensionName: String?) -> URL {
        func candidate(_ index: Int) -> URL {
            let suffix = index == 0 ? "" : " \(index)"
            let name = base + suffix
            if let extensionName {
                return directory.appendingPathComponent(name).appendingPathExtension(extensionName)
            }
            return directory.appendingPathComponent(name)
        }

        var index = 0
        while FileManager.default.fileExists(atPath: candidate(index).path) {
            index += 1
        }
        return candidate(index)
    }

    private func selectedFileContextBlock() -> String {
        guard let selectedURL else { return "none" }
        let meta = metadata(for: selectedURL)
        if meta.isDirectory {
            return """
            Directory: \(meta.relativePath)
            Absolute Path: \(meta.absolutePath)
            Item Count: \(meta.itemCount)
            Modified: \(meta.modifiedAt?.formatted() ?? "unknown")
            """
        }

        return """
        File: \(meta.relativePath)
        Absolute Path: \(meta.absolutePath)
        Type: \(meta.fileExtension.isEmpty ? "unknown" : meta.fileExtension)
        Size: \(meta.byteSize.map(String.init) ?? "unknown") bytes
        Lines: \(meta.lineCount.map(String.init) ?? "unknown")
        Modified: \(meta.modifiedAt?.formatted() ?? "unknown")
        Content:
        \(bounded(filePreview, limit: 16_000))
        """
    }

    private func activeFilesContextBlock(excluding selected: URL?) -> String {
        let urls = activeFiles.filter { $0 != selected }
        guard !urls.isEmpty else { return "none" }

        return urls.prefix(6).map { url in
            let meta = metadata(for: url)
            let content = textPreview(for: url, limit: 8_000)
            return """
            File: \(meta.relativePath)
            Absolute Path: \(meta.absolutePath)
            Type: \(meta.fileExtension.isEmpty ? "unknown" : meta.fileExtension)
            Content:
            \(content)
            """
        }
        .joined(separator: "\n\n")
    }

    private func workspaceTreeContextBlock() -> String {
        guard let rootNode else { return "No indexed workspace tree." }
        var lines: [String] = []
        appendTreeLines(rootNode, depth: 0, lines: &lines)
        return lines.isEmpty ? "No indexed workspace tree." : lines.joined(separator: "\n")
    }

    private func appendTreeLines(_ node: FileNode, depth: Int, lines: inout [String]) {
        guard lines.count < 120 else { return }
        let prefix = String(repeating: "  ", count: depth)
        let marker = node.isDirectory ? "/" : ""
        lines.append("\(prefix)- \(relativePath(for: node.url))\(marker)")
        node.children.prefix(40).forEach { child in
            appendTreeLines(child, depth: depth + 1, lines: &lines)
        }
    }

    private func projectContextBlock(_ project: ICOSProject?) -> String {
        guard let project else { return "Project:\n- Active Project: none" }
        return """
        Project:
        - Name: \(project.name)
        - Directory: \(project.path ?? "none")
        - Description: \(project.projectDescription ?? project.metadata)
        - Definition: \(project.definition ?? "none")
        - Objectives: \(project.objectives?.joined(separator: ", ") ?? "none")
        - Goals: \(project.goals?.joined(separator: ", ") ?? "none")
        - Status: \(project.status ?? "none")
        - Repository Metadata: \(project.repositoryMetadata ?? "none")
        """
    }

    private func agentContextBlock(_ agent: AgentProfile?) -> String {
        guard let agent else { return "Agent:\n- Active Agent: none" }
        let tools = agent.enabledTools.map(\.rawValue).sorted().joined(separator: ", ")
        return """
        Agent:
        - Name: \(agent.name)
        - Kind: \(agent.kind.rawValue)
        - Role: \(agent.systemRole)
        - Provider Connector: \(agent.providerConnector.rawValue)
        - Assigned Model: \(agent.assignedModelID ?? "runtime-selected model")
        - Enabled: \((agent.isEnabled ?? true) ? "yes" : "no")
        - Workspace Scope: \(agent.workspaceScope ?? "active workspace")
        - Project Scope: \(agent.projectScope ?? "active project")
        - Tools: \(tools.isEmpty ? "none" : tools)
        - Instructions: \(agent.instructions ?? agent.systemRole)
        - Rules: \(agent.rules?.joined(separator: "; ") ?? "Use ICOS governance, local-first owner resolution, permission gates, and safe edits.")
        - Boundaries: \(agent.boundaries?.joined(separator: "; ") ?? "Do not bypass ICOS context, do not invent file paths, do not claim unavailable local access when context is provided.")
        - Skills: \(agent.skills?.joined(separator: ", ") ?? "none")
        - Scripts: \(agent.scripts?.joined(separator: ", ") ?? "none")
        """
    }

    private func textPreview(for url: URL, limit: Int) -> String {
        guard validateInsideWorkspace(url),
              let data = try? Data(contentsOf: url, options: [.mappedIfSafe]),
              let text = String(data: data.prefix(limit), encoding: .utf8)
        else {
            return "Binary or unsupported file preview."
        }

        return bounded(text, limit: limit)
    }

    private func bounded(_ text: String, limit: Int) -> String {
        guard text.count > limit else {
            return text.isEmpty ? "none" : text
        }

        let index = text.index(text.startIndex, offsetBy: limit)
        return String(text[..<index]) + "\n[truncated]"
    }
}

struct WorkspaceFileMetadata: Hashable {
    let name: String
    let absolutePath: String
    let relativePath: String
    let isDirectory: Bool
    let fileExtension: String
    let byteSize: Int?
    let lineCount: Int?
    let itemCount: Int
    let modifiedAt: Date?
}
