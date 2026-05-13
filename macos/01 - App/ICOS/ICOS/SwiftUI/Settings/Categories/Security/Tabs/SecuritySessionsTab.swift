import SwiftUI

// MARK: - Sessions Tab

struct SecuritySessionsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Sessions",
            subtitle: "Session visibility and control."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Sessions")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
