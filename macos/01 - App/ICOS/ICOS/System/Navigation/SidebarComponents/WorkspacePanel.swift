import SwiftUI

struct WorkspacePanel: View {

    let searchText: String
    let onSelectWorkspaceRoute: (AppRouter.Route) -> Void

    private let workspaceItems: [WorkspacePanelItem] = [
        WorkspacePanelItem(
            title: "Projects",
            subtitle: "Active work environments",
            route: .projects,
            icon: .projectManagement
        ),
        WorkspacePanelItem(
            title: "Files",
            subtitle: "Project-bound file navigation",
            route: .files,
            icon: .fileManager
        ),
        WorkspacePanelItem(
            title: "Recents",
            subtitle: "Recently opened work",
            route: .recents,
            icon: .workspaceRecents
        ),
        WorkspacePanelItem(
            title: "Shared",
            subtitle: "Reusable workspace resources",
            route: .shared,
            icon: .workspaceShared
        ),
        WorkspacePanelItem(
            title: "Archive",
            subtitle: "Completed or paused work",
            route: .archive,
            icon: .workspaceArchive
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: ICOSSpacing.xs) {
                ForEach(workspaceItems) { item in
                    workspaceRow(item)
                }
            }
            .padding(.horizontal, ICOSSidebarTokens.footerHorizontalPadding)
            .padding(.top, ICOSSpacing.xs)

            Spacer(minLength: 0)
        }
        .frame(width: ICOSSidebarTokens.workspacePanelWidth)
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: .fileManager)
                .frame(
                    width: ICOSSidebarTokens.iconSM,
                    height: ICOSSidebarTokens.iconSM
                )
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Text("Workspace")
                .font(ICOSTypography.caption.weight(.semibold))
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Spacer()
        }
        .padding(.horizontal, ICOSSidebarTokens.footerHorizontalPadding)
        .padding(.vertical, ICOSSpacing.md)
    }

    // MARK: - Workspace Rows

    private func workspaceRow(_ item: WorkspacePanelItem) -> some View {
        Button {
            onSelectWorkspaceRoute(item.route)
        } label: {
            HStack(alignment: .center, spacing: ICOSSidebarTokens.rowIconTextSpacing) {
                SVGImageView(icon: item.icon)
                    .frame(
                        width: ICOSSidebarTokens.iconSM,
                        height: ICOSSidebarTokens.iconSM
                    )
                    .foregroundStyle(ICOSSidebarColors.textSecondary)

                VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                    Text(item.title)
                        .font(ICOSTypography.caption.weight(.semibold))
                        .foregroundStyle(ICOSSidebarColors.textPrimary)

                    Text(item.subtitle)
                        .font(ICOSTypography.caption)
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, ICOSSidebarTokens.hierarchyIndent)
            .padding(.trailing, ICOSSidebarTokens.rowHorizontalPadding)
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
            .clipShape(
                RoundedRectangle(
                    cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WorkspacePanel(
        searchText: "",
        onSelectWorkspaceRoute: { _ in }
    )
    .frame(height: ICOSSidebarTokens.previewHeight)
}

private struct WorkspacePanelItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let route: AppRouter.Route
    let icon: ICOSIcon
}
