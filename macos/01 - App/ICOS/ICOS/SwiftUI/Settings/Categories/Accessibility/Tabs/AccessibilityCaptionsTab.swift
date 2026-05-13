import SwiftUI

// MARK: - Captions Tab

struct AccessibilityCaptionsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Captions",
            subtitle: "Captioning and transcript visibility."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Captions")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
