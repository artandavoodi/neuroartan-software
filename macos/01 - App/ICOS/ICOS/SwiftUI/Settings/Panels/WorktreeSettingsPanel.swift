import SwiftUI

struct WorktreeSettingsPanel: View {
    @ObservedObject var shellState: ShellState

    var body: some View {
        SettingsSectionCard(title: "Branch and Worktree", icon: .worktree) {
            WorktreeRow(name: "main", state: "Active", icon: .branch)
            WorktreeRow(name: "runtime-hardening", state: "Ready", icon: .success)
            WorktreeRow(name: "ui-system-rebuild", state: "In Progress", icon: .loading)
        }

        SettingsSectionCard(title: "Process Tracking", icon: .response) {
            WorktreeRow(name: "Router", state: "Running", icon: .success)
            WorktreeRow(name: "Theme", state: "Running", icon: .success)
            WorktreeRow(name: "Behavior", state: "Running", icon: .success)
        }
    }
}
