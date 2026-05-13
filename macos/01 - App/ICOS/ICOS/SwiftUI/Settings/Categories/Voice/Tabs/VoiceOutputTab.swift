import SwiftUI

// MARK: - Output Tab

struct VoiceOutputTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Output",
            subtitle: "Voice output and speech settings."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Output")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
