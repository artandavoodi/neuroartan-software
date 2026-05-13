import SwiftUI

// MARK: - Startup Tab

struct GeneralStartupTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        SettingsSectionCard(
            title: "Startup",
            subtitle: "Current runtime state and startup defaults."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                WorktreeRow(name: "Mode", state: runtimeSettings.mode.title, icon: .configuration)
                WorktreeRow(name: "Provider", state: runtimeSettings.activeProviderTitle, icon: .cloud)
                WorktreeRow(name: "Model", state: runtimeSettings.activeModelTitle, icon: .knowledge)
                WorktreeRow(name: "Endpoint", state: runtimeSettings.activeEndpointTitle, icon: .cloud)
            }
        }
    }
}
