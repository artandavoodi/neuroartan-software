import SwiftUI

// MARK: - Trust Tab

struct SecurityTrustTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Trust",
            subtitle: "Trust and verification state."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Trust")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
