import SwiftUI

// MARK: - Personalization Settings View

struct PersonalizationSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Personalization",
            subtitle: "Identity, profile, memory, style, tone, and social graph.",
            tabs: [
                SettingsCategoryTabItem(id: "identity", title: "Identity") { AnyView(PersonalizationIdentityTab()) },
            SettingsCategoryTabItem(id: "memory", title: "Memory") { AnyView(PersonalizationMemoryTab()) },
            SettingsCategoryTabItem(id: "profile", title: "Profile") { AnyView(PersonalizationProfileTab()) },
            SettingsCategoryTabItem(id: "socialGraph", title: "Social Graph") { AnyView(PersonalizationSocialGraphTab()) },
            SettingsCategoryTabItem(id: "style", title: "Style") { AnyView(PersonalizationStyleTab()) },
            SettingsCategoryTabItem(id: "tone", title: "Tone") { AnyView(PersonalizationToneTab()) }
            ]
        )
    }
}
