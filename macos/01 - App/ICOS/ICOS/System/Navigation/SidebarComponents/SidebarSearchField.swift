import SwiftUI

struct SidebarSearchField: View {

    @Binding var text: String
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        HStack(spacing: scaled(ICOSSidebarTokens.searchItemSpacing)) {
            SVGImageView(icon: .search)
                .frame(
                    width: ICOSSidebarTokens.iconXS,
                    height: ICOSSidebarTokens.iconXS
                )
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            ICOSTextInput("", placeholder: "Search", text: $text, showBorder: false, compact: true)
        }
        .padding(.horizontal, ICOSSidebarTokens.searchHorizontalPadding)
        .padding(.vertical, ICOSSidebarTokens.searchVerticalPadding)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: ICOSSidebarTokens.searchCornerRadius,
                    style: .continuous
                )
                .fill(ICOSSidebarColors.searchFill)
            }
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

#Preview {
    VStack {
        SidebarSearchField(
            text: .constant("")
        )
    }
    .padding(ICOSSpacing.md)
    .frame(width: ICOSSidebarTokens.searchPreviewWidth)
}
