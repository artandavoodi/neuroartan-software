import SwiftUI

// MARK: - Public Private Tab

struct PrivacyPublicPrivateTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Public Private",
            subtitle: "Public and private profile state."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Public Private")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
