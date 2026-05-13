import SwiftUI

// MARK: - Contacts Tab

struct PermissionsContactsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Contacts",
            subtitle: "Contacts access controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Contacts")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
