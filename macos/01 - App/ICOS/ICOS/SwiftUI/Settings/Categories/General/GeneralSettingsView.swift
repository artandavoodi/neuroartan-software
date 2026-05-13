import SwiftUI

// MARK: - General Settings View

struct GeneralSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "General",
            subtitle: "System-wide behavior, defaults, shortcuts, startup, and reset.",
            tabs: [
                SettingsCategoryTabItem(id: "behavior", title: "Behavior") { AnyView(GeneralBehaviorTab()) },
            SettingsCategoryTabItem(id: "defaults", title: "Defaults") { AnyView(GeneralDefaultsTab()) },
            SettingsCategoryTabItem(id: "shortcuts", title: "Shortcuts") { AnyView(GeneralShortcutsTab()) },
            SettingsCategoryTabItem(id: "startup", title: "Startup") { AnyView(GeneralStartupTab()) },
            SettingsCategoryTabItem(id: "reset", title: "Reset") { AnyView(GeneralResetTab()) }
            ]
        )
    }
}
