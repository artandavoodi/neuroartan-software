import SwiftUI

// MARK: - Chat Management Tab

struct ConfigurationChatManagementTab: View {
    @AppStorage("ICOS.Configuration.ChatManagement.MemoryIndexing") private var memoryIndexing = true
    @AppStorage("ICOS.Configuration.ChatManagement.ContextRetention") private var contextRetention = 12.0
    @AppStorage("ICOS.Configuration.ChatManagement.AutoArchive") private var autoArchive = false
    @AppStorage("ICOS.Configuration.ChatManagement.PinImportantThreads") private var pinImportantThreads = true

    var body: some View {
        SettingsSectionCard(
            title: "Chat Management",
            subtitle: "Conversation retention, indexing, and routing rules."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                ICOSToggleRow("Memory indexing", isOn: $memoryIndexing)
                ICOSToggleRow("Pin important threads", isOn: $pinImportantThreads)
                ICOSToggleRow("Auto archive resolved chats", isOn: $autoArchive)

                ICOSSliderRow(
                    "Context retention",
                    subtitle: "How much recent context remains active.",
                    value: $contextRetention,
                    in: 2...32
                )

                WorktreeRow(
                    name: "Status",
                    state: memoryIndexing ? "Memory ready" : "Memory off",
                    icon: memoryIndexing ? .success : .loading
                )
            }
        }
    }
}
