import Foundation

// ============================================================
// ICOS · Doctrine Interpreter
// ============================================================

final class DoctrineInterpreter {

    // ========================================================
    // Doctrine Identity
    // ========================================================

    struct DoctrineProfile {
        let identity: String
        let reasoningStyle: String
        let alignmentModel: String
        let emotionalArchitecture: String
        let continuityModel: String
        let executionMode: String
    }

    // ========================================================
    // Canonical Doctrine
    // ========================================================

    private let doctrine = DoctrineProfile(
        identity: "sovereign_cognitive_operating_system",
        reasoningStyle: "recursive_semantic_reasoning",
        alignmentModel: "governed_alignment",
        emotionalArchitecture: "emotion_bound_cognition",
        continuityModel: "persistent_continuity_memory",
        executionMode: "human_supervised_recursive_runtime"
    )

    // ========================================================
    // Runtime Interpretation
    // ========================================================

    func interpret(
        input: String
    ) -> [String: Any] {

        let normalized = input.lowercased()

        let emotionalWeight = inferEmotion(
            from: normalized
        )

        let governanceRequired = requiresGovernance(
            normalized
        )

        let continuityPriority = requiresContinuity(
            normalized
        )

        return [
            "identity": doctrine.identity,
            "reasoning_style": doctrine.reasoningStyle,
            "alignment_model": doctrine.alignmentModel,
            "emotional_architecture": doctrine.emotionalArchitecture,
            "continuity_model": doctrine.continuityModel,
            "execution_mode": doctrine.executionMode,
            "input": input,
            "emotional_weight": emotionalWeight,
            "governance_required": governanceRequired,
            "continuity_priority": continuityPriority,
            "timestamp": Date().timeIntervalSince1970
        ]
    }

    // ========================================================
    // Emotional Interpretation
    // ========================================================

    private func inferEmotion(
        from input: String
    ) -> String {

        if input.contains("fear") ||
            input.contains("anxiety") ||
            input.contains("worry") {
            return "anxiety"
        }

        if input.contains("love") ||
            input.contains("hope") ||
            input.contains("joy") {
            return "positive"
        }

        if input.contains("loss") ||
            input.contains("pain") ||
            input.contains("sad") {
            return "grief"
        }

        return "neutral"
    }

    // ========================================================
    // Governance Detection
    // ========================================================

    private func requiresGovernance(
        _ input: String
    ) -> Bool {

        let governanceTerms = [
            "execute",
            "delete",
            "modify",
            "autonomous",
            "system",
            "runtime",
            "training"
        ]

        return governanceTerms.contains {
            input.contains($0)
        }
    }

    // ========================================================
    // Continuity Detection
    // ========================================================

    private func requiresContinuity(
        _ input: String
    ) -> Bool {

        let continuityTerms = [
            "memory",
            "remember",
            "continuity",
            "history",
            "identity",
            "previous"
        ]

        return continuityTerms.contains {
            input.contains($0)
        }
    }

    // ========================================================
    // Runtime Health
    // ========================================================

    func runtimeHealth() -> [String: Any] {
        [
            "identity": doctrine.identity,
            "reasoning_style": doctrine.reasoningStyle,
            "alignment_model": doctrine.alignmentModel,
            "continuity_model": doctrine.continuityModel,
            "runtime_active": true
        ]
    }
}