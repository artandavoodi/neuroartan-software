import SwiftUI

// MARK: - Text Tab

struct AccessibilityTextTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Text",
            subtitle: "Text sizing and readability controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Text")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
