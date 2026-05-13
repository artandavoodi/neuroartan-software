import SwiftUI

// MARK: - Cloud Providers Tab

struct ConnectorsCloudProvidersTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Cloud Providers",
            subtitle: "Connected cloud providers."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Cloud Providers")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
