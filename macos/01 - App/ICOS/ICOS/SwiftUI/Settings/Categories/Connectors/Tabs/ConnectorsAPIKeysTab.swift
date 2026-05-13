import SwiftUI

// MARK: - API Keys Tab

struct ConnectorsAPIKeysTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "API Keys",
            subtitle: "Credential and key management."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("API Keys")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
