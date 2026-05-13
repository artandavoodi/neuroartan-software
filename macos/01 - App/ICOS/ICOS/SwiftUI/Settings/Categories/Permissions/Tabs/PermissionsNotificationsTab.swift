import SwiftUI

// MARK: - Notifications Tab

struct PermissionsNotificationsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Notifications",
            subtitle: "Notification permission scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Notifications")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
