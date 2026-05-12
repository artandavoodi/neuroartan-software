import SwiftUI

// MARK: - Sidebar Route Row

struct SidebarRouteRow: View {
    let title: String
    let icon: ICOSIcon
    let isActive: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: ICOSSidebarTokens.rowIconTextSpacing) {
                SVGImageView(icon: icon)
                    .frame(
                        width: ICOSSidebarTokens.iconMD,
                        height: ICOSSidebarTokens.iconMD
                    )
                    .foregroundStyle(iconColor)

                Text(title)
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(titleColor)
                    .lineLimit(ICOSSidebarTokens.rowTitleLineLimit)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, ICOSSidebarTokens.hierarchyIndent)
            .padding(.trailing, ICOSSidebarTokens.rowHorizontalPadding)
            .padding(.vertical, ICOSSidebarTokens.rowVerticalPadding)
            .background(rowBackground)
            .contentShape(RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .animation(.easeOut(duration: ICOSMotion.sidebarStateDuration), value: isActive)
        .animation(.easeOut(duration: ICOSMotion.hoverStateDuration), value: isHovered)
    }

    // MARK: - State Styling

    private var rowBackground: some View {
        RoundedRectangle(
            cornerRadius: ICOSSidebarTokens.rowCornerRadius,
            style: .continuous
        )
        .fill(backgroundFill)
    }

    private var backgroundFill: Color {
        if isActive {
            return ICOSSidebarColors.rowActiveFill.opacity(ICOSSidebarTokens.activeOpacity)
        }

        if isHovered {
            return ICOSSidebarColors.rowPassiveFill.opacity(ICOSSidebarTokens.hoverOpacity)
        }

        return ICOSSidebarColors.background.opacity(ICOSSidebarTokens.inactiveRowOpacity)
    }

    private var titleColor: Color {
        isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary
    }

    private var iconColor: Color {
        isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary
    }
}
