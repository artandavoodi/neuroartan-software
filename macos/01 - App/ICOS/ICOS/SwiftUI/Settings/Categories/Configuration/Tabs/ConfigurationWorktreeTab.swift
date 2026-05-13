import SwiftUI

// MARK: - Worktree Tab

struct ConfigurationWorktreeTab: View {
    let shellState: ShellState

    var body: some View {
        WorktreeSettingsPanel(shellState: shellState)
    }
}
