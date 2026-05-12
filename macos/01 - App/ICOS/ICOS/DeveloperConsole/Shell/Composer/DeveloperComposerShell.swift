import SwiftUI

// MARK: - Developer Composer Shell

struct DeveloperComposerShell: View {

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState
    @Binding var inputText: String
    @Binding var webSearchEnabled: Bool
    @Binding var rightPanel: DeveloperRightPanel
    @Binding var mode: DeveloperComposerMode

    let onSend: () -> Void
    let onStop: () -> Void
    let onVoice: () -> Void
    let onAction: (DeveloperExtensionAction) -> Void

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @EnvironmentObject private var services: SystemServices

    private var runtime: RuntimeSettingsState { services.runtimeSettings }
    private var files: WorkspaceFileService { services.workspaceFileService }
    private var git: GitStatusService { services.gitStatusService }
    private var agents: AgentRuntimeService { services.agentRuntimeService }

    // MARK: - Body

    var body: some View {
        VStack(spacing: scaled(ICOSDeveloperComposerTokens.shellVerticalSpacing)) {
            DeveloperComposerInput(
                inputText: $inputText,
                onSend: onSend,
                onStop: onStop,
                onVoice: onVoice,
                onAction: onAction,
                isRunning: appState.activeSession.isResponding || files.isRunningCommand,
                isVoiceRecording: services.developerVoiceService.isRecording,
                modelSelector: AnyView(controlRow)
            )

            voiceStatusStrip
        }
        .padding(.horizontal, scaled(ICOSDeveloperComposerTokens.shellHorizontalPadding))
        .padding(.vertical, scaled(ICOSDeveloperComposerTokens.shellVerticalPadding))
        .background(
            ICOSMaterials.solidPanelBackground,
            in: RoundedRectangle(
                cornerRadius: scaled(ICOSDeveloperComposerTokens.inputCornerRadius),
                style: .continuous
            )
        )
        .frame(maxWidth: scaled(ICOSDeveloperComposerTokens.shellMaxWidth))
        .frame(maxWidth: .infinity)
        .onAppear {
            runtime.refreshLocalModels()
            if runtime.externalProviderEnabled {
                Task {
                    await runtime.refreshExternalModels()
                }
            }
            git.refresh(rootURL: files.rootURL)
        }
    }

    @ViewBuilder
    private var voiceStatusStrip: some View {
        if services.developerVoiceService.isRecording || services.developerVoiceService.statusText != "Voice transcription idle." {
            HStack(spacing: scaled(ICOSSpacing.xs)) {
                SVGImageView(icon: .audio)
                    .frame(width: scaled(ICOSDeveloperComposerTokens.statusIconSize), height: scaled(ICOSDeveloperComposerTokens.statusIconSize))

                Text(services.developerVoiceService.statusText)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .font(.system(size: scaledFont(ICOSDeveloperComposerTokens.statusFontSize), weight: .medium))
            .foregroundStyle(services.developerVoiceService.isRecording ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
        }
    }

    // MARK: - Context Stack

    private var contextStack: some View {
        VStack(spacing: scaled(ICOSSpacing.sm)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                statusChip(title: "Review", value: git.statusText, icon: .review)
                statusChip(title: "Changed", value: "\(git.changedFiles.count)", icon: .branch)
                statusChip(title: "Problems", value: "\(problemCount)", icon: .bug)
                statusChip(title: "Terminal", value: files.isRunningCommand ? "Running" : "Idle", icon: .status)
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                statusChip(title: "Workspace", value: files.rootURL?.lastPathComponent ?? "Not imported", icon: .status)
                statusChip(title: "Branch", value: git.branchName, icon: .branch)
                statusChip(title: "Patch", value: patchStatus, icon: .rename)
                statusChip(title: "Last", value: files.statusText.isEmpty ? services.developerWorkspaceService.statusText : files.statusText, icon: .log)
            }
        }
    }

    private var controlRow: some View {
        HStack(spacing: scaled(ICOSSpacing.xs)) {
            Menu {
                Button("Scan LM Studio") {
                    runtime.enableLMStudioPreset()
                    Task {
                        await runtime.refreshExternalModels()
                    }
                }

                Button("Refresh Providers") {
                    runtime.refreshLocalModels()
                    Task {
                        await runtime.refreshExternalModels()
                    }
                }

                Divider()

                ForEach(runtime.localModels) { model in
                    Button(model.name) {
                        runtime.activateLocalModel(id: model.id)
                    }
                }

                ForEach(runtime.discoveredModels) { model in
                    Button(model.id) {
                        runtime.activateExternalModel(id: model.id)
                    }
                }
            } label: {
                selectorLabel(icon: .model, title: runtime.activeModelTitle == "No active model" ? selectedModelLabel : runtime.activeModelTitle)
            }

            Spacer(minLength: 0)
        }
    }

    private var statusStrip: some View {
        HStack(spacing: scaled(ICOSSpacing.sm)) {
            SVGImageView(icon: connectionIcon)
                .frame(width: scaled(ICOSDeveloperComposerTokens.statusIconSize), height: scaled(ICOSDeveloperComposerTokens.statusIconSize))

            Text("\(runtime.activeProviderTitle) · \(selectedModelLabel)")
                .lineLimit(1)

            Spacer(minLength: 0)

            Text("Agent: \(agents.selectedAgent?.kind.rawValue ?? "none")")
                .lineLimit(1)

            Text("Indexed: \(lastRefreshLabel)")
                .lineLimit(1)
        }
        .font(.system(size: scaledFont(ICOSDeveloperComposerTokens.statusFontSize), weight: .medium))
        .foregroundStyle(ICOSColors.textSecondary)
    }

    private func statusChip(title: String, value: String, icon: ICOSIcon) -> some View {
        HStack(spacing: scaled(ICOSSpacing.xs)) {
            SVGImageView(icon: icon)
                .frame(width: scaled(ICOSDeveloperComposerTokens.statusIconSize), height: scaled(ICOSDeveloperComposerTokens.statusIconSize))

            Text(title)
                .foregroundStyle(ICOSColors.textTertiary)

            Text(value)
                .foregroundStyle(ICOSColors.textPrimary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .font(.system(size: scaledFont(ICOSDeveloperComposerTokens.statusFontSize), weight: .medium))
        .padding(.horizontal, scaled(ICOSDeveloperComposerTokens.statusChipHorizontalPadding))
        .padding(.vertical, scaled(ICOSDeveloperComposerTokens.statusChipVerticalPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func selectorLabel(icon: ICOSIcon, title: String) -> some View {
        HStack(spacing: scaled(ICOSSpacing.xs)) {
            SVGImageView(icon: icon)
                .frame(width: scaled(ICOSDeveloperComposerTokens.statusIconSize), height: scaled(ICOSDeveloperComposerTokens.statusIconSize))

            Text(title)
                .font(.system(size: scaledFont(ICOSDeveloperComposerTokens.selectorFontSize), weight: .semibold))
                .lineLimit(ICOSDeveloperComposerTokens.selectorLineLimit)
        }
        .padding(.horizontal, scaled(ICOSDeveloperComposerTokens.selectorHorizontalPadding))
        .frame(height: scaled(ICOSDeveloperComposerTokens.selectorHeight))
    }

    // MARK: - Derived State

    private var selectedModelLabel: String {
        if !runtime.selectedModelID.isEmpty { return runtime.selectedModelID }
        if !runtime.selectedLocalModelID.isEmpty { return runtime.selectedLocalModelID }
        return "No model selected"
    }

    private var patchStatus: String {
        if files.isFileDirty { return "Pending" }
        if !files.lastPatchStatus.isEmpty { return files.lastPatchStatus }
        return "Clean"
    }

    private var problemCount: Int {
        let permissionProblems = services.permissionService.auditLog.filter { !$0.allowed }.count
        let terminalProblems = files.terminalOutput.localizedCaseInsensitiveContains("error:") ? 1 : 0
        return permissionProblems + terminalProblems
    }

    private var connectionIcon: ICOSIcon {
        runtime.discoveredModels.isEmpty && runtime.externalProviderEnabled ? .warning : .online
    }

    private var lastRefreshLabel: String {
        git.lastRefreshedAt?.formatted(date: .omitted, time: .shortened) ?? "Not yet"
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
