import SwiftUI

// MARK: - Export Tab

struct StorageBackupExportTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Export",
            subtitle: "Export and portability controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Export")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
