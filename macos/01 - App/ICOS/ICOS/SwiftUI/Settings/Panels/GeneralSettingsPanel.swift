import SwiftUI

struct GeneralSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @ObservedObject var runtimeSettings: RuntimeSettingsState
    private let executionModes = ["Fast", "Balanced", "Deep"]
    private let processingModes = ["Minimal", "Adaptive", "Deliberate"]

    var body: some View {
        SettingsSectionCard(title: "Execution", icon: .environment) {
            ICOSPickerRow(
                "App mode",
                selection: $runtimeSettings.mode,
                options: [
                    ICOSPickerOption(value: RuntimeMode.local, title: "Local"),
                    ICOSPickerOption(value: RuntimeMode.cloud, title: "Cloud"),
                    ICOSPickerOption(value: RuntimeMode.auto, title: "Hybrid")
                ]
            )
            .onChange(of: runtimeSettings.mode) { _, _ in runtimeSettings.save() }

            ICOSPickerRow(
                "Work execution mode",
                selection: $shellState.workExecutionMode,
                options: executionModes.map { mode in
                    ICOSPickerOption(value: mode, title: mode)
                }
            )

            ICOSPickerRow(
                "Processing mode",
                selection: $shellState.processingMode,
                options: processingModes.map { mode in
                    ICOSPickerOption(value: mode, title: mode)
                }
            )
        }

        SettingsSectionCard(title: "Workspace", icon: .projectManagement) {
            ICOSTextInput("Active project", placeholder: "Active project", text: $shellState.activeProject)
            ICOSToggleRow("Enable project switching controls", isOn: .constant(true))
            ICOSToggleRow("Show worktree management in shell", isOn: .constant(true))
        }
    }
}
