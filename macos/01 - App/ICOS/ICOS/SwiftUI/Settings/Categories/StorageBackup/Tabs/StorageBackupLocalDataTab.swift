import SwiftUI

// MARK: - Local Data Tab

struct StorageBackupLocalDataTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Local Data",
            subtitle: "Local data and cache control."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Local Data")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
