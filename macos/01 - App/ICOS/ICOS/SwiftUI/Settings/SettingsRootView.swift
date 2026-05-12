import SwiftUI

// MARK: - Settings Root View

struct SettingsRootView: View {
    @ObservedObject var router: AppRouter
    @ObservedObject var shellState: ShellState
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        HStack(spacing: scaled(ICOSShellTokens.shellSectionSpacing)) {
            SettingsCategoryView(router: router)
                .frame(width: scaled(ICOSControlTokens.settingsCategoryColumnWidth))
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                publishTitlebarSidebarAlignment(
                                    sidebarRightEdgeX: proxy.frame(in: .global).maxX
                                )
                            }
                            .onChange(of: proxy.frame(in: .global).maxX) { _, newValue in
                                publishTitlebarSidebarAlignment(
                                    sidebarRightEdgeX: newValue
                                )
                            }
                    }
                }


            ICOSScrollView {
                SettingsDetailView(
                    category: router.selectedSettingsCategory,
                    shellState: shellState
                )
                .padding(.horizontal, scaled(ICOSShellTokens.shellSectionSpacing))
                .padding(.vertical, scaled(ICOSShellTokens.shellSectionSpacing))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(
                        cornerRadius: scaled(ICOSRadius.lg),
                        style: .continuous
                    )
                    .fill(ICOSMaterials.sidebarGlass)
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: scaled(ICOSRadius.lg),
                    style: .continuous
                )
            )
        }
        .background(ICOSMaterials.windowBackground)
    }

    private func publishTitlebarSidebarAlignment(sidebarRightEdgeX: CGFloat) {
        NotificationCenter.default.post(
            name: .icosSettingsSidebarTitlebarAlignmentDidChange,
            object: sidebarRightEdgeX
        )
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }
}

// MARK: - Settings Category View

struct SettingsCategoryView: View {
    @ObservedObject var router: AppRouter
    @ObservedObject private var profileManager = ProfileManager.shared
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var categories: [AppRouter.Route] {
        AppRouter.Route.allCases.filter(\.isSettingsCategory)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            settingsProfileHeader
                .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))
                .padding(.top, scaled(ICOSSpacing.lg))
                .padding(.bottom, scaled(ICOSSpacing.lg))

            ICOSScrollView {
                VStack(spacing: scaled(ICOSSpacing.xs)) {
                    ForEach(categories) { category in
                        settingsCategoryRow(category)
                    }
                }
                .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))
                .padding(.vertical, scaled(ICOSSpacing.sm))
            }
        }
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: scaled(ICOSRadius.lg),
                    style: .continuous
                )
                .fill(ICOSMaterials.sidebarGlass)
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: scaled(ICOSRadius.lg),
                style: .continuous
            )
        )
    }

    // MARK: - Category Row

    private func settingsCategoryRow(_ category: AppRouter.Route) -> some View {
        let isActive = router.selectedSettingsCategory == category

        return Button {
            router.openSettings(category)
        } label: {
            HStack(spacing: scaled(ICOSSidebarTokens.rowIconTextSpacing)) {
                SVGImageView(icon: category.icon)
                    .frame(
                        width: scaled(ICOSSidebarTokens.iconMD),
                        height: scaled(ICOSSidebarTokens.iconMD)
                    )
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)

                Text(category.title)
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                    .lineLimit(ICOSSidebarTokens.rowTitleLineLimit)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, scaled(ICOSSidebarTokens.hierarchyIndent))
            .padding(.trailing, scaled(ICOSSidebarTokens.rowHorizontalPadding))
            .padding(.vertical, scaled(ICOSSidebarTokens.rowVerticalPadding))
            .background {
                RoundedRectangle(
                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                    style: .continuous
                )
                .fill(
                    isActive
                    ? ICOSSidebarColors.rowActiveFill
                    : ICOSSidebarColors.background.opacity(ICOSSidebarTokens.inactiveRowOpacity)
                )
            }
            .contentShape(
                RoundedRectangle(
                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: ICOSMotion.sidebarStateDuration), value: isActive)
    }

    // MARK: - Profile Header

    private var settingsProfileHeader: some View {
        let profile = profileManager.activeProfile

        return HStack(spacing: scaled(ICOSSpacing.sm)) {
            Text(String(profile.publicIdentityName.prefix(1)))
                .font(.system(size: scaledFont(ICOSControlTokens.profileAvatarFontSize), weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .frame(
                    width: scaled(ICOSSidebarTokens.avatarSize),
                    height: scaled(ICOSSidebarTokens.avatarSize)
                )
                .background(ICOSSidebarColors.avatarFill)

            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.profileHeaderTextSpacing)) {
                Text(profile.publicIdentityName)
                    .font(.system(size: scaledFont(ICOSControlTokens.profileNameFontSize), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text(profile.username.isEmpty ? profileManager.accountID : "@\(profile.username)")
                    .font(.system(size: scaledFont(ICOSControlTokens.profileMetaFontSize), weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Settings Detail View

struct SettingsDetailView: View {
    let category: AppRouter.Route
    @ObservedObject var shellState: ShellState
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            switch category {
            case .general:
                GeneralSettingsPanel(shellState: shellState, runtimeSettings: services.runtimeSettings)
            case .appearance:
                AppearanceSettingsPanel(shellState: shellState)
            case .configuration:
                ConfigurationSettingsPanel(runtimeSettings: services.runtimeSettings)
            case .connectors:
                ConnectorsSettingsPanel(service: services.connectorRegistryService)
            case .personalization:
                PersonalizationSettingsPanel()
            case .environment:
                EnvironmentSettingsPanel(shellState: shellState)
            case .worktree:
                WorktreeSettingsPanel(shellState: shellState)
            case .browserUse:
                BrowserUseView(shellState: shellState)
            case .chatManagement:
                ChatManagementSettingsPanel(appState: services.appState)
            case .projects:
                ProjectManagerView(viewModel: services.projectManager, shellState: shellState)
            case .files:
                FileManagerView()
            case .recents, .shared, .archive,
                 .intelligenceDashboard, .sessions, .providers, .connections, .terminalRuntime, .knowledgeBase,
                 .kanban, .automationJobs, .usage, .mail, .messaging, .skills, .diagnostics, .voiceRuntime,
                 .desktopRuntime:
                EmptyView()
            case .chat, .developer, .continuity, .settings:
                EmptyView()
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
