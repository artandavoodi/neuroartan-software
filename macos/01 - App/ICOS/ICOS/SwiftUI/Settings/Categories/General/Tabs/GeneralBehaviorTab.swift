import SwiftUI

// MARK: - Behavior Tab

struct GeneralBehaviorTab: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared

    var body: some View {
        RuntimeModeSection(runtimeSettings: runtimeSettings)
    }
}
