import Foundation
import Combine
import Speech
import AVFoundation

@MainActor
final class DeveloperVoiceTranscriptionService: ObservableObject {
    @Published var transcript = ""
    @Published var statusText = "Voice transcription idle."
    @Published var isRecording = false

    private let permissionService: PermissionService
    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    init(permissionService: PermissionService) {
        self.permissionService = permissionService
    }

    func toggleRecording() {
        isRecording ? stopRecording() : startRecording()
    }

    func startRecording() {
        guard permissionService.validate(.voiceTranscription, action: "voice-transcription", url: nil) else {
            statusText = "Voice transcription blocked. Grant voice permission first."
            return
        }

        guard recognizer != nil else {
            statusText = "Speech recognizer is unavailable for the current locale."
            return
        }

        requestMicrophoneAccess { [weak self] microphoneGranted in
            Task { @MainActor [weak self] in
                guard let self else { return }
                guard microphoneGranted else {
                    self.statusText = "Microphone permission was not authorized."
                    return
                }
                self.requestSpeechAccess()
            }
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.finish()
        request = nil
        task = nil
        isRecording = false
        statusText = transcript.isEmpty ? "Voice transcription stopped." : "Voice transcription captured."
    }

    private func beginAudioRecognition() {
        stopRecording()
        transcript = ""

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        request = recognitionRequest

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak recognitionRequest] buffer, _ in
            recognitionRequest?.append(buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            statusText = "Microphone start failed: \(error.localizedDescription)"
            return
        }

        isRecording = true
        statusText = "Listening..."

        task = recognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }
                if let result {
                    self.transcript = result.bestTranscription.formattedString
                }
                if let error {
                    self.statusText = "Transcription error: \(error.localizedDescription)"
                    self.stopRecording()
                }
            }
        }
    }

    private func requestSpeechAccess() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authorization in
            Task { @MainActor in
                guard let self else { return }
                guard authorization == .authorized else {
                    self.statusText = "Speech recognition permission was not authorized."
                    return
                }
                self.beginAudioRecognition()
            }
        }
    }

    private func requestMicrophoneAccess(_ completion: @escaping @Sendable (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: completion)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}
