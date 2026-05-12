import SwiftUI

// MARK: - Developer Inspector Shell

struct DeveloperInspectorShell: View {

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState
    let selection: DeveloperRightPanel
    let isExpanded: Bool
    let onToggleExpanded: (() -> Void)?
    let onCollapse: (() -> Void)?
    @EnvironmentObject private var services: SystemServices

    // MARK: - Inspector Title

    private var inspectorTitle: String {
        switch selection {
        case .projects:
            return "Workspace"
        case .patch:
            return "Review"
        case .sessions:
            return "Sessions"
        case .models:
            return "Runtime"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            inspectorHeader

            inspectorDivider

            inspectorContent
        }
        .padding(.vertical, ICOSSidebarTokens.accountOuterPadding)
    }

    // MARK: - Inspector Header

    private var inspectorHeader: some View {
        HStack(spacing: ICOSDeveloperSidebarTokens.headerSpacing) {
            Text(inspectorTitle)
                .font(ICOSTypography.section.weight(.semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Spacer(minLength: 0)

            Button {
                onToggleExpanded?()
            } label: {
                SVGImageView(icon: isExpanded ? .collapse : .expand)
                    .frame(
                        width: ICOSDeveloperSidebarTokens.headerButtonIconSize,
                        height: ICOSDeveloperSidebarTokens.headerButtonIconSize
                    )
                    .frame(
                        width: ICOSDeveloperSidebarTokens.headerButtonSize,
                        height: ICOSDeveloperSidebarTokens.headerButtonSize
                    )
                    .background(
                        ICOSMaterials.floatingSurface,
                        in: RoundedRectangle(
                            cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                            style: .continuous
                        )
                    )
            }
            .buttonStyle(.plain)
            .help(isExpanded ? "Collapse Review Surface" : "Expand Review Surface")

            Button {
                onCollapse?()
            } label: {
                SVGImageView(icon: .close)
                    .frame(
                        width: ICOSDeveloperSidebarTokens.headerButtonIconSize,
                        height: ICOSDeveloperSidebarTokens.headerButtonIconSize
                    )
                    .frame(
                        width: ICOSDeveloperSidebarTokens.headerButtonSize,
                        height: ICOSDeveloperSidebarTokens.headerButtonSize
                    )
                    .background(
                        ICOSMaterials.floatingSurface,
                        in: RoundedRectangle(
                            cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                            style: .continuous
                        )
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)
    }

    // MARK: - Inspector Content

    @ViewBuilder
    private var inspectorContent: some View {
        switch selection {
        case .projects:
            DeveloperProjectsPanel()

        case .patch:
            DeveloperPatchReviewPanel(files: services.workspaceFileService)

        case .sessions:
            DeveloperSessionsPanel(appState: appState)

        case .models:
            DeveloperModelsPanel()
        }
    }

    // MARK: - Inspector Divider

    private var inspectorDivider: some View {
        Rectangle()
            .fill(ICOSSidebarColors.separator.opacity(ICOSDeveloperInspectorTokens.dividerOpacity))
            .frame(height: ICOSDeveloperInspectorTokens.dividerHeight)
            .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
            .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)
    }
}
