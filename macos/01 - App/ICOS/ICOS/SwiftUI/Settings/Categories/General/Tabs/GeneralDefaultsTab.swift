import SwiftUI

// MARK: - Defaults Tab

struct GeneralDefaultsTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.lg) {
            CloudProviderSection(runtimeSettings: runtimeSettings)
            LocalModelSection(runtimeSettings: runtimeSettings)
        }
    }
}
