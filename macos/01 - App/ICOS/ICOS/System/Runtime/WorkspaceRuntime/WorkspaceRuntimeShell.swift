import SwiftUI

// MARK: - Workspace Runtime Shell

struct WorkspaceRuntimeShell: View {

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState

    @State private var isInspectorVisible = true

    // MARK: - Body

    var body: some View {
        HStack(spacing: ICOSShellTokens.shellSectionSpacing) {
            WorkspaceRuntimeSidebar()

            WorkspaceRuntimeCanvas()

            if isInspectorVisible {
                WorkspaceContextInspector(
                    title: "Workspace",
                    subtitle: "Active runtime context",
                    primaryGroup: WorkspaceInspectorGroup(
                        title: "State",
                        items: [
                            "Canvas active",
                            "Sidebar visible",
                            "Inspector visible"
                        ]
                    ),
                    secondaryGroup: WorkspaceInspectorGroup(
                        title: "Runtime",
                        items: [
                            "Workspace shell",
                            "Native window bridge",
                            "Titlebar connected"
                        ]
                    )
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosToggleInspector)) { _ in
            withAnimation(.easeOut(duration: ICOSMotion.panelStateDuration)) {
                isInspectorVisible.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ICOSMaterials.windowBackground)
    }
}

// MARK: - Workspace Context Inspector

private struct WorkspaceContextInspector: View {

    // MARK: - Properties

    let title: String
    let subtitle: String
    let primaryGroup: WorkspaceInspectorGroup
    let secondaryGroup: WorkspaceInspectorGroup

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSidebarTokens.sectionSpacing) {
            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                Text(title)
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text(subtitle)
                    .font(ICOSSidebarTokens.itemSubtitleFont)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            inspectorGroup(primaryGroup)

            inspectorGroup(secondaryGroup)

            Spacer()
        }
        .padding(ICOSShellTokens.shellSectionSpacing)
        .frame(width: ICOSRuntimeShellTokens.inspectorWidth, alignment: .topLeading)
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Inspector Group

    private func inspectorGroup(_ group: WorkspaceInspectorGroup) -> some View {
        VStack(alignment: .leading, spacing: ICOSSidebarTokens.rowSpacing) {
            Text(group.title.uppercased())
                .font(ICOSSidebarTokens.sectionTitleFont)
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            VStack(spacing: ICOSSpacing.xs) {
                ForEach(group.items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(ICOSSidebarTokens.itemTitleFont)
                            .foregroundStyle(ICOSSidebarColors.textPrimary)

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
                    .padding(.vertical, ICOSSidebarTokens.rowVerticalPadding)
                    .background(
                        RoundedRectangle(
                            cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                            style: .continuous
                        )
                        .fill(ICOSSidebarColors.rowPassiveFill.opacity(ICOSRuntimeShellTokens.inspectorRowFillOpacity))
                    )
                }
            }
        }
    }
}

// MARK: - Workspace Inspector Group

private struct WorkspaceInspectorGroup {
    let title: String
    let items: [String]
}

#Preview {
    WorkspaceRuntimeShell(
        appState: .preview()
    )
    .frame(
        width: ICOSRuntimeShellTokens.workspacePreviewWidth,
        height: ICOSRuntimeShellTokens.workspacePreviewHeight
    )
}
