import SwiftUI

// MARK: - Secondary Sidebar Panel

struct SecondarySidebarPanel: View {
    @ObservedObject var shellState: ShellState
    @ObservedObject var router: AppRouter
    @ObservedObject var appState: ICOSAppState
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            secondarySidebarHeader

            Divider()
                .background(ICOSMaterials.separator)

            ICOSScrollView {
                VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
                    routeSecondarySidebarContent
                    runtimeSecondarySidebarContent
                    systemLogSecondarySidebarContent
                }
                .padding(.horizontal, scaled(ICOSShellTokens.secondarySidebarHorizontalPadding))
                .padding(.vertical, scaled(ICOSShellTokens.secondarySidebarVerticalPadding))
            }
        }
        .frame(width: scaled(ICOSShellTokens.secondarySidebarWidth))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.secondarySidebarBackground
            }
        }
    }

    // MARK: - Header

    private var secondarySidebarHeader: some View {
        HStack(spacing: scaled(ICOSSpacing.sm)) {
            SVGImageView(icon: .inspector)
                .frame(
                    width: scaled(ICOSSidebarTokens.iconMD),
                    height: scaled(ICOSSidebarTokens.iconMD)
                )

            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xxs)) {
                Text(router.currentRoute.title)
                    .font(.system(size: scaledFont(14), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text("Secondary Sidebar")
                    .font(.system(size: scaledFont(12), weight: .regular))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, scaled(ICOSShellTokens.secondarySidebarHorizontalPadding))
        .padding(.vertical, scaled(ICOSShellTokens.secondarySidebarHeaderVerticalPadding))
    }

    // MARK: - Route Secondary Sidebar

    @ViewBuilder
    private var routeSecondarySidebarContent: some View {
        switch router.currentRoute {
        case .projects, .files, .recents, .shared, .archive:
            secondarySidebarCard("Workspace", icon: .worktree) {
                metric("Route", router.currentRoute.title)
                metric("Project", shellState.activeProject)
                metric("Execution", shellState.workExecutionMode)
                metric("Workspace", services.workspaceFileService.rootURL?.lastPathComponent ?? "Unbound")
            }

        case .developer:
            secondarySidebarCard("Developer", icon: .configuration) {
                metric("Route", router.currentRoute.title)
                metric("Execution", shellState.workExecutionMode)
                metric("Provider", services.runtimeSettings.activeProviderTitle)
                metric("Model", services.runtimeSettings.activeModelTitle)
            }

        case .continuity:
            secondarySidebarCard("Continuity", icon: .continuity) {
                metric("Route", router.currentRoute.title)
                metric("Category", "Continuity")
                metric("Processing", shellState.processingMode)
                metric("Execution", shellState.workExecutionMode)
            }

        case .chat:
            secondarySidebarCard("Intelligence", icon: .response) {
                metric("Route", router.currentRoute.title)
                metric("Chat", appState.activeSession.isResponding ? "Responding" : "Idle")
                metric("Messages", "\(appState.activeSession.messages.count)")
                metric("Processing", shellState.processingMode)
            }

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
            secondarySidebarCard("Intelligence", icon: .thought) {
                metric("Route", router.currentRoute.title)
                metric("Category", "Intelligence")
                metric("Status", IntelligenceModuleCatalog.module(for: router.currentRoute)?.status.rawValue ?? "Overview")
                metric("Processing", shellState.processingMode)
            }

        case .settings,
             .general,
             .appearance,
             .configuration,
             .connectors,
             .personalization,
             .environment,
             .worktree,
             .browserUse,
             .chatManagement:
            secondarySidebarCard("Settings", icon: .settings) {
                metric("Route", router.currentRoute.title)
                metric("Mode", services.runtimeSettings.mode.title)
                metric("Provider", services.runtimeSettings.activeProviderTitle)
                metric("Model", services.runtimeSettings.activeModelTitle)
            }
        }
    }

    // MARK: - Runtime Secondary Sidebar

    private var runtimeSecondarySidebarContent: some View {
        secondarySidebarCard("Runtime State", icon: .environment) {
            metric("Mode", services.runtimeSettings.mode.title)
            metric("Provider", services.runtimeSettings.activeProviderTitle)
            metric("Model", services.runtimeSettings.activeModelTitle)
            metric("Web Agent", shellState.browserAgentEnabled ? "Enabled" : "Disabled")
        }
    }

    // MARK: - System Log Secondary Sidebar

    @ViewBuilder
    private var systemLogSecondarySidebarContent: some View {
        secondarySidebarCard("System Logs", icon: .file) {
            if services.permissionService.auditLog.isEmpty {
                logLine("No permission events")
            } else {
                ForEach(services.permissionService.auditLog.suffix(4)) { event in
                    logLine("\(event.action): \(event.allowed ? "allowed" : "blocked")")
                }
            }
        }
    }

    // MARK: - Card Components

    private func secondarySidebarCard<Content: View>(_ title: String, icon: ICOSIcon, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSShellTokens.secondarySidebarCardSpacing)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                SVGImageView(icon: icon)
                    .frame(
                        width: scaled(ICOSSidebarTokens.iconSM),
                        height: scaled(ICOSSidebarTokens.iconSM)
                    )

                Text(title)
                    .font(.system(size: scaledFont(12), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
            }

            content()
        }
        .padding(scaled(ICOSShellTokens.secondarySidebarCardPadding))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(cornerRadius: scaled(ICOSRadius.lg))
                    .fill(ICOSMaterials.elevatedSurface)
            }
        }
        .overlay {
            if ICOSMaterials.showsSurfaceBorders {
                RoundedRectangle(cornerRadius: scaled(ICOSRadius.lg))
                    .strokeBorder(
                        ICOSMaterials.stroke,
                        lineWidth: ICOSMaterials.strokeWidth
                    )
            }
        }
    }

    private func metric(_ key: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key)
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Spacer(minLength: scaled(ICOSSpacing.md))

            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .font(.system(size: scaledFont(12), weight: .regular))
    }

    private func logLine(_ text: String) -> some View {
        Text(text)
            .font(.system(size: scaledFont(11), weight: .regular, design: .monospaced))
            .foregroundStyle(ICOSSidebarColors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
