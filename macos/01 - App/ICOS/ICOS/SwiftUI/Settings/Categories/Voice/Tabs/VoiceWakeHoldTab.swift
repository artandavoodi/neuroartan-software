import SwiftUI

// MARK: - Wake Hold Tab

struct VoiceWakeHoldTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Wake Hold",
            subtitle: "Wake and hold behavior."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Wake Hold")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
