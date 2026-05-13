import SwiftUI

// MARK: - Screen Reader Tab

struct AccessibilityScreenReaderTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Screen Reader",
            subtitle: "Screen reader support and spoken output."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Screen Reader")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
