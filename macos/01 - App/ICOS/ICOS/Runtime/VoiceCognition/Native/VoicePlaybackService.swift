import Foundation
import AVFoundation
import Combine

@MainActor
final class VoicePlaybackService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = VoicePlaybackService()

    @Published private(set) var isSpeaking = false
    @Published private(set) var statusText = "Voice playback idle."

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func toggleSpeech(_ text: String, voiceIdentifier: String = "") {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            statusText = "Voice playback stopped."
            return
        }

        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        if !voiceIdentifier.isEmpty {
            utterance.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
        }

        isSpeaking = true
        statusText = "Reading response."
        synthesizer.speak(utterance)
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
            statusText = "Voice playback finished."
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
            statusText = "Voice playback cancelled."
        }
    }
}
