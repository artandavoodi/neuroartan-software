import SwiftUI
import AVFoundation

struct VoiceSettingsPanel: View {
    @ObservedObject var voice: VoiceCognitionService

    var body: some View {
        SettingsSectionCard(title: "Voice Runtime", icon: .listen) {
            ICOSPickerRow(
                "Voice provider",
                selection: $voice.profile.provider,
                options: VoiceRuntimeProvider.allCases.map { provider in
                    ICOSPickerOption(value: provider, title: provider.title)
                }
            )
            .onChange(of: voice.profile.provider) { _, _ in voice.save() }

            ICOSPickerRow(
                "System voice",
                selection: $voice.profile.selectedSystemVoiceIdentifier,
                options: voice.availableSystemVoices.map { systemVoice in
                    ICOSPickerOption(value: systemVoice.identifier, title: "\(systemVoice.name) · \(systemVoice.language)")
                }
            )
            .disabled(voice.profile.provider != .systemSpeech)
            .onChange(of: voice.profile.selectedSystemVoiceIdentifier) { _, _ in voice.save() }

            ICOSToggleRow("Allow personal voice replication", isOn: $voice.profile.replicationEnabled)
                .onChange(of: voice.profile.replicationEnabled) { _, enabled in
                    if enabled {
                        voice.profile.trainingConsentAccepted = true
                    }
                    voice.save()
                }

            ICOSToggleRow("I consent to storing voice samples for my private ICOS voice profile", isOn: $voice.profile.trainingConsentAccepted)
                .onChange(of: voice.profile.trainingConsentAccepted) { _, accepted in
                    if !accepted {
                        voice.profile.replicationEnabled = false
                    }
                    voice.save()
                }

            ICOSTextInput("Local voice model path", placeholder: "Local voice model path", text: $voice.profile.localModelPath)
                .disabled(voice.profile.provider != .localVoiceModel)
                .onSubmit { voice.save() }

            ICOSTextInput("Cloud voice endpoint", placeholder: "Cloud voice endpoint", text: $voice.profile.cloudEndpoint)
                .disabled(voice.profile.provider != .cloudVoiceModel)
                .onSubmit { voice.save() }

            HStack(spacing: ICOSSpacing.sm) {
                ICOSButton("Import Voice Sample", icon: .voice) {
                    voice.importTrainingSample()
                }
                .disabled(!voice.profile.trainingConsentAccepted)

                ICOSButton("Save Voice", icon: .success, role: .primary) {
                    voice.save()
                }
            }

            if voice.profile.samples.isEmpty {
                WorktreeRow(name: "Training samples", state: "None", icon: .loading)
            } else {
                ForEach(voice.profile.samples) { sample in
                    HStack {
                        WorktreeRow(name: sample.label, state: URL(fileURLWithPath: sample.filePath).lastPathComponent, icon: .listen)
                        Button {
                            voice.removeSample(sample)
                        } label: {
                            SVGImageView(icon: .trash)
                                .frame(
                                    width: ICOSControlTokens.buttonIconSize,
                                    height: ICOSControlTokens.buttonIconSize
                                )
                        }
                        .buttonStyle(.plain)
                        .help("Remove voice sample")
                    }
                }
            }

            Text(voice.statusText)
                .font(ICOSTypography.caption)
                .foregroundStyle(ICOSColors.textSecondary)
        }
    }
}
