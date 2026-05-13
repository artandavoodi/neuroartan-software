import SwiftUI

// MARK: - Developer Runtime Canvas

struct DeveloperRuntimeCanvas: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @EnvironmentObject private var services: SystemServices
    @State private var activeMode: DeveloperRuntimeCanvasMode = .workspace

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: scaled(ICOSSpacing.lg)) {
                workspaceHeader

                workspaceGrid

                Spacer(minLength: 0)

                DeveloperRuntimeComposer()
                    .padding(.horizontal, scaled(ICOSShellTokens.shellSectionSpacing))
                    .padding(.bottom, scaled(ICOSShellTokens.shellSectionSpacing))
            }
            .padding(.horizontal, scaled(ICOSShellTokens.shellSectionSpacing))
            .padding(.vertical, scaled(ICOSShellTokens.shellSectionSpacing))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Workspace Header

    private var workspaceHeader: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            HStack(alignment: .top, spacing: scaled(ICOSSpacing.md)) {
                VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                    Text("Developer Workspace")
                        .font(.system(size: scaledFont(22), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Text("Active project, runtime tools, terminal, diagnostics, and review state.")
                        .font(.system(size: scaledFont(13), weight: .regular))
                        .foregroundStyle(ICOSColors.textSecondary)
                }

                Spacer(minLength: 0)

                DeveloperRuntimeStatusPill(title: "Build", value: "Ready")
                DeveloperRuntimeStatusPill(title: "Runtime", value: "Local")
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ForEach(DeveloperRuntimeCanvasMode.allCases) { mode in
                    Button {
                        activeMode = mode
                    } label: {
                        Text(mode.title)
                            .font(.system(size: scaledFont(12), weight: .medium))
                            .foregroundStyle(activeMode == mode ? ICOSColors.textPrimary : ICOSColors.textSecondary)
                            .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                            .padding(.vertical, scaled(ICOSSpacing.xs))
                            .background(
                                RoundedRectangle(
                                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                                    style: .continuous
                                )
                                .fill(activeMode == mode ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.rowPassiveFill)
                            )
                    }
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 0)
            }
        }
    }

    // MARK: - Workspace Grid

    private var workspaceGrid: some View {
        HStack(alignment: .top, spacing: scaled(ICOSSpacing.md)) {

            DeveloperRuntimeCanvasCard(
                title: "Active Workspace",
                rows: [
                    .init(
                        label: "Project",
                        value: services.projectManager.activeProject?.name ?? "No Active Project"
                    ),
                    .init(
                        label: "Root",
                        value: services.workspaceFileService.rootURL?.lastPathComponent ?? "Workspace Not Mounted"
                    ),
                    .init(
                        label: "Tree",
                        value: services.workspaceFileService.rootNode != nil
                            ? "Filesystem Indexed"
                            : "No Indexed Tree"
                    )
                ]
            )

            DeveloperRuntimeCanvasCard(
                title: "Runtime Tools",
                rows: [
                    .init(
                        label: "Terminal",
                        value: services.workspaceFileService.terminalStatus.rawValue
                    ),
                    .init(
                        label: "Problems",
                        value: "\(services.permissionService.auditLog.count) Events"
                    ),
                    .init(
                        label: "Output",
                        value: services.workspaceFileService.terminalOutput.isEmpty
                            ? "Idle"
                            : "Streaming"
                    )
                ]
            )

            DeveloperRuntimeCanvasCard(
                title: "Agent Context",
                rows: [
                    .init(
                        label: "Agent",
                        value: services.agentRuntimeService.selectedAgent?.name ?? "No Active Agent"
                    ),
                    .init(
                        label: "Model",
                        value: services.runtimeSettings.activeModelTitle
                    ),
                    .init(
                        label: "Mode",
                        value: activeMode.title
                    )
                ]
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

// MARK: - Developer Runtime Canvas Mode

enum DeveloperRuntimeCanvasMode: String, CaseIterable, Identifiable {
    case workspace
    case terminal
    case review
    case debug

    var id: String { rawValue }

    var title: String {
        switch self {
        case .workspace:
            "Workspace"
        case .terminal:
            "Terminal"
        case .review:
            "Review"
        case .debug:
            "Debug"
        }
    }
}

// MARK: - Developer Runtime Canvas Row

struct DeveloperRuntimeCanvasRow: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

// MARK: - Developer Runtime Canvas Card

struct DeveloperRuntimeCanvasCard: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    let title: String
    let rows: [DeveloperRuntimeCanvasRow]

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            Text(title)
                .font(.system(size: scaledFont(13), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
                ForEach(rows) { row in
                    HStack(alignment: .firstTextBaseline, spacing: scaled(ICOSSpacing.sm)) {
                        Text(row.label)
                            .font(.system(size: scaledFont(11), weight: .medium))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .frame(width: scaled(76), alignment: .leading)

                        Text(row.value)
                            .font(.system(size: scaledFont(12), weight: .regular))
                            .foregroundStyle(ICOSColors.textPrimary)
                            .lineLimit(1)

                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .padding(scaled(ICOSControlTokens.cardPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                    style: .continuous
                )
                .fill(ICOSMaterials.floatingSurface)
            }
        }
        .overlay {
            if ICOSMaterials.showsSurfaceBorders {
                RoundedRectangle(
                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                    style: .continuous
                )
                .strokeBorder(
                    ICOSMaterials.softStroke,
                    lineWidth: ICOSMaterials.softStrokeWidth
                )
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

// MARK: - Developer Runtime Status Pill

struct DeveloperRuntimeStatusPill: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    let title: String
    let value: String

    var body: some View {
        HStack(spacing: scaled(ICOSSpacing.xs)) {
            Text(title)
                .font(.system(size: scaledFont(11), weight: .medium))
                .foregroundStyle(ICOSColors.textSecondary)

            Text(value)
                .font(.system(size: scaledFont(11), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
        }
        .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
        .padding(.vertical, scaled(ICOSSpacing.xs))
        .background(
            RoundedRectangle(
                cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                style: .continuous
            )
            .fill(ICOSSidebarColors.rowPassiveFill)
        )
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}