import SwiftUI

// MARK: - Shortcuts Tab

struct GeneralShortcutsTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        SettingsSectionCard(
            title: "Shortcuts",
            subtitle: "Operational actions for runtime maintenance."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                HStack {
                    Button("Refresh local models") {
                        runtimeSettings.refreshLocalModels()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Scan remote models") {
                        Task {
                            await runtimeSettings.refreshExternalModels()
                        }
                    }
                    .buttonStyle(.bordered)

                    Button("Save runtime") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.bordered)
                }

                Text("These actions bind the runtime owner to live provider state.")
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
    }
}
