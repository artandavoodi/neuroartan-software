import SwiftUI

// MARK: - Runtime Mode Section

struct RuntimeModeSection: View {
    @ObservedObject var runtimeSettings: RuntimeSettingsState

    var body: some View {
        SettingsSectionCard(
            title: "Runtime Mode",
            subtitle: "Live execution posture and persistence."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                RuntimeModePicker(selection: $runtimeSettings.mode)

                ICOSToggleRow("Local provider enabled", isOn: $runtimeSettings.localProviderEnabled)
                ICOSToggleRow("External provider enabled", isOn: $runtimeSettings.externalProviderEnabled)

                WorktreeRow(name: "Routing summary", state: runtimeSettings.activeRoutingSummary, icon: .configuration)
                WorktreeRow(
                    name: "Saved mode",
                    state: runtimeSettings.mode.title,
                    icon: .update
                )

                HStack {
                    Spacer(minLength: 0)
                    Button("Reload saved state") {
                        runtimeSettings.load()
                    }
                    .buttonStyle(.bordered)

                    Button("Save runtime state") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
