import SwiftUI

// MARK: - Tone Tab

struct PersonalizationToneTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Tone",
            subtitle: "Tone and communication calibration."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Tone")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
