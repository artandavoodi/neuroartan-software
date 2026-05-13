import SwiftUI

// MARK: - Linked Sources Tab

struct PrivacyLinkedSourcesTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Linked Sources",
            subtitle: "Linked source visibility and scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Linked Sources")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
