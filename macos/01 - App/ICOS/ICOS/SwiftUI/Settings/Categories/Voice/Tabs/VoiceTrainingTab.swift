import SwiftUI

// MARK: - Training Tab

struct VoiceTrainingTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Training",
            subtitle: "Voice training and calibration."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Training")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
