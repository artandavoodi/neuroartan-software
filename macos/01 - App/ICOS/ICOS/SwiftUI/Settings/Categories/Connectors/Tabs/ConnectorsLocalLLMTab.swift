import SwiftUI

// MARK: - Local LLM Tab

struct ConnectorsLocalLLMTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Local LLM",
            subtitle: "Local model runtime integration."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Local LLM")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
