import SwiftUI

// MARK: - Models Tab

struct ConnectorsModelsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Models",
            subtitle: "Model catalog and model routing."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Models")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
