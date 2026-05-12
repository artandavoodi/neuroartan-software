import Foundation

enum DeveloperToolCategory: String, Codable, CaseIterable, Identifiable {
    case planning = "Planning"
    case repository = "Repository"
    case editing = "Editing"
    case review = "Review"
    case terminal = "Terminal"
    case build = "Build"
    case deployment = "Deployment"
    case integration = "Integration"

    var id: String { rawValue }
}

enum DeveloperToolStatus: String, Codable {
    case available = "Available"
    case permissionRequired = "Permission Required"
    case needsConfiguration = "Needs Configuration"
    case planned = "Planned"
}

struct DeveloperToolDescriptor: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var summary: String
    var category: DeveloperToolCategory
    var status: DeveloperToolStatus
    var requiredPermission: ICOSPermissionDimension?
}

enum DeveloperPlanStepKind: String, Codable {
    case resolveWorkspace
    case classifyIntent
    case localSearch
    case ownerChain
    case editDraft
    case verify
    case review
    case terminal
    case build
    case deploy
}

struct DeveloperPlanStep: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var detail: String
    var kind: DeveloperPlanStepKind
    var isComplete: Bool

    init(title: String, detail: String, kind: DeveloperPlanStepKind, isComplete: Bool = false) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.kind = kind
        self.isComplete = isComplete
    }
}

struct DeveloperExecutionPlan: Identifiable, Codable, Hashable {
    let id: UUID
    var request: String
    var normalizedIntent: String
    var workspacePath: String?
    var steps: [DeveloperPlanStep]
    var createdAt: Date

    init(request: String, normalizedIntent: String, workspacePath: String?, steps: [DeveloperPlanStep]) {
        self.id = UUID()
        self.request = request
        self.normalizedIntent = normalizedIntent
        self.workspacePath = workspacePath
        self.steps = steps
        self.createdAt = Date()
    }
}

enum DeveloperSearchResultKind: String, Codable, Hashable {
    case file
    case folder
    case content
    case project
    case session
}

struct DeveloperSearchResult: Identifiable, Codable, Hashable {
    let id: UUID
    var path: String
    var line: Int?
    var preview: String
    var kind: DeveloperSearchResultKind
    var projectID: UUID?
    var sessionID: UUID?

    init(
        path: String,
        line: Int? = nil,
        preview: String,
        kind: DeveloperSearchResultKind = .content,
        projectID: UUID? = nil,
        sessionID: UUID? = nil
    ) {
        self.id = UUID()
        self.path = path
        self.line = line
        self.preview = preview
        self.kind = kind
        self.projectID = projectID
        self.sessionID = sessionID
    }
}
