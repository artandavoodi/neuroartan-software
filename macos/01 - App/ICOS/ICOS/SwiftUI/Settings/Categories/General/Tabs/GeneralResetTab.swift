import SwiftUI

// MARK: - Reset Tab

struct GeneralResetTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        SettingsSectionCard(
            title: "Reset",
            subtitle: "Reload or clear runtime state."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                Button("Reload saved runtime") {
                    runtimeSettings.load()
                }
                .buttonStyle(.borderedProminent)

                Button("Clear runtime fields") {
                    runtimeSettings.mode = .local
                    runtimeSettings.cloudAPIKey = ""
                    runtimeSettings.cloudEndpoint = ""
                    runtimeSettings.selectedModelID = ""
                    runtimeSettings.localProviderEnabled = true
                    runtimeSettings.externalProviderEnabled = false
                    runtimeSettings.selectedLocalModelID = ""
                    runtimeSettings.save()
                    runtimeSettings.refreshLocalModels()
                }
                .buttonStyle(.bordered)

                Text("This restores the runtime owner without theatrical placeholders.")
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
    }
}
