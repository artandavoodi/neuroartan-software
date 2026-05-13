import SwiftUI

// MARK: - Social Graph Tab

struct PersonalizationSocialGraphTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Social Graph",
            subtitle: "Relationship and connection mapping."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Social Graph")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
