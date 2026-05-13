import SwiftUI

// MARK: - Microphone Tab

struct PermissionsMicrophoneTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Microphone",
            subtitle: "Microphone permission scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Microphone")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
