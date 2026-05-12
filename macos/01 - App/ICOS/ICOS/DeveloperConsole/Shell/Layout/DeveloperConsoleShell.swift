import SwiftUI

// MARK: - Developer Console Shell

struct DeveloperConsoleShell: View {

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState

    @Binding var inputText: String
    @Binding var webSearchEnabled: Bool
    @Binding var rightPanel: DeveloperRightPanel
    @State private var inspectorCollapsed = true
    @State private var inspectorExpanded = false
    @State private var sidebarCollapsed = false
    @EnvironmentObject private var services: SystemServices
    @EnvironmentObject private var themeState: ThemeState

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: ICOSShellTokens.shellSectionSpacing) {
            DeveloperWorkspaceSidebar(
                appState: appState,
                projects: services.projectManager,
                files: services.workspaceFileService,
                rightPanel: $rightPanel,
                isCollapsed: $sidebarCollapsed
            )
            .frame(width: sidebarCollapsed ? ICOSDeveloperShellTokens.sidebarCollapsedWidth : ICOSDeveloperShellTokens.sidebarWidth)
            .animation(ICOSMotion.quick, value: sidebarCollapsed)

            DeveloperConsoleCenterCanvas(
                appState: appState,
                inputText: $inputText,
                webSearchEnabled: $webSearchEnabled,
                rightPanel: $rightPanel
            )
            .frame(minWidth: ICOSDeveloperShellTokens.centerMinWidth, maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: ICOSShellTokens.workspaceRadius,
                    style: .continuous
                )
            )
            .layoutPriority(1)

            if inspectorCollapsed {
                DeveloperInspectorRail(
                    selection: $rightPanel,
                    onExpand: {
                        NotificationCenter.default.post(name: .icosSetSecondarySidebarVisibility, object: false)
                        withAnimation(ICOSMotion.quick) {
                            inspectorCollapsed = false
                        }
                    }
                )
                .frame(width: ICOSDeveloperShellTokens.inspectorRailWidth)
                .frame(maxHeight: .infinity)
            }

            if !inspectorCollapsed {
                DeveloperInspectorShell(
                    appState: appState,
                    selection: rightPanel,
                    isExpanded: inspectorExpanded,
                    onToggleExpanded: {
                        withAnimation(ICOSMotion.quick) {
                            inspectorExpanded.toggle()
                            publishExpandedState(inspectorExpanded)
                        }
                    },
                    onCollapse: {
                        withAnimation(ICOSMotion.quick) {
                            inspectorExpanded = false
                            inspectorCollapsed = true
                            publishExpandedState(false)
                        }
                    }
                )
                .frame(width: inspectorExpanded ? ICOSDeveloperShellTokens.inspectorExpandedWidth : ICOSDeveloperShellTokens.inspectorWidth)
                .layoutPriority(inspectorExpanded ? 2 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(ICOSMotion.quick, value: themeState.runtimeSignature)
        .animation(ICOSMotion.quick, value: inspectorExpanded)
        .onAppear {
            NotificationCenter.default.post(name: .icosSetSecondarySidebarVisibility, object: false)
        }
        .onDisappear {
            publishExpandedState(false)
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSetDeveloperReviewExpanded)) { notification in
            guard let isExpanded = notification.object as? Bool else { return }
            setExpandedReview(isExpanded)
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSecondarySidebarVisibilityDidChange)) { notification in
            guard let isVisible = notification.object as? Bool else { return }
            guard isVisible else { return }
            guard !inspectorCollapsed else { return }
            withAnimation(ICOSMotion.quick) {
                inspectorExpanded = false
                inspectorCollapsed = true
            }
            publishExpandedState(false)
        }
    }

    private func setExpandedReview(_ isExpanded: Bool) {
        withAnimation(ICOSMotion.quick) {
            inspectorExpanded = isExpanded
            if isExpanded {
                inspectorCollapsed = false
            }
        }

        if !isExpanded {
            publishExpandedState(false)
        }
    }

    private func publishExpandedState(_ isExpanded: Bool) {
        NotificationCenter.default.post(
            name: .icosDeveloperReviewExpandedDidChange,
            object: isExpanded
        )

        guard isExpanded else { return }

        NotificationCenter.default.post(name: .icosSetSidebarVisibility, object: false)
        NotificationCenter.default.post(name: .icosSetSecondarySidebarVisibility, object: false)
    }
}

private struct DeveloperInspectorRail: View {
    @Binding var selection: DeveloperRightPanel
    let onExpand: () -> Void
    @State private var isRailRevealed = false

    var body: some View {
        VStack(spacing: ICOSDeveloperSidebarTokens.collapsedRailSpacing) {
            ForEach(DeveloperRightPanel.allCases) { route in
                railButton(for: route)
            }

            Spacer(minLength: 0)
        }
        .opacity(isRailRevealed ? 1 : 0)
        .offset(y: isRailRevealed ? 0 : -ICOSDeveloperSidebarTokens.collapsedRailSpacing)
        .allowsHitTesting(isRailRevealed)
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.vertical, ICOSSidebarTokens.accountOuterPadding)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(ICOSMotion.quick) {
                isRailRevealed = hovering
            }
        }
    }

    private func railButton(for route: DeveloperRightPanel) -> some View {
        Button {
            selection = route
            onExpand()
        } label: {
            SVGImageView(icon: route.icon)
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
                    in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                )
        }
        .buttonStyle(.plain)
        .help(route.rawValue)
    }
}
