import SwiftUI

// MARK: - Runtime Tab

struct ConfigurationRuntimeTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        RuntimeSettingsView(runtimeSettings: runtimeSettings)
    }
}
