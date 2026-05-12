import Foundation

/// Compiles raw doctrine markdown into a compact, deterministic prompt segment.
/// Responsibilities: order, strip noise, normalize spacing, enforce size budget.
final class DoctrineCompiler {

    static let shared = DoctrineCompiler()

    private init() {}

    /// Max characters allowed for doctrine segment to avoid context bloat
    private let maxChars: Int = 4000

    /// Compile pipeline
    func compile(raw: [String]) -> String {
        if raw.isEmpty { return "" }

        // Prioritize first doctrine files (highest authority)
        var blocks = Array(raw.prefix(8))

        // 2) Normalize each block
        blocks = blocks.map { normalize($0) }

        // 3) Join with hard separators
        var compiled = blocks.joined(separator: "\n\n---\n\n")

        // 4) Enforce size budget (tail-trim keeps highest-priority early files)
        if compiled.count > maxChars {
            compiled = String(compiled.prefix(maxChars))
        }

        // 5) Final sanitation
        compiled = collapseWhitespace(compiled)

        return compiled
    }

    // MARK: - Normalization

    private func normalize(_ text: String) -> String {
        var t = text

        // Remove leading/trailing whitespace
        t = t.trimmingCharacters(in: .whitespacesAndNewlines)

        // Remove duplicate blank lines
        t = t.replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)

        // Strip markdown headings markers but keep titles
        t = t.replacingOccurrences(of: "^#{1,6}\\s*", with: "", options: [.regularExpression, .anchored])

        // Remove code fences if any
        t = t.replacingOccurrences(of: "```[\\s\\S]*?```", with: "", options: .regularExpression)

        return t
    }

    private func collapseWhitespace(_ text: String) -> String {
        var t = text
        t = t.replacingOccurrences(of: "[\\t ]+", with: " ", options: .regularExpression)
        t = t.replacingOccurrences(of: "\\n{3,}", with: "\n\n", options: .regularExpression)
        return t.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}