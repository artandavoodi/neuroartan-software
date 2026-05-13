import SwiftUI

// MARK: - Profile Tab

struct PersonalizationProfileTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Profile",
            subtitle: "Profile data and preferences."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Profile")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
