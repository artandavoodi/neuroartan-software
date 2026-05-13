import SwiftUI

// MARK: - Archive Tab

struct StorageBackupArchiveTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Archive",
            subtitle: "Archive and long-term retention."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Archive")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
