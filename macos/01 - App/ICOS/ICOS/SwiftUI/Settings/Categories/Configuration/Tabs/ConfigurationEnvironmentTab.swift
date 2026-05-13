import SwiftUI

// MARK: - Environment Tab

struct ConfigurationEnvironmentTab: View {
    let shellState: ShellState

    var body: some View {
        EnvironmentSettingsPanel(shellState: shellState)
    }
}
