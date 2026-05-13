import SwiftUI

// MARK: - Files Tab

struct PermissionsFilesTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Files",
            subtitle: "File system access controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Files")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
