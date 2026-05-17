import Foundation
import Combine

// MARK: - Context Manager
// Context management for GGUF inference

@MainActor
final class ContextManager: ObservableObject {
    static let shared = ContextManager()
    
    @Published private(set) var contextSize: Int = 4096
    @Published private(set) var usedTokens: Int = 0
    @Published private(set) var contextHistory: [ContextEntry] = []
    
    private let maxHistorySize = 100
    
    private init() {}
    
    // MARK: - Context Management
    
    func updateContextSize(_ size: Int) {
        contextSize = size
        trimHistoryToFit()
    }
    
    func addEntry(_ entry: ContextEntry) {
        contextHistory.append(entry)
        usedTokens = calculateUsedTokens()
        trimHistoryToFit()
    }
    
    func clearHistory() {
        contextHistory.removeAll()
        usedTokens = 0
    }
    
    // MARK: - Context Usage
    
    func getContextUsage() -> ContextUsage {
        let percentage = contextSize > 0 ? Double(usedTokens) / Double(contextSize) : 0.0
        return ContextUsage(used: usedTokens, total: contextSize, percentage: percentage)
    }
    
    func isNearCapacity(threshold: Double = 0.9) -> Bool {
        let usage = getContextUsage()
        return usage.percentage >= threshold
    }
    
    // MARK: - Retrieval Injection
    
    func injectRetrieval(_ retrieval: [MemoryRetrievalResult]) {
        // TODO: Implement retrieval injection into context
        // This should integrate with VectorMemory retrieval
    }
    
    // MARK: - Private Methods
    
    private func calculateUsedTokens() -> Int {
        // TODO: Calculate actual token usage from context history
        return contextHistory.reduce(0) { $0 + $1.tokenCount }
    }
    
    private func trimHistoryToFit() {
        while usedTokens > contextSize && !contextHistory.isEmpty {
            contextHistory.removeFirst()
            usedTokens = calculateUsedTokens()
        }
        
        if contextHistory.count > maxHistorySize {
            let excess = contextHistory.count - maxHistorySize
            contextHistory.removeFirst(excess)
        }
    }
}

// MARK: - Supporting Types

struct ContextEntry: Identifiable {
    let id = UUID()
    let role: String
    let content: String
    let tokenCount: Int
    let timestamp = Date()
}
