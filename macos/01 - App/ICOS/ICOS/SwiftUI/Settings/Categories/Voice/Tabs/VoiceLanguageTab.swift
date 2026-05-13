import SwiftUI

// MARK: - Language Tab

struct VoiceLanguageTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Language",
            subtitle: "Language and speech locale."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Language")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
