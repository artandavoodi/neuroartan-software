import SwiftUI

// MARK: - Identity Tab

struct PersonalizationIdentityTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Identity",
            subtitle: "Identity and self-modeling controls."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Identity")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
