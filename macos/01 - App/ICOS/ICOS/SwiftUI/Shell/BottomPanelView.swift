import SwiftUI

struct BottomPanelView: View {
    @ObservedObject var shellState: ShellState
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(spacing: 0) {
            header

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, scaled(ICOSShellTokens.bottomPanelHorizontalPadding))
                .padding(.vertical, scaled(ICOSShellTokens.bottomPanelVerticalPadding))
        }
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: ICOSShellTokens.workspaceRadius,
                    style: .continuous
                )
                .fill(ICOSMaterials.elevatedSurface)
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: ICOSShellTokens.workspaceRadius,
                style: .continuous
            )
        )
    }

    private var header: some View {
        HStack(spacing: scaled(ICOSShellTokens.bottomPanelTabSpacing)) {
            ForEach(BottomPanelRoute.allCases) { route in
                Button {
                    shellState.selectedBottomPanel = route
                } label: {
                    HStack(spacing: scaled(ICOSSpacing.xs)) {
                        SVGImageView(icon: route.icon)
                            .frame(
                                width: scaled(ICOSShellTokens.bottomPanelTabIconSize),
                                height: scaled(ICOSShellTokens.bottomPanelTabIconSize)
                            )

                        Text(route.title)
                            .font(.system(size: scaledFont(ICOSBottomPanelTokens.tabTitleFontSize), weight: shellState.selectedBottomPanel == route ? .semibold : .regular))
                    }
                    .foregroundStyle(shellState.selectedBottomPanel == route ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                    .padding(.horizontal, scaled(ICOSControlTokens.buttonHorizontalPaddingSM))
                    .frame(height: scaled(ICOSControlTokens.buttonHeightSM))
                    .background(
                        RoundedRectangle(cornerRadius: scaled(ICOSControlTokens.buttonCornerRadiusSM), style: .continuous)
                            .fill(shellState.selectedBottomPanel == route ? ICOSMaterials.hoverSurface : ICOSMaterials.hoverSurface.opacity(ICOSBottomPanelTokens.inactiveTabFillOpacity))
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Button {
                shellState.isBottomPanelVisible = false
                NotificationCenter.default.post(
                    name: .icosBottomPanelVisibilityDidChange,
                    object: false
                )
            } label: {
                SVGImageView(icon: .close)
                    .frame(
                        width: scaled(ICOSSidebarTokens.iconSM),
                        height: scaled(ICOSSidebarTokens.iconSM)
                    )
            }
            .buttonStyle(.icosIcon)
            .help("Close Panel")
        }
        .frame(height: scaled(ICOSShellTokens.bottomPanelHeaderHeight))
        .padding(.horizontal, scaled(ICOSShellTokens.bottomPanelHorizontalPadding))
    }

    @ViewBuilder
    private var content: some View {
        switch shellState.selectedBottomPanel {
        case .problems:
            problemList
        case .terminal:
            terminalPanel
        case .output:
            outputPanel
        case .debug:
            debugPanel
        }
    }

    private var problemList: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            panelTitle("Diagnostics", icon: .bug)

            if services.permissionService.auditLog.isEmpty {
                panelEmptyState("No diagnostics are currently reported.")
            } else {
                ForEach(services.permissionService.auditLog.suffix(8)) { event in
                    panelLine("\(event.action): \(event.allowed ? "allowed" : "blocked")")
                }
            }
        }
    }

    private var terminalPanel: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            panelTitle("Terminal", icon: .command)

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSTextInput("Command", placeholder: "Command", text: terminalCommandBinding)

                ICOSButton(
                    services.workspaceFileService.isRunningCommand ? "Stop" : "Run",
                    icon: services.workspaceFileService.isRunningCommand ? .close : .arrowUp,
                    role: .primary
                ) {
                    if services.workspaceFileService.isRunningCommand {
                        services.workspaceFileService.cancelTerminalCommand()
                    } else {
                        services.permissionService.grant(.terminalExecution)
                        services.workspaceFileService.runTerminalCommand()
                    }
                }

                ICOSButton("Clear", role: .secondary) {
                    services.workspaceFileService.clearTerminalOutput()
                }

                ICOSButton("Copy", role: .secondary) {
                    services.workspaceFileService.copyTerminalOutput()
                }
                .disabled(services.workspaceFileService.terminalOutput.isEmpty)
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                panelLine("CWD: \(services.workspaceFileService.rootURL?.path ?? "No active workspace")")
                panelLine("Status: \(services.workspaceFileService.terminalStatus.rawValue)")
            }

            ICOSScrollView {
                Text(services.workspaceFileService.terminalOutput.isEmpty ? "No terminal output yet." : services.workspaceFileService.terminalOutput)
                    .font(.system(size: scaledFont(ICOSBottomPanelTokens.terminalOutputFontSize), weight: .regular, design: .monospaced))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(minHeight: scaled(ICOSDeveloperPanelTokens.terminalOutputMinHeight))
        }
    }

    private var outputPanel: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            panelTitle("Output", icon: .log)
            panelLine(services.connectorRegistryService.statusText)
            panelLine(services.runtimeSettings.modelDiscoveryStatus)
            panelLine(services.runtimeSettings.localModelStatus)
            panelLine("Terminal: \(services.workspaceFileService.terminalStatus.rawValue)")
            if let latest = services.workspaceFileService.terminalHistory.first {
                panelLine("Last command: \(latest.command)")
                panelLine("Exit: \(latest.exitCode.map(String.init) ?? "running")")
            }
        }
    }

    private var debugPanel: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            panelTitle("Debug", icon: .configuration)
            panelLine("Provider: \(services.runtimeSettings.activeProviderTitle)")
            panelLine("Model: \(services.runtimeSettings.activeModelTitle)")
            panelLine("Workspace: \(services.workspaceFileService.rootURL?.path ?? "not mounted")")
            panelLine("Selected file: \(services.workspaceFileService.selectedURL?.path ?? "none")")
            panelLine("Agent: \(services.agentRuntimeService.selectedAgent?.name ?? "none")")
        }
    }

    private func panelTitle(_ title: String, icon: ICOSIcon) -> some View {
        HStack(spacing: scaled(ICOSSpacing.sm)) {
            SVGImageView(icon: icon)
                .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))

            Text(title)
                .font(.system(size: scaledFont(ICOSBottomPanelTokens.panelTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)
        }
    }

    private func panelLine(_ text: String) -> some View {
        Text(text)
            .font(.system(size: scaledFont(ICOSBottomPanelTokens.panelLineFontSize), weight: .regular))
            .foregroundStyle(ICOSSidebarColors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func panelEmptyState(_ text: String) -> some View {
        Text(text)
            .font(.system(size: scaledFont(ICOSBottomPanelTokens.panelLineFontSize), weight: .regular))
            .foregroundStyle(ICOSSidebarColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    private var terminalCommandBinding: Binding<String> {
        Binding(
            get: { services.workspaceFileService.terminalCommand },
            set: { services.workspaceFileService.terminalCommand = $0 }
        )
    }
}
