import SwiftUI

// MARK: - Accessibility Access Tab

struct PermissionsAccessibilityAccessTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Accessibility Access",
            subtitle: "Accessibility permission status."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Accessibility Access")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
