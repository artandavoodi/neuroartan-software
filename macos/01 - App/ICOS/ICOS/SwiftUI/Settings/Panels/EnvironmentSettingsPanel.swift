import SwiftUI

struct EnvironmentSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @EnvironmentObject private var services: SystemServices
    @State private var localRuntimeEnabled = true
    @State private var cloudSyncEnabled = false

    var body: some View {
        SettingsSectionCard(title: "Runtime Environment", icon: .environment) {
            ICOSToggleRow("Local runtime", isOn: $localRuntimeEnabled)
            ICOSToggleRow("Cloud sync", isOn: $cloudSyncEnabled)
            ICOSPickerRow(
                "Execution environment",
                selection: $shellState.workExecutionMode,
                options: [
                    ICOSPickerOption(value: "Fast", title: "Fast"),
                    ICOSPickerOption(value: "Balanced", title: "Balanced"),
                    ICOSPickerOption(value: "Deep", title: "Deep")
                ]
            )
        }

        EditorBridgeSettingsPanel(editorBridge: services.externalEditorBridge)
    }
}
