import SwiftUI

// MARK: - Sync Tab

struct StorageBackupSyncTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Sync",
            subtitle: "Sync and mirroring controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Sync")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
