import SwiftUI

// MARK: - Style Tab

struct PersonalizationStyleTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Style",
            subtitle: "Voice and writing style controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Style")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
