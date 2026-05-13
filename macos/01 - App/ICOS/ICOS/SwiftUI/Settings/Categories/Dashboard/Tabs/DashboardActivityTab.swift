import SwiftUI

// MARK: - Activity Tab

struct DashboardActivityTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Activity",
            subtitle: "Recent activity and operational events."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Activity")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
