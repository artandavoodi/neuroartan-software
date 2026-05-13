import Foundation

// ============================================================
// ICOS · Doctrine Context Builder
// ============================================================

final class DoctrineContextBuilder {

    // ========================================================
    // Dependencies
    // ========================================================

    private let interpreter = DoctrineInterpreter()
    private let storage = LocalStorageController.shared

    // ========================================================
    // Runtime Context
    // ========================================================

    struct RuntimeContext: Codable {
        let identity: String
        let reasoningStyle: String
        let emotionalState: String
        let governanceRequired: Bool
        let continuityPriority: Bool
        let continuityRecords: Int
        let timestamp: Date
    }

    // ========================================================
    // Context Construction
    // ========================================================

    func buildContext(
        input: String
    ) -> RuntimeContext {

        let interpretation = interpreter.interpret(
            input: input
        )

        let conversations = storage.loadConversations()

        return RuntimeContext(
            identity: (
                interpretation["identity"] as? String
                ?? "unknown"
            ),
            reasoningStyle: (
                interpretation["reasoning_style"] as? String
                ?? "unknown"
            ),
            emotionalState: (
                interpretation["emotional_weight"] as? String
                ?? "neutral"
            ),
            governanceRequired: (
                interpretation["governance_required"] as? Bool
                ?? false
            ),
            continuityPriority: (
                interpretation["continuity_priority"] as? Bool
                ?? false
            ),
            continuityRecords: conversations.count,
            timestamp: Date()
        )
    }

    // ========================================================
    // Context Serialization
    // ========================================================

    func serialize(
        context: RuntimeContext
    ) -> String {

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]

        do {
            let data = try encoder.encode(context)
            return String(
                data: data,
                encoding: .utf8
            ) ?? "{}"
        } catch {
            return "{}"
        }
    }

    // ========================================================
    // Context Summary
    // ========================================================

    func summary(
        for context: RuntimeContext
    ) -> [String: Any] {

        [
            "identity": context.identity,
            "reasoning_style": context.reasoningStyle,
            "emotional_state": context.emotionalState,
            "governance_required": (
                context.governanceRequired
            ),
            "continuity_priority": (
                context.continuityPriority
            ),
            "continuity_records": (
                context.continuityRecords
            ),
            "timestamp": context.timestamp.timeIntervalSince1970
        ]
    }

    // ========================================================
    // Runtime Health
    // ========================================================

    func runtimeHealth() -> [String: Any] {

        let health = interpreter.runtimeHealth()

        return [
            "runtime": "ICOS_DOCTRINE_CONTEXT_BUILDER",
            "interpreter_active": (
                health["runtime_active"] as? Bool
                ?? false
            ),
            "storage_connected": true,
            "continuity_memory_available": true
        ]
    }
}