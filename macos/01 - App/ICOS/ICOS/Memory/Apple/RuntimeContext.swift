import Foundation

// MARK: - Runtime Context
// Core execution envelope passed through ICOS routing + inference layers

struct RuntimeContext {
    
    // MARK: - Core Routing State
    
    let engine: RuntimeEngine
    let prompt: String
    
    // MARK: - Optional Runtime Mode Override
    
    let mode: RuntimeMode?
    
    // MARK: - Metadata
    
    let timestamp: Date
    let requestID: UUID
    
    // MARK: - Init
    
    init(
        engine: RuntimeEngine,
        prompt: String,
        mode: RuntimeMode? = nil
    ) {
        self.engine = engine
        self.prompt = prompt
        self.mode = mode
        self.timestamp = Date()
        self.requestID = UUID()
    }
}