import SwiftUI

// MARK: - Camera Tab

struct PermissionsCameraTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Camera",
            subtitle: "Camera permission scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Camera")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
