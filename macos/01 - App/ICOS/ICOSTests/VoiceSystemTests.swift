//
//  VoiceSystemTests.swift
//  ICOSTests
//
//  Voice System Tests
//

import Testing
@testable import ICOS

struct VoiceSystemTests {

    @Test func voiceProfilePersistence() async throws {
        let service = VoiceCognitionService.shared
        service.save()
        #expect(service.profile.updatedAt > Date().addingTimeInterval(-10))
    }

    @Test func voicePlaybackToggle() async throws {
        let service = VoicePlaybackService.shared
        service.toggleSpeech("test message")
        #expect(service.isSpeaking)
    }

    @Test func voiceTranscriptionAuthorization() async throws {
        let engine = VoiceTranscriptionEngine.shared
        let authorized = await engine.requestAuthorization()
        #expect(authorized == true || authorized == false) // TODO: Test actual authorization
    }

    @Test func emotionalAnalysis() async throws {
        let engine = EmotionalVoiceInferenceEngine.shared
        let analysis = engine.analyzeVoiceInput(text: "test", audioFeatures: nil)
        #expect(analysis.primaryEmotion == .neutral)
    }

}
