import SwiftUI

// MARK: - Sign In Tab

struct SecuritySignInTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Sign In",
            subtitle: "Authentication and sign-in flow."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Sign In")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
