import SwiftUI

struct WorktreeSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @AppStorage("ICOS.Configuration.Worktree.AutoCommitMetadata") private var autoCommitMetadata = true
    @AppStorage("ICOS.Configuration.Worktree.ProtectMainBranch") private var protectMainBranch = true
    @AppStorage("ICOS.Configuration.Worktree.ShowGitStatus") private var showGitStatus = true

    var body: some View {
        SettingsSectionCard(title: "Branch and Worktree", icon: .worktree) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                WorktreeRow(name: "Execution mode", state: shellState.workExecutionMode, icon: .configuration)
                WorktreeRow(name: "main", state: "Active", icon: .branch)
                WorktreeRow(name: "runtime-hardening", state: "Ready", icon: .success)

                ICOSToggleRow("Show Git status", isOn: $showGitStatus)
                ICOSToggleRow("Protect main branch", isOn: $protectMainBranch)
                ICOSToggleRow("Auto commit metadata", isOn: $autoCommitMetadata)
            }
        }

        SettingsSectionCard(title: "Process Tracking", icon: .response) {
            WorktreeRow(name: "Router", state: "Running", icon: .success)
            WorktreeRow(name: "Theme", state: "Running", icon: .success)
            WorktreeRow(name: "Behavior", state: "Running", icon: .success)
        }
    }
}
