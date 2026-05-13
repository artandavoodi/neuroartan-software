import SwiftUI

// MARK: - Analytics Tab

struct DashboardAnalyticsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Analytics",
            subtitle: "Usage and trend visibility."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Analytics")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
