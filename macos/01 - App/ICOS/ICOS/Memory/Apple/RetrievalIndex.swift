import Foundation

final class RetrievalIndex {
    func retrieve(query: String, from entries: [MemoryEntry], limit: Int = 6) -> [MemoryEntry] {
        let queryTerms = terms(in: query)
        guard !queryTerms.isEmpty else {
            return entries
                .sorted { $0.updatedAt > $1.updatedAt }
                .prefix(limit)
                .map { $0 }
        }

        return entries
            .map { entry in
                (entry: entry, score: score(entry, queryTerms: queryTerms))
            }
            .filter { $0.score > 0 }
            .sorted {
                if $0.score == $1.score {
                    return $0.entry.updatedAt > $1.entry.updatedAt
                }
                return $0.score > $1.score
            }
            .prefix(limit)
            .map(\.entry)
    }

    private func score(_ entry: MemoryEntry, queryTerms: Set<String>) -> Double {
        let entryTerms = terms(in: ([entry.content] + entry.tags).joined(separator: " "))
        let overlap = queryTerms.intersection(entryTerms).count
        guard overlap > 0 else { return 0 }

        let recency = max(0.2, 1.0 - Date().timeIntervalSince(entry.updatedAt) / 2_592_000)
        return Double(overlap) * entry.weight * recency
    }

    private func terms(in text: String) -> Set<String> {
        let separators = CharacterSet.alphanumerics.inverted
        return Set(
            text.lowercased()
                .components(separatedBy: separators)
                .filter { $0.count > 2 }
        )
    }
}
