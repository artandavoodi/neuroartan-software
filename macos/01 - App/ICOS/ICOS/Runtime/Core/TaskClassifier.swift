import Foundation

// MARK: - Task Type
// Routing labels used by ICOS execution engine.

enum TaskType {
    case general
    case coding
    case complex
}

// MARK: - Intent Classifier
// Deterministic signal-based classifier for provider routing.

struct TaskClassifier {
    static func classify(_ prompt: String) -> TaskType {
        let p = prompt.lowercased()

        let codingSignals = [
            "code", "write", "function", "program", "script",
            "swift", "python", "javascript", "java", "c++", "rust", "go",
            "bug", "fix", "error", "debug", "compile",
            "algorithm", "implementation", "build", "class", "struct",
            "api", "endpoint", "xcode", "terminal"
        ]

        for signal in codingSignals where p.contains(signal) {
            return .coding
        }

        let complexSignals = [
            "analyze", "design", "architecture", "optimize",
            "compare", "explain", "deep", "system", "strategy"
        ]

        for signal in complexSignals where p.contains(signal) {
            return .complex
        }

        if p.count > 300 {
            return .complex
        }

        return .general
    }
}
