import Foundation
import Combine

@MainActor
final class DeveloperWorkspaceService: ObservableObject {
    enum Section: String, CaseIterable, Identifiable {
        case plan = "Plan"
        case files = "Files"
        case terminal = "Terminal"
        case review = "Review"
        case build = "Build"
        case deploy = "Deploy"
        case integrations = "Integrations"

        var id: String { rawValue }

        var icon: ICOSIcon {
            switch self {
            case .plan: return .knowledge
            case .files: return .fileManager
            case .terminal: return .console
            case .review: return .search
            case .build: return .configuration
            case .deploy: return .cloud
            case .integrations: return .key
            }
        }
    }

    @Published var selectedSection: Section = .plan
    @Published var requestText = ""
    @Published var currentPlan: DeveloperExecutionPlan?
    @Published var searchQuery = ""
    @Published var searchResults: [DeveloperSearchResult] = []
    @Published var reviewOutput = ""
    @Published var buildOutput = ""
    @Published var deploymentOutput = ""
    @Published var agentAnalysisOutput = ""
    @Published var agentCanonicalOwner = ""
    @Published var agentRuntimeStatus = "Agent runtime not started."
    @Published var statusText = "Developer workspace ready."
    @Published var isWorking = false
    @Published var runtimeEvents: [RuntimeEvent] = []

    private let permissionService: PermissionService
    private let workspaceFileService: WorkspaceFileService
    private weak var projectManager: ProjectManagerViewModel?
    private weak var appState: ICOSAppState?
    private let previewMode: Bool
    private var eventSubscription: UUID?

    init(permissionService: PermissionService, workspaceFileService: WorkspaceFileService, previewMode: Bool = false) {
        self.permissionService = permissionService
        self.workspaceFileService = workspaceFileService
        self.previewMode = previewMode
        subscribeToRuntimeEvents()
    }

    deinit {
        if let token = eventSubscription {
            Task { @MainActor in
                RuntimeEventBus.shared.unsubscribe(token)
            }
        }
    }

    var activeWorkspacePath: String? {
        workspaceFileService.rootURL?.path
    }

    var isSearchActive: Bool {
        !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func bindSearchSources(projectManager: ProjectManagerViewModel, appState: ICOSAppState) {
        self.projectManager = projectManager
        self.appState = appState
    }

    func searchResultProject(id: UUID) -> ICOSProject? {
        projectManager?.projects.first { $0.id == id }
    }

    var tools: [DeveloperToolDescriptor] {
        DeveloperToolRegistry.tools.map { tool in
            guard let permission = tool.requiredPermission else { return tool }
            var updated = tool
            if permissionService.grants.contains(permission) {
                updated.status = tool.status == .needsConfiguration ? .needsConfiguration : .available
            }
            return updated
        }
    }

    func createPlan() {
        let request = requestText.trimmingCharacters(in: .whitespacesAndNewlines)
        let workspace = activeWorkspacePath
        let normalizedIntent = normalizeIntent(request)

        currentPlan = DeveloperExecutionPlan(
            request: request.isEmpty ? "No request entered." : request,
            normalizedIntent: normalizedIntent,
            workspacePath: workspace,
            steps: [
                DeveloperPlanStep(title: "Resolve Workspace", detail: workspace ?? "No workspace imported yet.", kind: .resolveWorkspace, isComplete: workspace != nil),
                DeveloperPlanStep(title: "Classify Intent", detail: normalizedIntent, kind: .classifyIntent, isComplete: !request.isEmpty),
                DeveloperPlanStep(title: "Search Locally", detail: "Use local file search before any external lookup.", kind: .localSearch),
                DeveloperPlanStep(title: "Resolve Owner Chain", detail: "Identify canonical owner files before editing.", kind: .ownerChain),
                DeveloperPlanStep(title: "Draft Edit", detail: "Edit through the governed file editor only.", kind: .editDraft),
                DeveloperPlanStep(title: "Verify", detail: "Re-run search, build, or local command verification.", kind: .verify)
            ]
        )

        statusText = "Execution plan created."
    }

    func analyzeRequestWithAgent() {
        let request = requestText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !request.isEmpty else {
            agentAnalysisOutput = "Enter a request before running agent analysis."
            return
        }

        if previewMode {
            agentAnalysisOutput = """
            {
              "preview": true,
              "intent": "local_development",
              "owner_chain": {
                "canonical_owner": {
                  "path": "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/DeveloperConsole/Views/DeveloperConsoleView.swift"
                }
              }
            }
            """
            agentCanonicalOwner = "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/DeveloperConsole/Views/DeveloperConsoleView.swift"
            statusText = "Preview owner chain resolved."
            return
        }

        isWorking = true
        agentAnalysisOutput = "Analyzing request through local-first developer engine..."
        agentCanonicalOwner = ""

        Task.detached {
            let payload: [String: String] = ["request_text": request]
            let payloadData = try? JSONSerialization.data(withJSONObject: payload, options: [])
            let payloadText = payloadData.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
            let script = "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Developer/Scripts/02_developer_agent_cli.py"

            let result = Self.runProcess(
                executable: script,
                arguments: ["analyze_request", "--payload", payloadText],
                directory: URL(fileURLWithPath: "/Users/artan/Neuroartan-software")
            )

            let output = Self.combinedOutput(result, defaultText: "No analysis output.")
            let canonicalOwner = Self.extractCanonicalOwner(from: output)

            await MainActor.run {
                self.agentAnalysisOutput = output
                self.agentCanonicalOwner = canonicalOwner
                self.statusText = canonicalOwner.isEmpty ? "Agent analysis completed." : "Owner resolved: \(URL(fileURLWithPath: canonicalOwner).lastPathComponent)"
                self.isWorking = false
            }
        }
    }

    func runSearch() {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        isWorking = true
        statusText = "Searching developer context."

        let contextResults = projectSearchResults(query: query) + sessionSearchResults(query: query)
        let treeResults = workspaceTreeSearchResults(query: query)
        searchResults = Array((contextResults + treeResults).prefix(120))

        guard let rootURL = workspaceFileService.rootURL else {
            statusText = searchResults.isEmpty ? "No local matches found." : "Found \(searchResults.count) context matches."
            isWorking = false
            return
        }

        guard permissionService.validate(.fileRead, action: "developer-local-search", url: rootURL) else {
            statusText = "File search blocked by permission policy."
            isWorking = false
            return
        }

        Task.detached { [rootURL, contextResults, treeResults] in
            let contentMatches = Self.runProcess(
                executable: "/usr/bin/env",
                arguments: ["rg", "--line-number", "--fixed-strings", "--max-count", "80", query, rootURL.path],
                directory: rootURL
            )

            let pathMatches = Self.runProcess(
                executable: "/usr/bin/env",
                arguments: ["find", rootURL.path, "-maxdepth", "8", "-iname", "*\(query)*"],
                directory: rootURL
            )

            let contentTuples = contentMatches.output
                .split(separator: "\n")
                .prefix(80)
                .compactMap { line -> (String, Int?, String)? in
                    let parts = line.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false)
                    guard parts.count >= 3 else {
                        return nil
                    }
                    return (String(parts[0]), Int(parts[1]), String(parts[2]))
                }

            let fileTuples = pathMatches.output
                .split(separator: "\n")
                .prefix(80)
                .map { path in
                    var isDirectory: ObjCBool = false
                    FileManager.default.fileExists(atPath: String(path), isDirectory: &isDirectory)
                    return (String(path), isDirectory.boolValue)
                }

            await MainActor.run {
                let contentResults = contentTuples.map { path, line, preview in
                    DeveloperSearchResult(path: path, line: line, preview: preview, kind: .content)
                }
                let fileResults = fileTuples.map { path, isDirectory in
                    DeveloperSearchResult(
                        path: path,
                        line: nil,
                        preview: isDirectory ? "Folder path match" : "File path match",
                        kind: isDirectory ? .folder : .file
                    )
                }
                var seen = Set<String>()
                let merged = (contextResults + treeResults + fileResults + contentResults).filter { result in
                    let key = "\(result.path):\(result.line.map(String.init) ?? "")"
                    guard !seen.contains(key) else { return false }
                    seen.insert(key)
                    return true
                }
                self.searchResults = Array(merged.prefix(120))
                self.statusText = self.searchResults.isEmpty ? "No local matches found." : "Found \(self.searchResults.count) context matches."
                self.isWorking = false
            }
        }
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
        statusText = "Developer workspace ready."
    }

    private func projectSearchResults(query: String) -> [DeveloperSearchResult] {
        let lower = query.lowercased()
        return projectManager?.projects.compactMap { project in
            let haystack = [
                project.name,
                project.metadata,
                project.path ?? "",
                project.projectDescription ?? "",
                project.definition ?? "",
                project.status ?? "",
                project.repositoryMetadata ?? "",
                project.objectives?.joined(separator: " ") ?? "",
                project.goals?.joined(separator: " ") ?? "",
                project.members?.joined(separator: " ") ?? ""
            ].joined(separator: " ").lowercased()

            guard haystack.contains(lower) else { return nil }
            return DeveloperSearchResult(
                path: project.path ?? "project://\(project.id.uuidString)",
                line: nil,
                preview: "Project: \(project.name)",
                kind: .project,
                projectID: project.id
            )
        } ?? []
    }

    private func sessionSearchResults(query: String) -> [DeveloperSearchResult] {
        let lower = query.lowercased()
        guard let appState else { return [] }
        let matchingMessages = appState.activeSession.messages.filter {
            $0.content.lowercased().contains(lower)
        }
        let activeSessionResults = matchingMessages.prefix(20).map { message in
            DeveloperSearchResult(
                path: "session://\(appState.activeSession.sessionID.uuidString)",
                line: nil,
                preview: "\(message.role.rawValue): \(message.content)",
                kind: .session,
                sessionID: appState.activeSession.sessionID
            )
        }

        let storedSessionResults = SessionStore().listSessions()
            .filter { summary in
                summary.title.lowercased().contains(lower)
                    || summary.id.uuidString.lowercased().contains(lower)
            }
            .prefix(20)
            .map { summary in
                DeveloperSearchResult(
                    path: "session://\(summary.id.uuidString)",
                    line: nil,
                    preview: "Session: \(summary.title) · \(summary.messageCount) messages",
                    kind: .session,
                    sessionID: summary.id
                )
            }

        var seen = Set<UUID>()
        return (activeSessionResults + storedSessionResults).filter { result in
            guard let id = result.sessionID else { return true }
            guard !seen.contains(id) else { return false }
            seen.insert(id)
            return true
        }
    }

    private func workspaceTreeSearchResults(query: String) -> [DeveloperSearchResult] {
        guard let rootNode = workspaceFileService.rootNode else { return [] }
        let lower = query.lowercased()
        var results: [DeveloperSearchResult] = []

        func visit(_ node: FileNode) {
            guard results.count < 80 else { return }
            let relative = workspaceFileService.relativePath(for: node.url)
            if node.name.lowercased().contains(lower) || relative.lowercased().contains(lower) {
                results.append(
                    DeveloperSearchResult(
                        path: node.url.path,
                        line: nil,
                        preview: node.isDirectory ? "Folder: \(relative)" : "File: \(relative)",
                        kind: node.isDirectory ? .folder : .file
                    )
                )
            }
            node.children.forEach(visit)
        }

        visit(rootNode)
        return results
    }

    func runGitStatus() {
        guard let rootURL = workspaceFileService.rootURL else {
            reviewOutput = "Import a workspace before reviewing."
            return
        }
        guard permissionService.validate(.fileRead, action: "developer-git-status", url: rootURL) else {
            reviewOutput = "Review blocked by permission policy."
            return
        }

        isWorking = true
        reviewOutput = "Running git status..."
        Task.detached { [rootURL] in
            let result = Self.runProcess(executable: "/usr/bin/env", arguments: ["git", "status", "--short"], directory: rootURL)
            await MainActor.run {
                self.reviewOutput = Self.combinedOutput(result, defaultText: "Working tree clean.")
                self.isWorking = false
            }
        }
    }

    func runXcodeBuild() {
        guard let rootURL = workspaceFileService.rootURL else {
            buildOutput = "Import a workspace before building."
            return
        }
        guard permissionService.validate(.buildExecution, action: "developer-xcode-build", url: rootURL) else {
            buildOutput = "Build blocked. Grant build execution permission first."
            return
        }

        isWorking = true
        buildOutput = "Running xcodebuild..."
        Task.detached { [rootURL] in
            let result = Self.runProcess(executable: "/usr/bin/env", arguments: ["xcodebuild", "-scheme", "ICOS", "-configuration", "Debug", "build"], directory: rootURL)
            await MainActor.run {
                self.buildOutput = Self.combinedOutput(result, defaultText: "Build completed with no output.")
                self.isWorking = false
            }
        }
    }

    func prepareDeployment() {
        guard permissionService.validate(.deploymentExecution, action: "developer-prepare-deployment", url: workspaceFileService.rootURL) else {
            deploymentOutput = "Deployment blocked. Grant deployment execution permission first."
            return
        }
        deploymentOutput = "Deployment adapter ready. Configure a project deployment target before running release commands."
    }

    func indexActiveRepositoryForAgents(using agentRuntime: AgentRuntimeService) {
        guard let root = activeWorkspacePath else {
            agentRuntimeStatus = "Import a workspace before indexing for agents."
            return
        }

        agentRuntime.indexRepository(rootPath: root)
        agentRuntimeStatus = "Agent repository indexing started."
    }

    func queueSelfImprovementAgent(using agentRuntime: AgentRuntimeService) {
        agentRuntime.enqueueSelfImprovementAudit(workspaceRoot: activeWorkspacePath)
        agentRuntimeStatus = "Self-development agent task queued."
    }

    private func normalizeIntent(_ request: String) -> String {
        let lower = request.lowercased()
        if lower.contains("fix") || lower.contains("change") || lower.contains("replace") {
            return "Local edit intent"
        }
        if lower.contains("review") || lower.contains("audit") {
            return "Repository review intent"
        }
        if lower.contains("build") || lower.contains("test") {
            return "Verification intent"
        }
        if lower.contains("deploy") {
            return "Deployment intent"
        }
        return request.isEmpty ? "Waiting for request" : "General developer intent"
    }

    private func subscribeToRuntimeEvents() {
        eventSubscription = RuntimeEventBus.shared.subscribe { [weak self] event in
            Task { @MainActor in
                guard let self else { return }
                self.runtimeEvents.insert(event, at: 0)
                self.runtimeEvents = Array(self.runtimeEvents.prefix(80))
                self.statusText = self.statusTextForEvent(event)
            }
        }
    }

    private func statusTextForEvent(_ event: RuntimeEvent) -> String {
        switch event.type {
        case .runtimeBoot:
            return "Runtime event bus active."
        case .activeFileChanged:
            return "Active file: \(event.payload["fileName"] ?? event.payload["application"] ?? "updated")"
        case .terminalOutput:
            return "Terminal command completed."
        case .patchApplied:
            return "Patch event completed."
        case .patchRejected:
            return "Patch or permission event rejected."
        case .workspaceIndexed:
            return "Workspace indexed."
        case .modelChanged:
            return "Model routing updated."
        case .runtimeShutdown:
            return "Runtime shutdown."
        }
    }

    nonisolated private static func runProcess(executable: String, arguments: [String], directory: URL) -> DeveloperProcessResult {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        process.currentDirectoryURL = directory
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        do {
            try process.run()
            process.waitUntilExit()
            let output = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let error = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            return DeveloperProcessResult(exitCode: process.terminationStatus, output: output, error: error)
        } catch {
            return DeveloperProcessResult(exitCode: -1, output: "", error: error.localizedDescription)
        }
    }

    nonisolated private static func combinedOutput(_ result: DeveloperProcessResult, defaultText: String) -> String {
        let combined = [result.output, result.error]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        return combined.isEmpty ? defaultText : combined
    }

    nonisolated private static func extractCanonicalOwner(from output: String) -> String {
        guard let data = output.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let ownerChain = json["owner_chain"] as? [String: Any],
              let owner = ownerChain["canonical_owner"] as? [String: Any],
              let path = owner["path"] as? String else {
            return ""
        }
        return path
    }
}

private struct DeveloperProcessResult {
    var exitCode: Int32
    var output: String
    var error: String
}
