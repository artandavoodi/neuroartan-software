import SwiftUI

// MARK: - Anti Impersonation Tab

struct SecurityAntiImpersonationTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Anti Impersonation",
            subtitle: "Impersonation defense controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Anti Impersonation")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
