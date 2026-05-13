import Foundation
import Combine

final class MemoryState: ObservableObject {

    // MARK: - Short-Term Memory
    @Published var workingMemory: [MemoryEntry] = []

    // MARK: - Long-Term Memory
    @Published var longTermMemory: [MemoryEntry] = []

    // MARK: - Retrieval Cache
    @Published var retrievalCache: [MemoryEntry] = []

    // MARK: - Append
    func store(entry: MemoryEntry) {
        workingMemory.append(entry)
    }

    // MARK: - Promote to Long-Term
    func promoteToLongTerm(_ entry: MemoryEntry) {
        longTermMemory.append(entry)
    }
}
