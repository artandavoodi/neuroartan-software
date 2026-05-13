import SwiftUI

// MARK: - Linked Accounts Tab

struct SecurityLinkedAccountsTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Linked Accounts",
            subtitle: "Linked account management."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Linked Accounts")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
