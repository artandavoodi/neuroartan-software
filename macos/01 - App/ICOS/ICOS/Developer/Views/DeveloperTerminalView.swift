import SwiftUI

// MARK: - Developer Terminal View

struct DeveloperTerminalView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var fileService: WorkspaceFileService {
        services.workspaceFileService
    }

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.cardSpacing)) {
                SettingsSectionCard(title: "Workspace Terminal", icon: .console) {
                    Text(fileService.rootURL?.path ?? "Import a workspace in Files before running commands.")
                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular, design: .monospaced))
                        .foregroundStyle(ICOSColors.textSecondary)
                        .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)

                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSTextInput(
                            "Command",
                            placeholder: "Run command in imported workspace",
                            text: Binding(
                                get: { fileService.terminalCommand },
                                set: { fileService.terminalCommand = $0 }
                            )
                        )
                        .onSubmit { fileService.runTerminalCommand() }

                        ICOSButton(
                            fileService.isRunningCommand ? "Running" : "Run",
                            icon: .console
                        ) {
                            fileService.runTerminalCommand()
                        }
                        .disabled(fileService.rootURL == nil || fileService.isRunningCommand)
                    }

                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        if !services.permissionService.grants.contains(.terminalExecution) {
                            ICOSButton("Grant Terminal", icon: .settings, role: .ghost) {
                                services.permissionService.grant(.terminalExecution)
                            }
                        }

                        ICOSButton("Open Directory", icon: .workspace, role: .ghost) {
                            fileService.openRootInTerminal()
                        }
                        .disabled(fileService.rootURL == nil)

                        Spacer()
                    }

                    if !fileService.terminalOutput.isEmpty {
                        Text(fileService.terminalOutput)
                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMonoFontSize), weight: .regular, design: .monospaced))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .textSelection(.enabled)
                            .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                ICOSMaterials.floatingSurface,
                                in: RoundedRectangle(
                                    cornerRadius: scaled(ICOSRadius.field),
                                    style: .continuous
                                )
                            )
                    }
                }
            }
            .padding(scaled(18))
        }
        .background(ICOSMaterials.workspaceBackground)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
