import SwiftUI

struct NavigationShell: View {
    @ObservedObject var router: AppRouter
    @ObservedObject var appState: ICOSAppState
    @StateObject private var shellState = ShellState()
    @State private var isSidebarVisible = true
    @State private var isSpotlightSearchVisible = false
    @State private var isDeveloperReviewExpanded = false
    @EnvironmentObject private var services: SystemServices
    @EnvironmentObject private var themeState: ThemeState
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        ZStack {
            ICOSMaterials.windowBackground
                .ignoresSafeArea()

            GeometryReader { _ in
                VStack(spacing: scaled(ICOSShellTokens.shellSectionSpacing)) {
                    ICOSPrimaryShellSplitView(
                        isSidebarVisible: $isSidebarVisible,
                        sidebarWidth: ICOSSidebarTokens.expandedWidth + scaled(ICOSShellTokens.shellSectionSpacing),
                        sectionSpacing: scaled(ICOSShellTokens.shellSectionSpacing),
                        sidebar: {
                            SidebarView(
                                router: router,
                                shellState: shellState
                            )
                            .frame(width: ICOSSidebarTokens.expandedWidth)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: scaled(ICOSRadius.lg),
                                    style: .continuous
                                )
                            )
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        },
                        content: {
                            HStack(spacing: scaled(ICOSShellTokens.shellSectionSpacing)) {
                                content
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background {
                                        if ICOSMaterials.showsLayeredSurfaces {
                                            ICOSMaterials.panelBackground
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: scaled(ICOSRadius.lg),
                                            style: .continuous
                                        )
                                    )
                                    .layoutPriority(1)

                                if shellState.isSecondarySidebarVisible {
                                    if ICOSMaterials.showsPlainSeparators {
                                        Rectangle()
                                            .fill(ICOSMaterials.separator)
                                            .frame(width: ICOSMaterials.strokeWidth)
                                            .frame(maxHeight: .infinity)
                                    }

                                    SecondarySidebarPanel(
                                        shellState: shellState,
                                        router: router,
                                        appState: appState
                                    )
                                    .frame(width: scaled(ICOSShellTokens.secondarySidebarWidth))
                                    .background {
                                        if ICOSMaterials.showsLayeredSurfaces {
                                            ICOSMaterials.secondarySidebarBackground
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: scaled(ICOSRadius.lg),
                                            style: .continuous
                                        )
                                    )
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .layoutPriority(1)
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .layoutPriority(1)

                    if shellState.isBottomPanelVisible {
                        BottomPanelView(shellState: shellState)
                            .frame(height: scaled(ICOSShellTokens.bottomPanelHeight))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .layoutPriority(0)
                    }
                }
                .padding(scaled(ICOSShellTokens.shellSectionSpacing))
            }
            .blur(radius: isSpotlightSearchVisible ? scaled(ICOSNavigationShellTokens.spotlightBackgroundBlurRadius) : scaled(ICOSNavigationShellTokens.noBlurRadius))

            if isSpotlightSearchVisible {
                ICOSSpotlightSearchOverlay(isVisible: $isSpotlightSearchVisible)
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .animation(
            .easeInOut(duration: ICOSShellTokens.shellVisibilityAnimationDuration),
            value: shellState.isSecondarySidebarVisible
        )
        .animation(
            .easeInOut(duration: ICOSShellTokens.shellVisibilityAnimationDuration),
            value: isSidebarVisible
        )
        .animation(
            .easeInOut(duration: ICOSShellTokens.bottomPanelTransitionDuration),
            value: shellState.isBottomPanelVisible
        )
        .animation(ICOSMotion.quick, value: themeState.runtimeSignature)
        .onReceive(NotificationCenter.default.publisher(for: .icosToggleSidebar)) { _ in
            if router.currentRoute == .developer && isDeveloperReviewExpanded {
                setPrimarySidebarVisible(false)
                return
            }
            let nextVisibility = !isSidebarVisible
            setPrimarySidebarVisible(nextVisibility)
            if router.currentRoute == .developer && nextVisibility {
                setSecondarySidebarVisible(false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosToggleSecondarySidebar)) { _ in
            if router.currentRoute == .developer && isDeveloperReviewExpanded {
                setSecondarySidebarVisible(false)
                return
            }
            let nextVisibility = !shellState.isSecondarySidebarVisible
            setSecondarySidebarVisible(nextVisibility)
            if router.currentRoute == .developer && nextVisibility {
                setPrimarySidebarVisible(false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSetSidebarVisibility)) { notification in
            guard let isVisible = notification.object as? Bool else { return }
            if router.currentRoute == .developer && isDeveloperReviewExpanded && isVisible {
                setPrimarySidebarVisible(false)
                return
            }
            setPrimarySidebarVisible(isVisible)
            if router.currentRoute == .developer && isVisible {
                setSecondarySidebarVisible(false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSetSecondarySidebarVisibility)) { notification in
            guard let isVisible = notification.object as? Bool else { return }
            if router.currentRoute == .developer && isDeveloperReviewExpanded && isVisible {
                setSecondarySidebarVisible(false)
                return
            }
            setSecondarySidebarVisible(isVisible)
            if router.currentRoute == .developer && isVisible {
                setPrimarySidebarVisible(false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosDeveloperReviewExpandedDidChange)) { notification in
            guard let isExpanded = notification.object as? Bool else { return }
            isDeveloperReviewExpanded = isExpanded
            if router.currentRoute == .developer && isExpanded {
                setPrimarySidebarVisible(false)
                setSecondarySidebarVisible(false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosToggleBottomPanel)) { _ in
            shellState.isBottomPanelVisible.toggle()
            NotificationCenter.default.post(
                name: .icosBottomPanelVisibilityDidChange,
                object: shellState.isBottomPanelVisible
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosToggleSearch)) { _ in
            isSpotlightSearchVisible.toggle()
        }
        .onChange(of: router.currentRoute) { _, route in
            guard route == .developer else { return }
            setSecondarySidebarVisible(false)
        }
    }


    private func setPrimarySidebarVisible(_ isVisible: Bool) {
        isSidebarVisible = isVisible
        NotificationCenter.default.post(
            name: .icosSidebarVisibilityDidChange,
            object: isSidebarVisible
        )
    }

    private func setSecondarySidebarVisible(_ isVisible: Bool) {
        shellState.isSecondarySidebarVisible = isVisible
        NotificationCenter.default.post(
            name: .icosSecondarySidebarVisibilityDidChange,
            object: shellState.isSecondarySidebarVisible
        )
    }

    private func setDeveloperReviewExpanded(_ isExpanded: Bool) {
        isDeveloperReviewExpanded = isExpanded
        NotificationCenter.default.post(
            name: .icosSetDeveloperReviewExpanded,
            object: isExpanded
        )
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    // MARK: - Content Router

    @ViewBuilder
    private var content: some View {
        switch router.currentRoute {
        case .chat:
            UnifiedSessionView(appState: appState)

        case .developer:
            DeveloperConsoleView(appState: appState)

        case .continuity:
            WorkspaceEmptyRouteView(
                title: "Continuity",
                description: "Continuity runtime and long-range context will be managed here."
            )

        case .settings:
            SettingsRootView(router: router, shellState: shellState)

        case .projects:
            ProjectManagerView(viewModel: services.projectManager, shellState: shellState)

        case .files:
            FileManagerView()

        case .recents:
            WorkspaceEmptyRouteView(
                title: "Recents",
                description: "Recently opened workspace activity"
            )

        case .shared:
            WorkspaceEmptyRouteView(
                title: "Shared",
                description: "Shared workspace resources"
            )

        case .archive:
            WorkspaceEmptyRouteView(
                title: "Archive",
                description: "Archived workspace environments"
            )

        case .intelligenceDashboard,
             .sessions,
             .providers,
             .connections,
             .terminalRuntime,
             .knowledgeBase,
             .kanban,
             .automationJobs,
             .usage,
             .mail,
             .messaging,
             .skills,
             .diagnostics,
             .voiceRuntime,
             .desktopRuntime:
            IntelligenceModuleView(router: router, route: router.currentRoute)

        case .general,
             .appearance,
             .configuration,
             .connectors,
             .personalization,
             .environment,
             .worktree,
             .browserUse,
             .chatManagement:
            SettingsRootView(router: router, shellState: shellState)
        }
    }
}


// MARK: - ICOS Spotlight Search Overlay

private struct ICOSSpotlightSearchOverlay: View {
    @Binding var isVisible: Bool
    @State private var query = ""
    @FocusState private var isFocused: Bool
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        ZStack(alignment: .top) {
            ICOSMaterials.windowBackground
                .opacity(ICOSNavigationShellTokens.spotlightOverlayOpacity)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    isVisible = false
                }

            VStack(spacing: scaled(ICOSSpacing.sm)) {
                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    SVGImageView(icon: .search)
                        .frame(
                            width: scaled(ICOSNavigationShellTokens.spotlightSearchIconSize),
                            height: scaled(ICOSNavigationShellTokens.spotlightSearchIconSize)
                        )
                        .foregroundStyle(ICOSSidebarColors.textSecondary)

                    ICOSTextInput("Search", placeholder: "Search ICOS", text: $query)
                        .focused($isFocused)

                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            SVGImageView(icon: .close)
                                .frame(
                                    width: scaled(ICOSNavigationShellTokens.spotlightCloseIconSize),
                                    height: scaled(ICOSNavigationShellTokens.spotlightCloseIconSize)
                                )
                                .foregroundStyle(ICOSSidebarColors.textSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, scaled(ICOSSpacing.lg))
                .frame(height: scaled(ICOSNavigationShellTokens.spotlightSearchHeight))
                .background {
                    if ICOSMaterials.showsLayeredSurfaces {
                        RoundedRectangle(
                            cornerRadius: scaled(ICOSRadius.xl),
                            style: .continuous
                        )
                        .fill(ICOSMaterials.elevatedSurface)
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: scaled(ICOSRadius.xl),
                        style: .continuous
                    )
                )
                .overlay {
                    if ICOSMaterials.showsSurfaceBorders {
                        RoundedRectangle(
                            cornerRadius: scaled(ICOSRadius.xl),
                            style: .continuous
                        )
                        .strokeBorder(ICOSMaterials.stroke, lineWidth: ICOSMaterials.strokeWidth)
                    }
                }

                if !query.isEmpty {
                    VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
                        Text("Search results will index memory, workspace, documents, and runtime context.")
                            .font(.system(size: scaledFont(ICOSNavigationShellTokens.spotlightResultFontSize), weight: .regular))
                            .foregroundStyle(ICOSSidebarColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(scaled(ICOSSpacing.lg))
                    .background {
                        if ICOSMaterials.showsLayeredSurfaces {
                            RoundedRectangle(
                                cornerRadius: scaled(ICOSRadius.lg),
                                style: .continuous
                            )
                            .fill(ICOSMaterials.floatingSurface)
                        }
                    }
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: scaled(ICOSRadius.lg),
                            style: .continuous
                        )
                    )
                }
            }
            .frame(width: scaled(ICOSNavigationShellTokens.spotlightWidth))
            .padding(.top, scaled(ICOSNavigationShellTokens.spotlightTopPadding))
        }
        .onAppear {
            isFocused = true
        }
        .onExitCommand {
            isVisible = false
        }
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Workspace Empty Route View

private struct WorkspaceEmptyRouteView: View {
    let title: String
    let description: String
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            Text(title)
                .font(.system(size: scaledFont(ICOSNavigationShellTokens.emptyRouteTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Text(description)
                .font(.system(size: scaledFont(ICOSNavigationShellTokens.emptyRouteDescriptionFontSize), weight: .regular))
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(scaled(ICOSNavigationShellTokens.emptyRoutePadding))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.panelBackground
            }
        }
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
