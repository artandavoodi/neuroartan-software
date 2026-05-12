import Foundation
import Combine

@MainActor
final class RuntimeState: ObservableObject {
    
    // MARK: - Execution Phase
    @Published var phase: Phase = .idle
    
    // MARK: - Runtime Engine
    @Published var currentEngine: RuntimeEngine = .icos
    
    // MARK: - Model Selection
    @Published var activeModel: String = "gemma4:e4b"
    
    // MARK: - Status
    @Published var isRunning: Bool = false
    @Published var lastExecutionTime: Date? = nil
    
    // MARK: - Error Handling
    @Published var lastError: String? = nil
    
    // MARK: - UI Helpers
    @Published private(set) var shouldShowThinkingIndicator: Bool = false
    
    func setPhase(_ newPhase: Phase) {
        phase = newPhase
        shouldShowThinkingIndicator = (newPhase == .thinking)
    }
    
    func setEngine(_ engine: RuntimeEngine) {
        currentEngine = engine
    }
}

// MARK: - Runtime Phase

enum Phase {
    case idle
    case thinking
    case searching
    case processing
}

// MARK: - Runtime Engine Enum

enum RuntimeEngine {
    case icos
    case local
    case cloud
}
