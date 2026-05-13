import SwiftUI

// MARK: - Contrast Tab

struct AccessibilityContrastTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Contrast",
            subtitle: "Contrast and visibility tuning."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Contrast")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
