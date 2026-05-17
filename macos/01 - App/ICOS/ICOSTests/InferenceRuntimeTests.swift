//
//  InferenceRuntimeTests.swift
//  ICOSTests
//
//  Inference Runtime Tests
//

import Testing
@testable import ICOS

struct InferenceRuntimeTests {

    @Test func inferenceRuntimeInitialization() async throws {
        let engine = InferenceRuntimeEngine.shared
        #expect(engine.currentModel.isEmpty)
    }

    @Test func contextManagerDefaultSize() async throws {
        let manager = ContextManager.shared
        #expect(manager.contextSize == 4096)
    }

    @Test func contextUsageCalculation() async throws {
        let manager = ContextManager.shared
        let usage = manager.getContextUsage()
        #expect(usage.total == 4096)
    }

    @Test func tokenizerStrategyBasic() async throws {
        let strategy = TokenizerStrategy.shared
        let tokens = strategy.tokenize("test", modelPath: "")
        #expect(tokens.isEmpty) // TODO: Update when tokenization is implemented
    }

}
