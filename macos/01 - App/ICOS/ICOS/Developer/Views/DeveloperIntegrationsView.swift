import SwiftUI

// MARK: - Developer Integrations View

struct DeveloperIntegrationsView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.cardSpacing)) {
                SettingsSectionCard(title: "Repository Connectors", icon: .key) {
                    IntegrationRow(
                        title: "GitHub",
                        detail: "Repository authorization, branch state, pull requests, and review metadata.",
                        status: "Connector setup required"
                    )

                    IntegrationRow(
                        title: "Visual Studio Code",
                        detail: "Open selected files or the imported workspace in VS Code.",
                        status: "Local open command available"
                    )

                    IntegrationRow(
                        title: "Continue Bridge",
                        detail: "Local-first owner-chain, verified replacement, and workflow memory tools.",
                        status: "MCP bridge running externally"
                    )
                }

                SettingsSectionCard(title: "Permission Ledger", icon: .inspector) {
                    ForEach(services.permissionService.auditLog) { event in
                        HStack(alignment: .top, spacing: scaled(ICOSControlTokens.gapSM)) {
                            SVGImageView(icon: event.allowed ? .success : .error)
                                .frame(
                                    width: scaled(ICOSDeveloperPanelTokens.integrationLedgerIconSize),
                                    height: scaled(ICOSDeveloperPanelTokens.integrationLedgerIconSize)
                                )
                                .foregroundStyle(event.allowed ? ICOSColors.online : ICOSColors.destructive)

                            VStack(alignment: .leading, spacing: scaled(ICOSDeveloperPanelTokens.integrationLedgerTextSpacing)) {
                                Text(event.action)
                                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationLedgerActionFontSize), weight: .semibold))
                                    .foregroundStyle(ICOSColors.textPrimary)

                                Text(event.targetPath.isEmpty ? event.reason : "\(event.targetPath) - \(event.reason)")
                                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationLedgerReasonFontSize), weight: .regular))
                                    .foregroundStyle(ICOSColors.textSecondary)
                                    .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
                            }

                            Spacer()
                        }
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

// MARK: - Integration Row

private struct IntegrationRow: View {
    let title: String
    let detail: String
    let status: String

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapXS)) {
            HStack {
                Text(title)
                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)

                Spacer()

                Text(status)
                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationStatusFontSize), weight: .medium))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            Text(detail)
                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationDetailFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
        }
        .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(
                cornerRadius: scaled(ICOSRadius.field),
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: scaled(ICOSRadius.field),
                style: .continuous
            )
            .strokeBorder(
                ICOSMaterials.softStroke,
                lineWidth: ICOSMaterials.softStrokeWidth
            )
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
