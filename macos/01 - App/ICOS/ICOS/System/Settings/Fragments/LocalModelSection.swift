import SwiftUI

// MARK: - Local Model Section

struct LocalModelSection: View {
    @ObservedObject var runtimeSettings: RuntimeSettingsState

    var body: some View {
        SettingsSectionCard(
            title: "Local Model",
            subtitle: "GGUF discovery and local model selection."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                Text(runtimeSettings.localModelStatus)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textSecondary)

                HStack(spacing: ICOSSpacing.sm) {
                    ICOSButton("Rescan local models", icon: .update, role: .primary) {
                        runtimeSettings.refreshLocalModels()
                    }

                    ICOSButton("Save local selection", icon: .success) {
                        runtimeSettings.save()
                    }
                }

                if !runtimeSettings.localModels.isEmpty {
                    VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                        ForEach(runtimeSettings.localModels, id: \.id) { model in
                            Button {
                                runtimeSettings.selectLocalModel(id: model.id)
                            } label: {
                                WorktreeRow(
                                    name: model.name,
                                    state: model.path,
                                    icon: .knowledge
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
