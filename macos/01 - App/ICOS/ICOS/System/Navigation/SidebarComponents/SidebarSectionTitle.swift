import SwiftUI

struct SidebarSectionTitle: View {

    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(ICOSTypography.micro.weight(.semibold))
            .foregroundStyle(ICOSSidebarColors.textSecondary)
            .tracking(0.8)
            .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: ICOSSidebarTokens.sectionTitlePreviewSpacing) {
        SidebarSectionTitle(title: "Workspace")
        SidebarSectionTitle(title: "Environment")
        SidebarSectionTitle(title: "Runtime")
    }
    .padding(ICOSSpacing.md)
    .frame(width: ICOSSidebarTokens.environmentPreviewWidth)
}
