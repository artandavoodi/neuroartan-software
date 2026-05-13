import SwiftUI

// MARK: - Runtime Settings View

struct RuntimeSettingsView: View {
    @ObservedObject var runtimeSettings: RuntimeSettingsState

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.lg) {
            RuntimeModeSection(runtimeSettings: runtimeSettings)
            CloudProviderSection(runtimeSettings: runtimeSettings)
            LocalModelSection(runtimeSettings: runtimeSettings)
        }
    }
}
