import SwiftUI

// MARK: - Developer Build Deploy View

struct DeveloperBuildDeployView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.cardSpacing)) {
                SettingsSectionCard(title: "Build Execution", icon: .configuration) {
                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSButton("Run Xcode Build", icon: .configuration) {
                            developer.runXcodeBuild()
                        }
                        .disabled(developer.isWorking)

                        if !services.permissionService.grants.contains(.buildExecution) {
                            ICOSButton("Grant Build", icon: .settings, role: .ghost) {
                                services.permissionService.grant(.buildExecution)
                            }
                        }

                        Spacer()
                    }

                    Text("Builds are scoped to the imported workspace and require explicit permission.")
                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                        .foregroundStyle(ICOSColors.textSecondary)

                    if !developer.buildOutput.isEmpty {
                        Text(developer.buildOutput)
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

                SettingsSectionCard(title: "Deployment", icon: .cloud) {
                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSButton("Prepare Deployment", icon: .cloud) {
                            developer.prepareDeployment()
                        }

                        if !services.permissionService.grants.contains(.deploymentExecution) {
                            ICOSButton("Grant Deployment", icon: .settings, role: .ghost) {
                                services.permissionService.grant(.deploymentExecution)
                            }
                        }

                        Spacer()
                    }

                    Text("Deployment adapters are intentionally gated until a project target and command policy are configured.")
                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                        .foregroundStyle(ICOSColors.textSecondary)

                    if !developer.deploymentOutput.isEmpty {
                        Text(developer.deploymentOutput)
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
            .padding(scaled(ICOSDeveloperPanelTokens.reviewPanelPadding))
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
