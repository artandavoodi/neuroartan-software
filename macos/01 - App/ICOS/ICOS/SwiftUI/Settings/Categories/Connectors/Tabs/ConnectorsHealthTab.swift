import SwiftUI

// MARK: - Health Tab

struct ConnectorsHealthTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Health",
            subtitle: "Connector status and diagnostics."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Health")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
