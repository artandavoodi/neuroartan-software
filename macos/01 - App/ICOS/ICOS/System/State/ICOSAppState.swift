import SwiftUI
import Combine
import Foundation
import Observation

/* =============================================================================
   00) PREVIEW DETECTION
============================================================================= */
private extension ProcessInfo {

    var isRunningSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

@MainActor
final class ICOSAppState: ObservableObject {

    // MARK: - Singleton Access
    static let shared: ICOSAppState = {

        if ProcessInfo.processInfo.isRunningSwiftUIPreview {
            return ICOSAppState(previewMode: true)
        }

        return ICOSAppState(previewMode: false)
    }()

    // MARK: - Core System State
    @Published var isInitialized: Bool = false

    // MARK: - Active Session
    @Published private(set) var activeSession: SessionState

    // MARK: - Runtime Engine
    @Published private(set) var runtime: RuntimeEngine = .icos

    // MARK: - Orchestrator
    let orchestrator: InstructionOrchestrator = InstructionOrchestrator()

    // MARK: - Profile State
    @Published private(set) var profile: ProfileState = ProfileState()

    // MARK: - Memory State
    @Published private(set) var memory: MemoryState = MemoryState()

    // MARK: - Navigation Router

    let router: AppRouter = AppRouter()

    // MARK: - Runtime UI State

    @Published var activeView: ICOSRoute = .developerConsole
    @Published var outputText: String = ""

    private var activeSessionCancellable: AnyCancellable?

    // MARK: - Initialization
    private init(previewMode: Bool) {
        if previewMode {
            let seed = PersistedSession(
                sessionID: UUID(),
                createdAt: Date(),
                messages: [
                    ChatMessage(role: .assistant, content: "Developer preview ready. Runtime services are not booted in Canvas."),
                    ChatMessage(role: .user, content: "Show me the active file context.")
                ]
            )
            self.activeSession = SessionState(store: SessionStore(inMemory: true, seed: seed))
            self.isInitialized = true
            return
        }

        self.activeSession = SessionState()
        bindActiveSession()
    }

    // MARK: - Preview
    static func preview() -> ICOSAppState {
        ICOSAppState(previewMode: true)
    }

    // MARK: - Session Management
    func startNewChat() {
        let store = SessionStore()
        store.clearActiveSession()
        activeSession = SessionState(store: store)
        bindActiveSession()
    }

    func loadChatSession(id: UUID) {
        let store = SessionStore()
        guard store.activateSession(id: id) != nil else { return }
        activeSession = SessionState(store: store)
        bindActiveSession()
    }

    // MARK: - Internal Binding
    private func bindActiveSession() {
        activeSessionCancellable = activeSession.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
}
