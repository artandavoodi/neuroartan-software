import SwiftUI

// MARK: - Model Dashboard Tab

struct DashboardModelDashboardTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Model Dashboard",
            subtitle: "Model performance and routing."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Model Dashboard")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
