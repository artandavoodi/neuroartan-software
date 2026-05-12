import Foundation
import Combine

@MainActor
final class AgentRuntimeService: ObservableObject {
    static let shared = AgentRuntimeService()

    @Published private(set) var agents: [AgentProfile] = []
    @Published private(set) var tasks: [AgentRuntimeTask] = []
    @Published private(set) var repositoryMaps: [RepositoryAwarenessMap] = []
    @Published private(set) var statusText = "Agent runtime ready."
    @Published var selectedAgentID: UUID?

    private let storageURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(storageURL: URL? = nil) {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let baseURL = appSupport.appendingPathComponent("ICOS/agent-runtime", isDirectory: true)
        self.storageURL = storageURL ?? baseURL.appendingPathComponent("agent-runtime-state.json")
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        load()
        ensureDefaultAgents()
    }

    func ensureDefaultAgents() {
        guard agents.isEmpty else {
            if selectedAgentID == nil {
                selectedAgentID = agents.first?.id
                save()
            }
            return
        }
        agents = [
            AgentProfile(
                name: "Repository Development Agent",
                kind: .repositoryDevelopment,
                providerConnector: .lmStudio,
                systemRole: "Scan local repositories, resolve owner files, propose patches, and verify builds.",
                enabledTools: [.fileRead, .fileWrite, .terminal, .git, .vsCode, .buildTest, .patchApply, .rollback]
            ),
            AgentProfile(
                name: "Research Agent",
                kind: .research,
                providerConnector: .openRouter,
                systemRole: "Research external sources only when explicitly permitted.",
                enabledTools: [.providerRouting, .connectorAccess]
            )
        ]
        selectedAgentID = agents.first?.id
        save()
    }

    func createAgent(
        name: String,
        kind: AgentRuntimeKind,
        providerConnector: ConnectorKind,
        role: String,
        tools: Set<AgentToolPermission>
    ) {
        agents.append(
            AgentProfile(
                name: name,
                kind: kind,
                providerConnector: providerConnector,
                systemRole: role,
                enabledTools: tools
            )
        )
        statusText = "Agent created."
        save()
    }

    func enqueueTask(agentID: UUID, title: String, prompt: String, workspaceRoot: String?) {
        var task = AgentRuntimeTask(agentID: agentID, title: title, prompt: prompt, workspaceRoot: workspaceRoot)
        appendLog("Task queued.", to: &task)
        tasks.insert(task, at: 0)
        statusText = "Agent task queued."
        save()
    }

    func enqueueSelfImprovementAudit(workspaceRoot: String?) {
        guard let agent = agents.first(where: { $0.kind == .repositoryDevelopment }) ?? agents.first else {
            statusText = "No agent profile exists."
            return
        }

        enqueueTask(
            agentID: agent.id,
            title: "Self-development audit",
            prompt: "Audit ICOS and propose a better version of yourself. Preserve architecture, identify owner files, propose safe patches, run build verification, and record changes.",
            workspaceRoot: workspaceRoot
        )
    }

    func indexRepository(rootPath: String) {
        let rootURL = URL(fileURLWithPath: rootPath).standardizedFileURL
        Task.detached {
            let map = Self.buildRepositoryMap(rootURL: rootURL)
            await MainActor.run {
                self.repositoryMaps.removeAll { $0.rootPath == map.rootPath }
                self.repositoryMaps.insert(map, at: 0)
                self.statusText = "Repository indexed: \(rootURL.lastPathComponent)"
                self.save()
            }
        }
    }

    func indexNeuroartanSoftwareRoots() {
        let sourceAbsorptionRoot = "/Users/artan/Neuroartan-software/" + ["her", "mes-desktop-", "os", "1-main"].joined()
        [
            "/Users/artan/Neuroartan-software",
            "/Users/artan/Neuroartan-software/macos/01 - App/ICOS",
            sourceAbsorptionRoot
        ].forEach(indexRepository(rootPath:))
    }

    private func load() {
        do {
            let data = try Data(contentsOf: storageURL)
            let state = try decoder.decode(AgentRuntimeState.self, from: data)
            agents = state.agents
            tasks = state.tasks
            repositoryMaps = state.repositoryMaps
            selectedAgentID = state.selectedAgentID
        } catch {
            agents = []
            tasks = []
            repositoryMaps = []
            selectedAgentID = nil
        }
    }

    private func save() {
        do {
            try FileManager.default.createDirectory(at: storageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let state = AgentRuntimeState(agents: agents, tasks: tasks, repositoryMaps: repositoryMaps, selectedAgentID: selectedAgentID)
            let data = try encoder.encode(state)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            statusText = "Agent runtime save failed: \(error.localizedDescription)"
        }
    }

    private func appendLog(_ message: String, to task: inout AgentRuntimeTask) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        task.logs.insert("[\(timestamp)] \(message)", at: 0)
        task.updatedAt = Date()
    }

    nonisolated private static func buildRepositoryMap(rootURL: URL) -> RepositoryAwarenessMap {
        var folderCount = 0
        var fileCount = 0
        var swiftFileCount = 0
        var scriptCount = 0
        var promptCount = 0
        var designTokenCount = 0
        var buildCommands: Set<String> = []
        var testCommands: Set<String> = []

        if FileManager.default.fileExists(atPath: rootURL.appendingPathComponent("Package.swift").path) {
            buildCommands.insert("swift build")
            testCommands.insert("swift test")
        }

        if FileManager.default.fileExists(atPath: rootURL.appendingPathComponent("ICOS.xcodeproj").path) ||
            FileManager.default.fileExists(atPath: rootURL.appendingPathComponent("macos/01 - App/ICOS/ICOS.xcodeproj").path) {
            buildCommands.insert("xcodebuild -scheme ICOS -configuration Debug build")
        }

        let enumerator = FileManager.default.enumerator(
            at: rootURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        )

        while let url = enumerator?.nextObject() as? URL {
            let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
            if values?.isDirectory == true {
                folderCount += 1
                continue
            }

            fileCount += 1
            let ext = url.pathExtension.lowercased()
            if ext == "swift" { swiftFileCount += 1 }
            if ["py", "sh", "js", "ts"].contains(ext) { scriptCount += 1 }
            if ["md", "prompt"].contains(ext) || url.lastPathComponent.lowercased().contains("prompt") { promptCount += 1 }
            if url.path.lowercased().contains("tokens") || url.path.lowercased().contains("designsystem") { designTokenCount += 1 }
        }

        return RepositoryAwarenessMap(
            rootPath: rootURL.path,
            folderCount: folderCount,
            fileCount: fileCount,
            swiftFileCount: swiftFileCount,
            scriptCount: scriptCount,
            promptCount: promptCount,
            designTokenCount: designTokenCount,
            buildCommandCandidates: Array(buildCommands).sorted(),
            testCommandCandidates: Array(testCommands).sorted(),
            indexedAt: Date()
        )
    }

    var selectedAgent: AgentProfile? {
        if let selectedAgentID, let agent = agents.first(where: { $0.id == selectedAgentID }) {
            return agent
        }
        return agents.first
    }

    func selectAgent(id: UUID) {
        selectedAgentID = id
        statusText = agents.first(where: { $0.id == id }).map { "Selected agent: \($0.name)" } ?? "Selected agent unavailable."
        save()
    }
}

private struct AgentRuntimeState: Codable {
    var agents: [AgentProfile]
    var tasks: [AgentRuntimeTask]
    var repositoryMaps: [RepositoryAwarenessMap]
    var selectedAgentID: UUID?
}
