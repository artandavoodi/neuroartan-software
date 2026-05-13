import SwiftUI

// MARK: - Knowledge Graph Tab

struct DashboardKnowledgeGraphTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Knowledge Graph",
            subtitle: "Graph visibility and linked context."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Knowledge Graph")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
