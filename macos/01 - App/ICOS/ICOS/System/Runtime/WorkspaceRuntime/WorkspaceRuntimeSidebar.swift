import SwiftUI

struct WorkspaceRuntimeSidebar: View {

    var body: some View {
        VStack(spacing: 0) {
            header

            Rectangle()
                .fill(ICOSSidebarColors.separator)
                .frame(height: ICOSShellTokens.sidebarSeparatorWidth)

            sections

            Spacer()
        }
        .frame(width: ICOSSidebarTokens.runtimeSidebarWidth)
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: ICOSSpacing.md) {
            SVGImageView(icon: .workspace)
                .frame(
                    width: ICOSSidebarTokens.iconLG,
                    height: ICOSSidebarTokens.iconLG
                )

            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                Text("Workspace")
                    .font(ICOSTypography.bodyStrong)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text("Runtime Environment")
                    .font(ICOSTypography.micro.weight(.medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, ICOSSidebarTokens.headerHorizontalPadding)
        .padding(.vertical, ICOSSpacing.lg)
    }

    // MARK: - Sections

    private var sections: some View {
        ICOSScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: ICOSSidebarTokens.sectionSpacing) {
                section(
                    title: "Workspace",
                    items: [
                        "Projects",
                        "Files",
                        "Recents",
                        "Shared",
                        "Archive"
                    ]
                )
            }
            .padding(ICOSSpacing.md)
        }
    }

    // MARK: - Section Builder

    private func section(
        title: String,
        items: [String]
    ) -> some View {
        VStack(alignment: .leading, spacing: ICOSSidebarTokens.rowSpacing) {
            Text(title.uppercased())
                .font(ICOSTypography.micro.weight(.semibold))
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .tracking(0.8)

            VStack(spacing: ICOSSpacing.xs) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(ICOSTypography.caption.weight(.medium))
                            .foregroundStyle(ICOSSidebarColors.textPrimary)

                        Spacer()
                    }
                    .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
                    .padding(.vertical, ICOSSidebarTokens.rowVerticalPadding)
                    .background {
                        if ICOSMaterials.showsLayeredSurfaces {
                            RoundedRectangle(
                                cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                                style: .continuous
                            )
                            .fill(ICOSSidebarColors.rowPassiveFill)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WorkspaceRuntimeSidebar()
        .frame(width: ICOSSidebarTokens.runtimeSidebarWidth, height: 760)
}
