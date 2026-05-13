import SwiftUI

// MARK: - Motion Tab

struct AccessibilityMotionTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Motion",
            subtitle: "Motion and animation reduction."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Motion")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
