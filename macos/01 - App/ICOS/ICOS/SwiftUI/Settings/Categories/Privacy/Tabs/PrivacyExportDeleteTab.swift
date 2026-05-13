import SwiftUI

// MARK: - Export Delete Tab

struct PrivacyExportDeleteTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Export Delete",
            subtitle: "Export and deletion controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Export Delete")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
