import SwiftUI

// MARK: - Intelligence Module

struct IntelligenceModule: Identifiable, Hashable {
    let route: AppRouter.Route
    let title: String
    let summary: String
    let status: IntelligenceModuleStatus
    let capabilities: [String]
    let assetName: String?

    var id: AppRouter.Route { route }
    var icon: ICOSIcon { route.icon }
}

enum IntelligenceModuleStatus: String, Hashable {
    case active = "Active"
    case foundational = "Foundation"
    case pendingConnector = "Connector Required"

    var tint: Color {
        switch self {
        case .active:
            return ICOSColors.online
        case .foundational:
            return ICOSColors.warning
        case .pendingConnector:
            return ICOSColors.textSecondary
        }
    }
}

// MARK: - Catalog

enum IntelligenceModuleCatalog {
    static let modules: [IntelligenceModule] = [
        IntelligenceModule(
            route: .sessions,
            title: "Sessions",
            summary: "Conversation state, prompt execution, tool output review, and continuity tracking.",
            status: .foundational,
            capabilities: ["Session history", "Message review", "Tool output", "Continuity"],
            assetName: "session-runtime"
        ),
        IntelligenceModule(
            route: .providers,
            title: "Providers",
            summary: "Local and cloud model routing, provider configuration, and runtime selection.",
            status: .active,
            capabilities: ["LM Studio", "Local model routing", "Frontier providers", "Runtime status"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .connections,
            title: "Connections",
            summary: "Operational connector profiles, credentials, permission state, and verification.",
            status: .active,
            capabilities: ["Credentials", "Permissions", "Connection tests", "Logs"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .terminalRuntime,
            title: "Terminal",
            summary: "Shell execution, validation commands, streamed output, and approval gates.",
            status: .active,
            capabilities: ["Command execution", "Build/test", "Output streaming", "Permission gate"],
            assetName: "terminal-runtime"
        ),
        IntelligenceModule(
            route: .knowledgeBase,
            title: "Knowledge Base",
            summary: "Structured knowledge, source documents, indexed notes, and retrieval surfaces.",
            status: .foundational,
            capabilities: ["Collections", "Sources", "Search", "Retrieval"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .kanban,
            title: "Kanban",
            summary: "Task planning, work state, execution queues, and operational review.",
            status: .foundational,
            capabilities: ["Tasks", "Queues", "Review", "Execution state"],
            assetName: "operations-board"
        ),
        IntelligenceModule(
            route: .automationJobs,
            title: "Automation",
            summary: "Scheduled work, recurring jobs, background task state, and operational logs.",
            status: .foundational,
            capabilities: ["Schedules", "Cron jobs", "Logs", "Retry state"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .usage,
            title: "Usage",
            summary: "Runtime metrics, provider usage, session volume, and operational cost visibility.",
            status: .foundational,
            capabilities: ["Metrics", "Usage charts", "Provider totals", "Session analytics"],
            assetName: "usage-analytics"
        ),
        IntelligenceModule(
            route: .mail,
            title: "Mail",
            summary: "Email-aware agent surface with connector-controlled access and review.",
            status: .pendingConnector,
            capabilities: ["Inbox access", "Drafting", "Review", "Connector permissions"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .messaging,
            title: "Messaging",
            summary: "External messaging runtime, verification, and communication workflows.",
            status: .pendingConnector,
            capabilities: ["Setup", "Verification", "Outbound review", "Message logs"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .skills,
            title: "Skills",
            summary: "Reusable agent capabilities, tool definitions, and governed execution profiles.",
            status: .foundational,
            capabilities: ["Skill registry", "Metadata", "Actions", "Permissions"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .diagnostics,
            title: "Diagnostics",
            summary: "Runtime health checks, environment validation, and repair guidance.",
            status: .active,
            capabilities: ["Health checks", "Build state", "Runtime checks", "Repair actions"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .voiceRuntime,
            title: "Voice Runtime",
            summary: "Voice input, realtime speech interaction, voice profile, and future training workflows.",
            status: .foundational,
            capabilities: ["Transcription", "Voice profile", "Realtime panel", "Speech runtime"],
            assetName: nil
        ),
        IntelligenceModule(
            route: .desktopRuntime,
            title: "Desktop Runtime",
            summary: "Desktop automation, app control, preview surfaces, and live environment access.",
            status: .foundational,
            capabilities: ["Desktop view", "App control", "Preview", "Runtime bridge"],
            assetName: "workspace-files"
        )
    ]

    static func module(for route: AppRouter.Route) -> IntelligenceModule? {
        modules.first { $0.route == route }
    }
}
