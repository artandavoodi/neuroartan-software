import Foundation
import AppKit
import AVFoundation
import Combine
import UniformTypeIdentifiers

enum VoiceRuntimeProvider: String, Codable, CaseIterable, Identifiable {
    case systemSpeech
    case localVoiceModel
    case cloudVoiceModel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .systemSpeech: return "System Voice"
        case .localVoiceModel: return "Local Voice Model"
        case .cloudVoiceModel: return "Cloud Voice Model"
        }
    }
}

struct VoiceTrainingSample: Codable, Identifiable, Hashable {
    var id = UUID()
    var filePath: String
    var label: String
    var consentAccepted: Bool
    var createdAt = Date()
}

struct VoiceProfile: Codable, Equatable {
    var provider: VoiceRuntimeProvider = .systemSpeech
    var selectedSystemVoiceIdentifier = ""
    var replicationEnabled = false
    var trainingConsentAccepted = false
    var localModelPath = ""
    var cloudEndpoint = ""
    var samples: [VoiceTrainingSample] = []
    var updatedAt = Date()
}

@MainActor
final class VoiceCognitionService: ObservableObject {
    static let shared = VoiceCognitionService()

    @Published var profile: VoiceProfile
    @Published private(set) var statusText = "Voice runtime idle."

    private let fileManager = FileManager.default
    private let profileURL: URL
    private let samplesDirectory: URL

    init() {
        let baseDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ICOS", isDirectory: true)
            .appendingPathComponent("voice", isDirectory: true)
        self.samplesDirectory = baseDirectory.appendingPathComponent("samples", isDirectory: true)
        self.profileURL = baseDirectory.appendingPathComponent("voice_profile.json")

        if !fileManager.fileExists(atPath: samplesDirectory.path) {
            try? fileManager.createDirectory(at: samplesDirectory, withIntermediateDirectories: true)
        }

        self.profile = Self.loadProfile(from: profileURL) ?? VoiceProfile()
        if self.profile.selectedSystemVoiceIdentifier.isEmpty,
           let defaultVoice = AVSpeechSynthesisVoice(language: Locale.current.identifier)?.identifier
            ?? AVSpeechSynthesisVoice.speechVoices().first?.identifier {
            self.profile.selectedSystemVoiceIdentifier = defaultVoice
        }
    }

    var availableSystemVoices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().sorted { lhs, rhs in
            lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
    }

    var activeVoiceName: String {
        availableSystemVoices.first { $0.identifier == profile.selectedSystemVoiceIdentifier }?.name ?? "Default system voice"
    }

    func save() {
        profile.updatedAt = Date()

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            try encoder.encode(profile).write(to: profileURL, options: [.atomic])
            statusText = "Voice profile saved."
        } catch {
            statusText = "Voice profile save failed: \(error.localizedDescription)"
        }
    }

    func importTrainingSample() {
        guard profile.trainingConsentAccepted else {
            statusText = "Accept voice training consent before importing samples."
            return
        }

        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.audio]

        guard panel.runModal() == .OK else { return }

        for sourceURL in panel.urls {
            let destinationURL = uniqueSampleURL(for: sourceURL.lastPathComponent)
            do {
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                profile.samples.append(VoiceTrainingSample(
                    filePath: destinationURL.path,
                    label: sourceURL.deletingPathExtension().lastPathComponent,
                    consentAccepted: true
                ))
            } catch {
                statusText = "Could not import \(sourceURL.lastPathComponent): \(error.localizedDescription)"
                return
            }
        }

        save()
        statusText = "Imported \(panel.urls.count) voice sample(s)."
    }

    func removeSample(_ sample: VoiceTrainingSample) {
        if fileManager.fileExists(atPath: sample.filePath) {
            try? fileManager.removeItem(atPath: sample.filePath)
        }
        profile.samples.removeAll { $0.id == sample.id }
        save()
    }

    private func uniqueSampleURL(for filename: String) -> URL {
        let base = URL(fileURLWithPath: filename).deletingPathExtension().lastPathComponent
        let ext = URL(fileURLWithPath: filename).pathExtension

        var index = 0
        while true {
            let suffix = index == 0 ? "" : "-\(index)"
            let candidate = samplesDirectory
                .appendingPathComponent(base + suffix)
                .appendingPathExtension(ext)
            if !fileManager.fileExists(atPath: candidate.path) {
                return candidate
            }
            index += 1
        }
    }

    private static func loadProfile(from url: URL) -> VoiceProfile? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(VoiceProfile.self, from: data)
    }
}
