//
//  ICOSTests.swift
//  ICOSTests
//
//  Created by Artan Davoodi on 27.04.26.
//

import Testing
@testable import ICOS

struct ICOSTests {

    @Test func vectorMemoryRetrievalEngineInitialization() async throws {
        let engine = VectorMemoryRetrievalEngine.shared
        #expect(engine !== nil)
    }

    @Test func voiceCognitionServiceInitialization() async throws {
        let service = VoiceCognitionService.shared
        #expect(service !== nil)
    }

    @Test func voicePlaybackServiceInitialization() async throws {
        let service = VoicePlaybackService.shared
        #expect(service !== nil)
    }

    @Test func voiceTranscriptionEngineInitialization() async throws {
        let engine = VoiceTranscriptionEngine.shared
        #expect(engine !== nil)
    }

    @Test func emotionalVoiceInferenceEngineInitialization() async throws {
        let engine = EmotionalVoiceInferenceEngine.shared
        #expect(engine !== nil)
    }

    @Test func inferenceRuntimeEngineInitialization() async throws {
        let engine = InferenceRuntimeEngine.shared
        #expect(engine !== nil)
    }

    @Test func tokenizerStrategyInitialization() async throws {
        let strategy = TokenizerStrategy.shared
        #expect(strategy !== nil)
    }

    @Test func contextManagerInitialization() async throws {
        let manager = ContextManager.shared
        #expect(manager !== nil)
    }

}
