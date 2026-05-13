import SwiftUI

// MARK: - Input Tab

struct VoiceInputTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Input",
            subtitle: "Voice input and capture controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Input")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
