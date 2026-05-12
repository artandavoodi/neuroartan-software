import Foundation

final class MemoryManager {
    static let shared = MemoryManager()

    private let store = MemoryStore()
    private let index = RetrievalIndex()
    private var entries: [MemoryEntry]
    private let lock = NSLock()

    private init() {
        self.entries = store.load()
    }

    func retrieveRelevant(to input: String, profile: UserProfile) -> [MemoryEntry] {
        guard profile.memoryEnabled else { return [] }

        lock.lock()
        let snapshot = entries
        lock.unlock()

        return index.retrieve(query: input, from: snapshot)
    }

    func promptContext(for input: String, profile: UserProfile) -> String {
        let relevant = retrieveRelevant(to: input, profile: profile)
        guard !relevant.isEmpty else { return "" }

        let lines = relevant.map { entry in
            "- [\(entry.kind.rawValue)] \(entry.content)"
        }

        return """
Relevant User Memory:
\(lines.joined(separator: "\n"))
"""
    }

    func recordInteraction(userInput: String, assistantOutput: String, profile: UserProfile) {
        guard profile.memoryEnabled else { return }

        let candidates = extractMemoryCandidates(from: userInput)
        guard !candidates.isEmpty else { return }

        lock.lock()
        for candidate in candidates {
            upsert(candidate)
        }
        let snapshot = entries
        lock.unlock()

        store.save(snapshot)
    }

    private func upsert(_ candidate: MemoryEntry) {
        if let index = entries.firstIndex(where: { $0.kind == candidate.kind && $0.content.caseInsensitiveCompare(candidate.content) == .orderedSame }) {
            entries[index].weight = min(entries[index].weight + 0.25, 5.0)
            entries[index].updatedAt = Date()
        } else {
            entries.append(candidate)
        }
    }

    private func extractMemoryCandidates(from input: String) -> [MemoryEntry] {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 8 else { return [] }

        let lower = trimmed.lowercased()

        if lower.contains("remember that ") || lower.hasPrefix("remember ") {
            return [MemoryEntry(kind: .profileFact, content: normalizedMemoryText(trimmed), tags: ["explicit"], weight: 2.0)]
        }

        if lower.contains("i prefer ") || lower.contains("i like ") || lower.contains("i want you to ") {
            return [MemoryEntry(kind: .preference, content: normalizedMemoryText(trimmed), tags: ["preference"], weight: 1.6)]
        }

        if lower.contains("don't ") || lower.contains("do not ") || lower.contains("instead ") {
            return [MemoryEntry(kind: .correction, content: normalizedMemoryText(trimmed), tags: ["correction"], weight: 1.8)]
        }

        return []
    }

    private func normalizedMemoryText(_ text: String) -> String {
        text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
