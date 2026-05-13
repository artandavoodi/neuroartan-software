import SwiftUI
import Combine

/// ICOS App Router
/// Central navigation controller for SwiftUI application flow
public final class AppRouter: ObservableObject {

    // MARK: - Navigation State
    @Published public var currentRoute: Route = .chat
    @Published public var selectedSettingsCategory: Route = .general
    @Published public var selectedProjectName: String = "ICOS"

    @Published private var backwardHistory: [NavigationEntry] = []
    @Published private var forwardHistory: [NavigationEntry] = []

    public var currentDisplayTitle: String {
        currentRoute == .settings ? selectedSettingsCategory.title : currentRoute.title
    }

    public var canNavigateBack: Bool {
        !backwardHistory.isEmpty
    }

    public var canNavigateForward: Bool {
        !forwardHistory.isEmpty
    }

    public var isTitlebarNavigationVisible: Bool {
        currentRoute == .settings
    }

    public init() {
        publishTitlebarNavigationState()
    }

    // MARK: - Navigation Entry

    private struct NavigationEntry: Equatable {
        let route: Route
        let settingsCategory: Route
    }

    // MARK: - Routes
    public enum Route: String, CaseIterable, Identifiable {
        case chat
        case developer
        case continuity
        case settings

        // MARK: - Workspace Runtime

        case projects
        case files
        case recents
        case shared
        case archive

        // MARK: - Intelligence Runtime

        case intelligenceDashboard
        case sessions
        case providers
        case connections
        case terminalRuntime
        case knowledgeBase
        case kanban
        case automationJobs
        case usage
        case mail
        case messaging
        case skills
        case diagnostics
        case voiceRuntime
        case desktopRuntime

        // MARK: - Settings Categories

        case general
        case appearance
        case voice
        case permissions
        case privacy
        case accessibility
        case configuration
        case connectors
        case personalization
        case dashboard
        case storageBackup
        case security

        // MARK: - Configuration Subroutes

        case environment
        case worktree
        case browserUse
        case chatManagement

        public var id: String { rawValue }

        var title: String {
            switch self {
            case .chat: return "Chat"
            case .developer: return "Developer"
            case .continuity: return "Continuity"
            case .settings: return "System"
            case .general: return "General"
            case .appearance: return "Appearance"
            case .voice: return "Voice"
            case .permissions: return "Permissions"
            case .privacy: return "Privacy"
            case .accessibility: return "Accessibility"
            case .configuration: return "Configuration"
            case .connectors: return "Connectors"
            case .personalization: return "Personalization"
            case .dashboard: return "Dashboard"
            case .storageBackup: return "Storage & Backup"
            case .security: return "Security"
            case .environment: return "Environment"
            case .worktree: return "Worktree"
            case .browserUse: return "Browser Use"
            case .chatManagement: return "Chat Management"
            case .projects: return "Projects"
            case .files: return "Files"
            case .recents: return "Recents"
            case .shared: return "Shared"
            case .archive: return "Archive"
            case .intelligenceDashboard: return "Intelligence"
            case .sessions: return "Sessions"
            case .providers: return "Providers"
            case .connections: return "Connections"
            case .terminalRuntime: return "Terminal"
            case .knowledgeBase: return "Knowledge Base"
            case .kanban: return "Kanban"
            case .automationJobs: return "Automation"
            case .usage: return "Usage"
            case .mail: return "Mail"
            case .messaging: return "Messaging"
            case .skills: return "Skills"
            case .diagnostics: return "Diagnostics"
            case .voiceRuntime: return "Voice Runtime"
            case .desktopRuntime: return "Desktop Runtime"
            }
        }

        var icon: ICOSIcon {
            switch self {
            case .chat: return .chat
            case .developer: return .console
            case .continuity: return .continuity
            case .settings: return .settings
            case .general: return .home
            case .appearance: return .appearance
            case .voice: return .voice
            case .permissions: return .key
            case .privacy: return .cloud
            case .accessibility: return .customize
            case .configuration: return .configuration
            case .connectors: return .integration
            case .personalization: return .personalization
            case .dashboard: return .analytics
            case .storageBackup: return .workspaceArchive
            case .security: return .key
            case .environment: return .environment
            case .worktree: return .worktree
            case .browserUse: return .browserUse
            case .chatManagement: return .chatManagement
            case .projects: return .projectManagement
            case .files: return .fileManager
            case .recents: return .workspaceRecents
            case .shared: return .workspaceShared
            case .archive: return .workspaceArchive
            case .intelligenceDashboard: return .thought
            case .sessions: return .comment
            case .providers: return .cloud
            case .connections: return .integration
            case .terminalRuntime: return .command
            case .knowledgeBase: return .knowledge
            case .kanban: return .tasks
            case .automationJobs: return .automation
            case .usage: return .analytics
            case .mail: return .email
            case .messaging: return .talk
            case .skills: return .customize
            case .diagnostics: return .bug
            case .voiceRuntime: return .voice
            case .desktopRuntime: return .app
            }
        }

        var isSettingsCategory: Bool {
            switch self {
            case .general, .appearance, .voice, .permissions, .privacy, .accessibility,
                 .configuration, .connectors, .personalization, .dashboard, .storageBackup, .security:
                return true
            case .chat, .developer, .continuity, .settings, .projects, .files, .recents, .shared, .archive,
                 .intelligenceDashboard, .sessions, .providers, .connections, .terminalRuntime, .knowledgeBase,
                 .kanban, .automationJobs, .usage, .mail, .messaging, .skills, .diagnostics, .voiceRuntime,
                 .desktopRuntime, .environment, .worktree, .browserUse, .chatManagement:
                return false
            }
        }
    }

    // MARK: - Navigation Actions

    public func navigate(to route: Route) {
        commitNavigation(
            to: NavigationEntry(
                route: route,
                settingsCategory: selectedSettingsCategory
            )
        )
    }

    public func openSettings(_ category: Route = .general) {
        let resolvedCategory = category.isSettingsCategory ? category : .general
        commitNavigation(
            to: NavigationEntry(
                route: .settings,
                settingsCategory: resolvedCategory
            )
        )
    }

    public func openWorkspace(_ route: Route) {
        let resolvedRoute: Route

        switch route {
        case .projects, .files, .recents, .shared, .archive:
            resolvedRoute = route

        default:
            resolvedRoute = .projects
        }

        commitNavigation(
            to: NavigationEntry(
                route: resolvedRoute,
                settingsCategory: selectedSettingsCategory
            )
        )
    }

    public func goBack() {
        guard let previous = backwardHistory.popLast() else { return }
        forwardHistory.append(currentEntry)
        restore(previous)
        publishTitlebarNavigationState()
    }

    public func goForward() {
        guard let next = forwardHistory.popLast() else { return }
        backwardHistory.append(currentEntry)
        restore(next)
        publishTitlebarNavigationState()
    }

    public func reset() {
        commitNavigation(
            to: NavigationEntry(
                route: .chat,
                settingsCategory: selectedSettingsCategory
            )
        )
    }

    // MARK: - History Coordination

    private var currentEntry: NavigationEntry {
        NavigationEntry(
            route: currentRoute,
            settingsCategory: selectedSettingsCategory
        )
    }

    private func commitNavigation(to next: NavigationEntry) {
        guard next != currentEntry else { return }
        backwardHistory.append(currentEntry)
        forwardHistory.removeAll()
        restore(next)
        publishTitlebarNavigationState()
    }

    private func restore(_ entry: NavigationEntry) {
        currentRoute = entry.route
        selectedSettingsCategory = entry.settingsCategory
    }

    private func publishTitlebarNavigationState() {
        NotificationCenter.default.post(
            name: .icosTitlebarNavigationStateDidChange,
            object: ICOSTitlebarNavigationState(
                title: currentDisplayTitle,
                canNavigateBack: canNavigateBack,
                canNavigateForward: canNavigateForward,
                isVisible: isTitlebarNavigationVisible
            )
        )
    }
}

/// Root Router View
struct RouterView: View {
    @ObservedObject private var router: AppRouter
    @ObservedObject private var appState: ICOSAppState
    @EnvironmentObject var behaviorEngine: BehaviorEngine

    init(router: AppRouter, appState: ICOSAppState) {
        self._router = ObservedObject(wrappedValue: router)
        self._appState = ObservedObject(wrappedValue: appState)
    }

    public var body: some View {
        ZStack(alignment: .center) {
            NavigationShell(router: router, appState: appState)
            behaviorEngine.overlayView
        }
        .background(ICOSColors.background)
        .onReceive(NotificationCenter.default.publisher(for: .icosTitlebarNavigateBack)) { _ in
            router.goBack()
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosTitlebarNavigateForward)) { _ in
            router.goForward()
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosTitlebarNavigationRefreshRequested)) { _ in
            NotificationCenter.default.post(
                name: .icosTitlebarNavigationStateDidChange,
                object: ICOSTitlebarNavigationState(
                    title: router.currentDisplayTitle,
                    canNavigateBack: router.canNavigateBack,
                    canNavigateForward: router.canNavigateForward,
                    isVisible: router.isTitlebarNavigationVisible
                )
            )
        }
    }
}
