import SwiftUI

// MARK: - Readiness Tab

struct DashboardReadinessTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Readiness",
            subtitle: "Operational readiness and state."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Readiness")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
