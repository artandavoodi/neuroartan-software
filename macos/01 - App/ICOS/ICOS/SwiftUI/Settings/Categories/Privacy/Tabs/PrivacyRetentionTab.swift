import SwiftUI

// MARK: - Retention Tab

struct PrivacyRetentionTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Retention",
            subtitle: "Retention and lifespan rules."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Retention")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
