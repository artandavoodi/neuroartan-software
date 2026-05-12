import Foundation
import Combine

@MainActor
final class ShellState: ObservableObject {
    @Published var isSidebarCollapsed = false
    @Published var isSecondarySidebarVisible = false
    @Published var isBottomPanelVisible = false
    @Published var selectedBottomPanel: BottomPanelRoute = .problems
    @Published var expandedSections: Set<SidebarSection.ID> = []
    @Published var webSearchEnabled = false
    @Published var browserAgentEnabled = false
    @Published var activeProject = "ICOS"
    @Published var workExecutionMode = "Balanced"
    @Published var processingMode = "Adaptive"

    func toggleSection(_ section: SidebarSection) {
        if expandedSections.contains(section.id) {
            expandedSections.remove(section.id)
        } else {
            expandedSections.insert(section.id)
        }
    }
}

enum BottomPanelRoute: String, CaseIterable, Identifiable {
    case problems
    case terminal
    case output
    case debug

    var id: String { rawValue }

    var title: String {
        switch self {
        case .problems: return "Problems"
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .debug: return "Debug"
        }
    }

    var icon: ICOSIcon {
        switch self {
        case .problems: return .bug
        case .terminal: return .command
        case .output: return .log
        case .debug: return .configuration
        }
    }
}

struct SidebarSection: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: ICOSIcon
    let items: [AppRouter.Route]

    static let all: [SidebarSection] = [
        SidebarSection(
            id: "home",
            title: "Home",
            icon: .home,
            items: [
                .chat,
                .developer,
                .continuity,
                .settings
            ]
        ),

        SidebarSection(
            id: "workspace",
            title: "Workspace",
            icon: .workspace,
            items: [
                .projects,
                .files,
                .recents,
                .shared,
                .archive
            ]
        ),

        SidebarSection(
            id: "intelligence",
            title: "Intelligence",
            icon: .thought,
            items: [
                .intelligenceDashboard,
                .sessions,
                .providers,
                .connections,
                .terminalRuntime,
                .knowledgeBase,
                .kanban,
                .automationJobs,
                .usage,
                .mail,
                .messaging,
                .skills,
                .diagnostics,
                .voiceRuntime,
                .desktopRuntime
            ]
        )
    ]

    static let defaultExpandedIDs = all.map(\.id)
}
