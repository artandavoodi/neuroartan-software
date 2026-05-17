import Foundation
import AVFoundation
import Speech
import Combine

// MARK: - Voice Transcription Engine
// Voice-to-text transcription for voice-native cognition

@MainActor
final class VoiceTranscriptionEngine: NSObject, ObservableObject {
    static let shared = VoiceTranscriptionEngine()
    
    @Published private(set) var isTranscribing = false
    @Published private(set) var transcribedText = ""
    @Published private(set) var statusText = "Voice transcription idle."
    
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer: SFSpeechRecognizer?
    
    override init() {
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
        super.init()
    }
    
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    func startTranscription() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            statusText = "Speech recognizer not available."
            return
        }
        
        audioEngine = AVAudioEngine()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            statusText = "Unable to create recognition request."
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine?.inputNode
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: inputNode?.outputFormat(forBus: 0)) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine?.prepare()
        
        do {
            try audioEngine?.start()
            isTranscribing = true
            statusText = "Listening..."
        } catch {
            statusText = "Audio engine start failed: \(error.localizedDescription)"
            return
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                Task { @MainActor in
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }
            
            if let error = error {
                Task { @MainActor in
                    self.statusText = "Recognition error: \(error.localizedDescription)"
                    self.stopTranscription()
                }
            }
        }
    }
    
    func stopTranscription() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        audioEngine = nil
        recognitionRequest = nil
        recognitionTask = nil
        
        isTranscribing = false
        statusText = "Voice transcription stopped."
    }
}
