import SwiftUI

// MARK: - Cloud Provider Section

struct CloudProviderSection: View {
    @ObservedObject var runtimeSettings: RuntimeSettingsState
    @State private var isScanning = false

    var body: some View {
        SettingsSectionCard(
            title: "Cloud Provider",
            subtitle: "OpenAI-compatible endpoint and external model routing."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                ICOSTextInput(
                    "Endpoint",
                    placeholder: "https://api.openai.com/v1",
                    text: $runtimeSettings.cloudEndpoint
                )

                SecureField("API key", text: $runtimeSettings.cloudAPIKey)
                    .textFieldStyle(.roundedBorder)

                ICOSTextInput(
                    "Selected model ID",
                    placeholder: "gpt-4.1-mini",
                    text: $runtimeSettings.selectedModelID
                )

                HStack(spacing: ICOSSpacing.sm) {
                    ICOSButton("Load LM Studio preset", icon: .cloud) {
                        runtimeSettings.enableLMStudioPreset()
                    }

                    ICOSButton("Scan provider models", icon: .update, role: .primary) {
                        isScanning = true
                        Task {
                            await runtimeSettings.refreshExternalModels()
                            isScanning = false
                        }
                    }
                    .disabled(isScanning)
                }

                Text(isScanning ? "Scanning provider models…" : runtimeSettings.modelDiscoveryStatus)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textSecondary)

                if !runtimeSettings.discoveredModels.isEmpty {
                    VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                        ForEach(runtimeSettings.discoveredModels) { model in
                            Button {
                                runtimeSettings.selectExternalModel(id: model.id)
                            } label: {
                                WorktreeRow(
                                    name: model.id,
                                    state: model.owner,
                                    icon: .knowledge
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                HStack {
                    Spacer(minLength: 0)
                    Button("Save provider settings") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
