import Foundation

enum AgentRuntimeKind: String, Codable, CaseIterable, Identifiable {
    case localModel
    case frontierProvider
    case repositoryDevelopment
    case terminal
    case fileEditing
    case research
    case emailAware
    case githubAware
    case projectManagement
    case custom

    var id: String { rawValue }
}

enum AgentTaskState: String, Codable {
    case queued
    case running
    case waitingForApproval
    case completed
    case failed
}

struct AgentProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var kind: AgentRuntimeKind
    var providerConnector: ConnectorKind
    var assignedModelID: String?
    var systemRole: String
    var instructions: String?
    var rules: [String]?
    var boundaries: [String]?
    var scripts: [String]?
    var skills: [String]?
    var workspaceScope: String?
    var projectScope: String?
    var isEnabled: Bool?
    var enabledTools: Set<AgentToolPermission>
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        kind: AgentRuntimeKind,
        providerConnector: ConnectorKind,
        assignedModelID: String? = nil,
        systemRole: String,
        instructions: String? = nil,
        rules: [String]? = nil,
        boundaries: [String]? = nil,
        scripts: [String]? = nil,
        skills: [String]? = nil,
        workspaceScope: String? = nil,
        projectScope: String? = nil,
        isEnabled: Bool? = true,
        enabledTools: Set<AgentToolPermission> = []
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.providerConnector = providerConnector
        self.assignedModelID = assignedModelID
        self.systemRole = systemRole
        self.instructions = instructions
        self.rules = rules
        self.boundaries = boundaries
        self.scripts = scripts
        self.skills = skills
        self.workspaceScope = workspaceScope
        self.projectScope = projectScope
        self.isEnabled = isEnabled
        self.enabledTools = enabledTools
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum AgentToolPermission: String, Codable, CaseIterable, Identifiable {
    case fileRead
    case fileWrite
    case terminal
    case git
    case vsCode
    case buildTest
    case providerRouting
    case connectorAccess
    case patchApply
    case rollback

    var id: String { rawValue }
}

struct AgentRuntimeTask: Identifiable, Codable, Hashable {
    let id: UUID
    var agentID: UUID
    var title: String
    var prompt: String
    var workspaceRoot: String?
    var state: AgentTaskState
    var logs: [String]
    var createdAt: Date
    var updatedAt: Date

    init(agentID: UUID, title: String, prompt: String, workspaceRoot: String?) {
        self.id = UUID()
        self.agentID = agentID
        self.title = title
        self.prompt = prompt
        self.workspaceRoot = workspaceRoot
        self.state = .queued
        self.logs = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct RepositoryAwarenessMap: Codable, Hashable {
    var rootPath: String
    var folderCount: Int
    var fileCount: Int
    var swiftFileCount: Int
    var scriptCount: Int
    var promptCount: Int
    var designTokenCount: Int
    var buildCommandCandidates: [String]
    var testCommandCandidates: [String]
    var indexedAt: Date
}
