import SwiftUI

struct ChatManagementSettingsPanel: View {
    @ObservedObject var appState: ICOSAppState
    @AppStorage("ICOS.Configuration.ChatManagement.ContextRetention") private var contextRetention = 12.0
    @AppStorage("ICOS.Configuration.ChatManagement.MemoryIndexing") private var memoryIndexing = true
    @AppStorage("ICOS.Configuration.ChatManagement.AutoArchive") private var autoArchive = false

    var body: some View {
        SettingsSectionCard(title: "Conversation History", icon: .chatManagement) {
            WorktreeRow(name: "Current messages", state: "\(appState.activeSession.messages.count)", icon: .console)
            ICOSToggleRow("Memory indexing", isOn: $memoryIndexing)
            ICOSToggleRow("Auto archive resolved chats", isOn: $autoArchive)
            ICOSSliderRow(
                "Context retention",
                subtitle: "Adjust how much recent conversation context remains available.",
                value: $contextRetention,
                in: 2...32
            )
        }
    }
}
