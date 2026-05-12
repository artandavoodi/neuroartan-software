import SwiftUI

// MARK: - Developer Runtime Composer

struct DeveloperRuntimeComposer: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @EnvironmentObject private var developerWorkspaceService: DeveloperWorkspaceService
    @State private var promptText: String = ""
    @State private var selectedMode: DeveloperRuntimeComposerMode = .ask

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapSM)) {
            statusStrip

            TextEditor(text: $promptText)
                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerInputFontSize), weight: .regular))
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, minHeight: scaled(ICOSRuntimeDeveloperTokens.composerInputMinHeight), alignment: .topLeading)
                .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                .padding(.vertical, scaled(ICOSControlTokens.fieldVerticalPadding))
                .background(
                    RoundedRectangle(
                        cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                        style: .continuous
                    )
                    .fill(ICOSSidebarColors.rowPassiveFill)
                )
                .overlay(alignment: .topLeading) {
                    if promptText.isEmpty {
                        Text("Message ICOS")
                            .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerInputFontSize), weight: .regular))
                            .foregroundStyle(ICOSSidebarColors.textSecondary)
                            .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding + ICOSSpacing.xs))
                            .padding(.vertical, scaled(ICOSControlTokens.fieldVerticalPadding + ICOSSpacing.xs))
                            .allowsHitTesting(false)
                    }
                }

            HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                ForEach(DeveloperRuntimeComposerMode.allCases) { mode in
                    Button {
                        selectedMode = mode
                    } label: {
                        HStack(spacing: scaled(ICOSSpacing.xs)) {
                            SVGImageView(icon: mode.icon)
                                .frame(
                                    width: scaled(ICOSSidebarTokens.iconSM),
                                    height: scaled(ICOSSidebarTokens.iconSM)
                                )

                            Text(mode.title)
                                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerPillFontSize), weight: .medium))
                                .foregroundStyle(selectedMode == mode ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                        }
                        .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                        .padding(.vertical, scaled(ICOSSpacing.xs))
                        .background(
                            RoundedRectangle(
                                cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                                style: .continuous
                            )
                            .fill(selectedMode == mode ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.rowPassiveFill)
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 0)

                Text(developerWorkspaceService.statusText)
                    .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerStatusFontSize), weight: .regular))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .lineLimit(ICOSControlTokens.rowValueLineLimit)

                DeveloperRuntimeIconButton(icon: .arrowUp, label: "Send") {
                    submitPrompt()
                }
                .disabled(promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || developerWorkspaceService.isWorking)
                .opacity(promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || developerWorkspaceService.isWorking ? ICOSRuntimeDeveloperTokens.disabledSendOpacity : ICOSRuntimeDeveloperTokens.enabledSendOpacity)
            }
        }
        .padding(scaled(ICOSControlTokens.cardPadding))
        .frame(maxWidth: scaled(ICOSRuntimeDeveloperTokens.composerMaxWidth))
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

    // MARK: - Status Strip

    private var statusStrip: some View {
        HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
            DeveloperRuntimeComposerStatus(title: "Mode", value: selectedMode.title)
            DeveloperRuntimeComposerStatus(title: "Context", value: developerWorkspaceService.activeWorkspacePath ?? "No Workspace")
            DeveloperRuntimeComposerStatus(title: "Runtime", value: developerWorkspaceService.isWorking ? "Working" : "Ready")

            Spacer(minLength: 0)
        }
    }

    // MARK: - Actions

    private func submitPrompt() {
        let request = promptText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !request.isEmpty else { return }

        switch selectedMode {
        case .ask, .edit:
            developerWorkspaceService.createPlan()
        case .review:
            developerWorkspaceService.runGitStatus()
        case .terminal:
            developerWorkspaceService.runSearch()
        case .debug:
            developerWorkspaceService.runXcodeBuild()
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

// MARK: - Developer Runtime Composer Mode

enum DeveloperRuntimeComposerMode: String, CaseIterable, Identifiable {
    case ask
    case edit
    case review
    case terminal
    case debug

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ask:
            "Ask"
        case .edit:
            "Edit"
        case .review:
            "Review"
        case .terminal:
            "Terminal"
        case .debug:
            "Debug"
        }
    }

    var icon: ICOSIcon {
        switch self {
        case .ask:
            .ask
        case .edit:
            .rename
        case .review:
            .review
        case .terminal:
            .terminal
        case .debug:
            .bug
        }
    }
}

// MARK: - Developer Runtime Composer Status

struct DeveloperRuntimeComposerStatus: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    let title: String
    let value: String

    var body: some View {
        HStack(spacing: scaled(ICOSSpacing.xs)) {
            Text(title)
                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerStatusFontSize), weight: .medium))
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Text(value)
                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerStatusFontSize), weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)
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