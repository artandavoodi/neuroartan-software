import SwiftUI

struct SidebarRailButton: View {
    let icon: ICOSIcon
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSSidebarTokens.iconLG,
                    height: ICOSSidebarTokens.iconLG
                )
                .foregroundStyle(
                    isActive
                    ? ICOSSidebarColors.textPrimary
                    : ICOSSidebarColors.textSecondary
                )
                .frame(
                    width: ICOSSidebarTokens.railButtonWidth,
                    height: ICOSSidebarTokens.railButtonHeight
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                        style: .continuous
                    )
                    .fill(
                        isActive
                        ? ICOSSidebarColors.rowActiveFill
                        : ICOSSidebarColors.background.opacity(0)
                    )
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
