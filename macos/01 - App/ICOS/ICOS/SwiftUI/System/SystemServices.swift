import SwiftUI
import Combine
import Foundation

/// ICOS System Services Layer
/// Central runtime services for UI behavior, state, and coordination
@MainActor
final class SystemServices: ObservableObject {

    // MARK: - Shared Instance
    static let shared: SystemServices = {
        SystemServices(
            router: AppRouter(),
            appState: .shared,
            previewMode: ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        )
    }()

    // MARK: - Core Systems
    let router: AppRouter
    let appState: ICOSAppState
    let themeEngine: ThemeEngine
    let behaviorEngine: BehaviorEngine
    let runtimeSettings: RuntimeSettingsState
    let projectManager: ProjectManagerViewModel
    let permissionService: PermissionService
    let workspaceFileService: WorkspaceFileService
    let developerWorkspaceService: DeveloperWorkspaceService
    let developerVoiceService: DeveloperVoiceTranscriptionService
    let externalEditorBridge: ExternalEditorBridge
    let voiceCognitionService: VoiceCognitionService
    let voicePlaybackService: VoicePlaybackService
    let connectorRegistryService: ConnectorRegistryService
    let agentRuntimeService: AgentRuntimeService
    let gitStatusService: GitStatusService

    convenience init() {
        self.init(
            router: AppRouter(),
            appState: .shared,
            previewMode: false
        )
    }

    init(
        router: AppRouter,
        appState: ICOSAppState,
        previewMode: Bool
    ) {
        ICOSFontRegistry.registerBundledFonts()

        self.router = router
        self.appState = appState
        self.themeEngine = ThemeEngine.shared
        self.behaviorEngine = BehaviorEngine()
        self.runtimeSettings = RuntimeSettingsState.shared
        self.projectManager = ProjectManagerViewModel.shared

        let permissionService = PermissionService()
        self.permissionService = permissionService

        let externalEditorBridge = previewMode
            ? ExternalEditorBridge()
            : ExternalEditorBridge.shared
        self.externalEditorBridge = externalEditorBridge

        self.voiceCognitionService = previewMode
            ? VoiceCognitionService()
            : VoiceCognitionService.shared

        self.voicePlaybackService = previewMode
            ? VoicePlaybackService()
            : VoicePlaybackService.shared

        self.connectorRegistryService = previewMode
            ? ConnectorRegistryService(storageURL: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("icos-preview-connectors.json"))
            : ConnectorRegistryService.shared

        self.agentRuntimeService = previewMode
            ? AgentRuntimeService(storageURL: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("icos-preview-agent-runtime.json"))
            : AgentRuntimeService.shared

        self.gitStatusService = GitStatusService()

        let workspaceFileService = WorkspaceFileService(
            permissionService: permissionService,
            externalEditorBridge: externalEditorBridge
        )
        self.workspaceFileService = workspaceFileService

        self.developerWorkspaceService = DeveloperWorkspaceService(
            permissionService: permissionService,
            workspaceFileService: workspaceFileService,
            previewMode: previewMode
        )
        self.developerWorkspaceService.bindSearchSources(
            projectManager: self.projectManager,
            appState: self.appState
        )

        self.developerVoiceService = DeveloperVoiceTranscriptionService(
            permissionService: permissionService
        )

        if previewMode {
            workspaceFileService.loadPreviewWorkspace()
        } else {
            synchronizeActiveProjectWorkspace()
        }
    }

    static func preview() -> SystemServices {
        SystemServices(
            router: AppRouter(),
            appState: ICOSAppState.preview(),
            previewMode: true
        )
    }

    // MARK: - Global Reset
    func resetAll() {
        router.reset()
        behaviorEngine.reset()
        themeEngine.isDarkMode = false
    }

    // MARK: - Workspace / Project Activation

    func activateProject(_ project: ICOSProject) {
        projectManager.selectProject(project)
        synchronizeActiveProjectWorkspace()
    }

    func synchronizeActiveProjectWorkspace() {
        guard let project = projectManager.activeProject else {
            return
        }

        guard let path = project.path?.trimmingCharacters(in: .whitespacesAndNewlines),
              !path.isEmpty
        else {
            developerWorkspaceService.statusText = "Active project has no directory assigned."
            return
        }

        let url = URL(fileURLWithPath: path, isDirectory: true)
        PermissionGate.shared.registerAuthorizedRoot(url.path)
        workspaceFileService.setWorkspaceRoot(url)
        developerWorkspaceService.searchQuery = ""
        gitStatusService.refresh(rootURL: workspaceFileService.rootURL)

        if FileManager.default.fileExists(atPath: url.path) {
            agentRuntimeService.indexRepository(rootPath: url.path)
        }
    }

    // MARK: - Overlay Shortcuts
    func showAccountOverlay() {
        behaviorEngine.present(.account)
    }

    func showSettingsOverlay() {
        behaviorEngine.present(.settings)
    }
}
