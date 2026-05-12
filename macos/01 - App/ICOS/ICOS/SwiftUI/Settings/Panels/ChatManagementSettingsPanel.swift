import SwiftUI

struct ChatManagementSettingsPanel: View {
    @ObservedObject var appState: ICOSAppState
    @State private var contextRetention = 8.0
    @State private var memoryIndexing = true

    var body: some View {
        SettingsSectionCard(title: "Conversation History", icon: .chatManagement) {
            WorktreeRow(name: "Current messages", state: "\(appState.activeSession.messages.count)", icon: .console)
            ICOSToggleRow("Memory indexing", isOn: $memoryIndexing)
            ICOSSliderRow(
                "Context retention",
                subtitle: "Adjust how much recent conversation context remains available.",
                value: $contextRetention,
                in: 2...24
            )
        }
    }
}
