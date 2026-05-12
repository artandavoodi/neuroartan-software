import SwiftUI

struct SidebarHeader: View {

    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: ICOSSidebarTokens.headerItemSpacing) {
            SVGImageView(icon: .symbol)
                .frame(
                    width: ICOSSidebarTokens.headerSymbolSize,
                    height: ICOSSidebarTokens.headerSymbolSize
                )
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            VStack(alignment: .leading, spacing: ICOSSidebarTokens.headerTextSpacing) {
                Text(title)
                    .font(ICOSTypography.section)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text(subtitle)
                    .font(ICOSTypography.micro.weight(.medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            Spacer()

            SidebarHeaderIconButton(action: action)
        }
        .padding(.horizontal, ICOSSidebarTokens.headerHorizontalPadding)
        .padding(.vertical, ICOSSidebarTokens.headerVerticalPadding)
    }
    private func SidebarHeaderIconButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            SVGImageView(icon: .talk)
                .frame(
                    width: ICOSSidebarTokens.iconSM,
                    height: ICOSSidebarTokens.iconSM
                )
                .opacity(ICOSSidebarTokens.secondaryIconOpacity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SidebarHeader(
        title: "ICOS",
        subtitle: "Developer Runtime"
    ) {}
    .frame(width: ICOSSidebarTokens.headerPreviewWidth)
    .padding(ICOSSidebarTokens.headerPreviewPadding)
}
