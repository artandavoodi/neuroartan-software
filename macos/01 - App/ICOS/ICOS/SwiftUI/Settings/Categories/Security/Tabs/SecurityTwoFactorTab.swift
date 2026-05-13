import SwiftUI

// MARK: - Two Factor Tab

struct SecurityTwoFactorTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Two Factor",
            subtitle: "Two-factor authentication controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Two Factor")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
