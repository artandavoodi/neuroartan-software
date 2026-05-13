import Foundation

// ============================================================
// ICOS · Local Storage Controller
// ============================================================

final class LocalStorageController {

    // ========================================================
    // Singleton
    // ========================================================

    static let shared = LocalStorageController()

    // ========================================================
    // Database
    // ========================================================

    private let database = ICOSDatabase.shared

    // ========================================================
    // Init
    // ========================================================

    private init() {}

    // ========================================================
    // Conversation Memory
    // ========================================================

    struct ConversationRecord: Codable {
        let id: UUID
        let timestamp: Date
        let role: String
        let content: String
    }

    func saveConversation(
        role: String,
        content: String
    ) {
        var existing = loadConversations()

        let record = ConversationRecord(
            id: UUID(),
            timestamp: Date(),
            role: role,
            content: content
        )

        existing.append(record)

        database.save(
            existing,
            to: database.conversationStoreURL()
        )
    }

    func loadConversations() -> [ConversationRecord] {
        database.load(
            from: database.conversationStoreURL(),
            as: [ConversationRecord].self
        ) ?? []
    }

    // ========================================================
    // Cognitive Runtime State
    // ========================================================

    struct CognitiveRuntimeState: Codable {
        let runtimeMode: String
        let activeProvider: String
        let cognitiveLayer: String
        let timestamp: Date
    }

    func saveRuntimeState(
        runtimeMode: String,
        activeProvider: String,
        cognitiveLayer: String
    ) {
        let state = CognitiveRuntimeState(
            runtimeMode: runtimeMode,
            activeProvider: activeProvider,
            cognitiveLayer: cognitiveLayer,
            timestamp: Date()
        )

        database.save(
            state,
            to: database.runtimeStoreURL()
        )
    }

    func loadRuntimeState() -> CognitiveRuntimeState? {
        database.load(
            from: database.runtimeStoreURL(),
            as: CognitiveRuntimeState.self
        )
    }

    // ========================================================
    // Cognitive Memory Snapshot
    // ========================================================

    struct CognitiveSnapshot: Codable {
        let semanticNodes: Int
        let emotionalSignals: Int
        let activeGoals: Int
        let continuityState: String
        let timestamp: Date
    }

    func saveCognitiveSnapshot(
        semanticNodes: Int,
        emotionalSignals: Int,
        activeGoals: Int,
        continuityState: String
    ) {
        let snapshot = CognitiveSnapshot(
            semanticNodes: semanticNodes,
            emotionalSignals: emotionalSignals,
            activeGoals: activeGoals,
            continuityState: continuityState,
            timestamp: Date()
        )

        database.save(
            snapshot,
            to: database.cognitionStoreURL()
        )
    }

    func loadCognitiveSnapshot() -> CognitiveSnapshot? {
        database.load(
            from: database.cognitionStoreURL(),
            as: CognitiveSnapshot.self
        )
    }

    // ========================================================
    // Reset Runtime
    // ========================================================

    func clearConversationMemory() {
        database.save(
            [ConversationRecord](),
            to: database.conversationStoreURL()
        )
    }

    // ========================================================
    // Runtime Health
    // ========================================================

    func runtimeHealthReport() -> [String: Any] {
        [
            "conversation_records": loadConversations().count,
            "runtime_state_available": (
                loadRuntimeState() != nil
            ),
            "cognitive_snapshot_available": (
                loadCognitiveSnapshot() != nil
            ),
            "storage_root": database.runtimeStoreURL().path
        ]
    }
}