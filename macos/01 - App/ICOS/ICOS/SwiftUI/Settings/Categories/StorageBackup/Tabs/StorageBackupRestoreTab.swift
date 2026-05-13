import SwiftUI

// MARK: - Restore Tab

struct StorageBackupRestoreTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Restore",
            subtitle: "Restore and recovery controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Restore")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
