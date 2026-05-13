import SwiftUI

// MARK: - Memory Tab

struct PersonalizationMemoryTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Memory",
            subtitle: "Personal memory and recall settings."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Memory")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
