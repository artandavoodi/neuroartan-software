import SwiftUI

// MARK: - Backup Tab

struct StorageBackupBackupTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Backup",
            subtitle: "Backup creation and scheduling."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Backup")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
