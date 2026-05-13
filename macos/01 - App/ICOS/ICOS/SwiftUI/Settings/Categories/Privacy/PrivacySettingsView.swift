import SwiftUI

// MARK: - Privacy Settings View

struct PrivacySettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Privacy",
            subtitle: "Telemetry, retention, export, linked sources, and public/private mode.",
            tabs: [
                SettingsCategoryTabItem(id: "exportDelete", title: "Export Delete") { AnyView(PrivacyExportDeleteTab()) },
            SettingsCategoryTabItem(id: "linkedSources", title: "Linked Sources") { AnyView(PrivacyLinkedSourcesTab()) },
            SettingsCategoryTabItem(id: "publicPrivate", title: "Public Private") { AnyView(PrivacyPublicPrivateTab()) },
            SettingsCategoryTabItem(id: "retention", title: "Retention") { AnyView(PrivacyRetentionTab()) },
            SettingsCategoryTabItem(id: "telemetry", title: "Telemetry") { AnyView(PrivacyTelemetryTab()) }
            ]
        )
    }
}
