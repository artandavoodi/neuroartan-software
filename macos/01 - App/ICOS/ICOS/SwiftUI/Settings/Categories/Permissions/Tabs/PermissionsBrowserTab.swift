import SwiftUI

// MARK: - Browser Tab

struct PermissionsBrowserTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Browser",
            subtitle: "Browser permission scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Browser")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
