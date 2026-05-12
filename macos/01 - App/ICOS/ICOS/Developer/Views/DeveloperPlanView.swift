import SwiftUI

// MARK: - Developer Plan View

struct DeveloperPlanView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.cardSpacing)) {
                SettingsSectionCard(title: "Execution Request", icon: .knowledge) {
                    TextEditor(
                        text: Binding(
                            get: { developer.requestText },
                            set: { developer.requestText = $0 }
                        )
                    )
                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.planRequestFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textPrimary)
                    .frame(minHeight: scaled(110))
                    .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
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

                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSButton("Create Plan", icon: .knowledge) {
                            developer.createPlan()
                        }

                        ICOSButton(
                            developer.isWorking ? "Analyzing" : "Analyze Owner Chain",
                            icon: .search
                        ) {
                            developer.analyzeRequestWithAgent()
                        }
                        .disabled(
                            developer.isWorking ||
                            developer.requestText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        )

                        ICOSButton("Search Request Locally", icon: .search, role: .ghost) {
                            developer.searchQuery = developer.requestText
                            developer.runSearch()
                            developer.selectedSection = .review
                        }
                        .disabled(developer.requestText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Spacer()

                        Text(developer.activeWorkspacePath ?? "No workspace imported")
                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular, design: .monospaced))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .lineLimit(ICOSControlTokens.rowValueLineLimit)
                    }
                }

                DeveloperVoiceInputView()

                if !developer.agentAnalysisOutput.isEmpty {
                    SettingsSectionCard(title: "Agent Analysis", icon: .search) {
                        if !developer.agentCanonicalOwner.isEmpty {
                            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapXS)) {
                                Text("Canonical owner")
                                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .semibold))
                                    .foregroundStyle(ICOSColors.textSecondary)

                                Text(developer.agentCanonicalOwner)
                                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular, design: .monospaced))
                                    .foregroundStyle(ICOSColors.textPrimary)
                                    .textSelection(.enabled)
                            }
                        }

                        ICOSScrollView {
                            Text(developer.agentAnalysisOutput)
                                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.reviewPathFontSize), weight: .regular, design: .monospaced))
                                .foregroundStyle(ICOSColors.textSecondary)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
                        }
                        .frame(
                            minHeight: scaled(ICOSDeveloperPanelTokens.agentAnalysisMinHeight),
                            maxHeight: scaled(ICOSDeveloperPanelTokens.agentAnalysisMaxHeight)
                        )
                        .background(
                            ICOSMaterials.floatingSurface,
                            in: RoundedRectangle(
                                cornerRadius: scaled(ICOSRadius.field),
                                style: .continuous
                            )
                        )
                    }
                }

                if let plan = developer.currentPlan {
                    SettingsSectionCard(title: "Local-First Plan", icon: .worktree) {
                        VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapMD)) {
                            Text(plan.normalizedIntent)
                                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.planIntentFontSize), weight: .semibold))
                                .foregroundStyle(ICOSColors.textPrimary)

                            ForEach(plan.steps) { step in
                                HStack(alignment: .top, spacing: scaled(ICOSControlTokens.gapSM)) {
                                    SVGImageView(icon: step.isComplete ? .success : .file)
                                        .frame(
                                            width: scaled(ICOSDeveloperPanelTokens.planStepIconSize),
                                            height: scaled(ICOSDeveloperPanelTokens.planStepIconSize)
                                        )
                                        .foregroundStyle(step.isComplete ? ICOSColors.online : ICOSColors.textSecondary)

                                    VStack(alignment: .leading, spacing: scaled(ICOSDeveloperPanelTokens.planStepTextSpacing)) {
                                        Text(step.title)
                                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.planStepTitleFontSize), weight: .semibold))
                                            .foregroundStyle(ICOSColors.textPrimary)

                                        Text(step.detail)
                                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                                            .foregroundStyle(ICOSColors.textSecondary)
                                    }

                                    Spacer()
                                }
                            }
                        }
                    }
                }

                AgentRuntimeControlView()

                DeveloperToolsView()
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

// MARK: - Agent Runtime Control View

struct AgentRuntimeControlView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    private var agentRuntime: AgentRuntimeService {
        services.agentRuntimeService
    }

    var body: some View {
        SettingsSectionCard(title: "Agent Runtime", icon: .integration) {
            HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                ICOSButton("Index Active Repository", icon: .repository) {
                    developer.indexActiveRepositoryForAgents(using: agentRuntime)
                }

                ICOSButton("Index Neuroartan Roots", icon: .workspace, role: .ghost) {
                    agentRuntime.indexNeuroartanSoftwareRoots()
                }

                ICOSButton("Queue Self-Development Audit", icon: .growth, role: .ghost) {
                    developer.queueSelfImprovementAgent(using: agentRuntime)
                }

                Spacer()
            }

            Text(developer.agentRuntimeStatus)
                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)

            HStack(spacing: scaled(ICOSControlTokens.gapMD)) {
                runtimeMetric("Agents", "\(agentRuntime.agents.count)")
                runtimeMetric("Tasks", "\(agentRuntime.tasks.count)")
                runtimeMetric("Repo maps", "\(agentRuntime.repositoryMaps.count)")
            }

            if let latestMap = agentRuntime.repositoryMaps.first {
                VStack(alignment: .leading, spacing: scaled(ICOSDeveloperPanelTokens.agentRuntimeMapSpacing)) {
                    Text(latestMap.rootPath)
                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.reviewPathFontSize), weight: .regular, design: .monospaced))
                        .foregroundStyle(ICOSColors.textSecondary)
                        .lineLimit(ICOSControlTokens.rowValueLineLimit)

                    Text("\(latestMap.fileCount) files · \(latestMap.swiftFileCount) Swift · \(latestMap.scriptCount) scripts · \(latestMap.designTokenCount) token files")
                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                        .foregroundStyle(ICOSColors.textTertiary)
                }
            }

            if let latestTask = agentRuntime.tasks.first {
                Text("Latest task: \(latestTask.title) · \(latestTask.state.rawValue)")
                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
    }

    private func runtimeMetric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSDeveloperPanelTokens.planStepTextSpacing)) {
            Text(label)
                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.reviewPathFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textTertiary)

            Text(value)
                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetricValueFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(cornerRadius: scaled(ICOSRadius.field), style: .continuous)
        )
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Developer Voice Input View

struct DeveloperVoiceInputView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var voice: DeveloperVoiceTranscriptionService {
        services.developerVoiceService
    }

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    var body: some View {
        SettingsSectionCard(title: "Voice Command", icon: .listen) {
            HStack(alignment: .top, spacing: scaled(ICOSControlTokens.gapMD)) {
                ICOSButton(
                    voice.isRecording ? "Stop" : "Record",
                    icon: .listen
                ) {
                    voice.toggleRecording()
                }

                ICOSButton("Use Transcript", icon: .knowledge, role: .ghost) {
                    developer.requestText = voice.transcript
                }
                .disabled(voice.transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()

                if !services.permissionService.grants.contains(.voiceTranscription) {
                    ICOSButton("Grant Voice", icon: .settings, role: .ghost) {
                        services.permissionService.grant(.voiceTranscription)
                    }
                }
            }

            Text(voice.statusText)
                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)

            if !voice.transcript.isEmpty {
                Text(voice.transcript)
                    .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.planRequestFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textPrimary)
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

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Developer Tools View

struct DeveloperToolsView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    var body: some View {
        SettingsSectionCard(title: "Tool Surface", icon: .configuration) {
            LazyVGrid(
                columns: [
                    GridItem(
                        .adaptive(minimum: scaled(220)),
                        spacing: scaled(ICOSControlTokens.gapMD)
                    )
                ],
                spacing: scaled(ICOSControlTokens.gapMD)
            ) {
                ForEach(developer.tools) { tool in
                    VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapSM)) {
                        HStack {
                            Text(tool.title)
                                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.planStepTitleFontSize), weight: .semibold))
                                .foregroundStyle(ICOSColors.textPrimary)

                            Spacer()

                            Text(tool.status.rawValue)
                                .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.integrationStatusFontSize), weight: .medium))
                                .foregroundStyle(ICOSColors.textSecondary)
                        }

                        Text(tool.summary)
                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
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
            }
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
