import SwiftUI

struct SidebarSearchField: View {

    @Binding var text: String

    var body: some View {
        HStack(spacing: ICOSSidebarTokens.searchItemSpacing) {
            SVGImageView(icon: .search)
                .frame(
                    width: ICOSSidebarTokens.iconXS,
                    height: ICOSSidebarTokens.iconXS
                )
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            ICOSTextInput("Search", placeholder: "Search", text: $text)
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
