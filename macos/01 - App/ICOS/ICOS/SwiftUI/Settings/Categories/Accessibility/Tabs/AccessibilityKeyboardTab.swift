import SwiftUI

// MARK: - Keyboard Tab

struct AccessibilityKeyboardTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Keyboard",
            subtitle: "Keyboard accessibility controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Keyboard")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
