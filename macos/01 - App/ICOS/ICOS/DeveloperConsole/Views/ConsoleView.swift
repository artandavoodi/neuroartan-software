import SwiftUI

// MARK: - Chat Console View (Single Input Owner)

struct ConsoleView: View {
    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }
    
    @ObservedObject var appState: ICOSAppState
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared
    @EnvironmentObject private var services: SystemServices
    @State private var inputText: String = ""
    @State private var webSearchEnabled = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: ICOSSpacing.md) {
                VStack(alignment: .leading, spacing: ICOSConsoleViewTokens.headerTextSpacing) {
                    Text(runtimeSettings.activeModelTitle)
                        .font(ICOSTypography.caption.weight(.semibold))
                        .foregroundStyle(ICOSSidebarColors.textPrimary)
                        .lineLimit(1)

                    Text("\(runtimeSettings.mode.title) / \(runtimeSettings.activeProviderTitle)")
                        .font(ICOSTypography.caption)
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                ICOSButton("New Session", icon: .add, role: .secondary) {
                    appState.startNewChat()
                }
                .disabled(appState.activeSession.isResponding)
            }
            .padding(.horizontal, ICOSSidebarTokens.accountOuterPadding)
            .padding(.top, ICOSSidebarTokens.accountOuterPadding)
            .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)

            ScrollViewReader { proxy in
                ICOSScrollView {
                    VStack(spacing: ICOSSpacing.md) {
                        if appState.activeSession.messages.isEmpty {
                            ICOSConsoleWelcomeView()
                                .padding(.top, ICOSSidebarTokens.accountOuterPadding)
                        }

                        ForEach(appState.activeSession.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        if shouldShowThinkingIndicator() {
                            ThinkingIndicatorView()
                        }
                    }
                    .padding(.horizontal, ICOSSidebarTokens.accountOuterPadding)
                    .padding(.vertical, ICOSSidebarTokens.accountOuterPadding)
                }
                .onChange(of: appState.activeSession.messages.count) { _, _ in
                    if let last = appState.activeSession.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            VStack(spacing: ICOSSpacing.sm) {
                chatExtensionStrip

                InputBarView(
                    inputText: $inputText,
                    onSend: send,
                    onAttach: { services.workspaceFileService.attachFileUsingPanel() },
                    onMic: {
                        handleVoiceInput()
                    },
                    isMicActive: services.developerVoiceService.isRecording
                )
            }
            .padding(.horizontal, ICOSSidebarTokens.accountOuterPadding)
            .padding(.bottom, ICOSSidebarTokens.accountOuterPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(services.developerVoiceService.$transcript) { transcript in
            guard services.developerVoiceService.isRecording else { return }
            let trimmed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            inputText = trimmed
        }
    }

    private var chatExtensionStrip: some View {
        ICOSScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ICOSSpacing.sm) {
                chatTool(.attachFile) {
                    services.workspaceFileService.attachFileUsingPanel()
                }

                chatTool(.activeFile) {
                    services.workspaceFileService.addSelectedToActiveFiles()
                    if inputText.isEmpty {
                        inputText = "Review the attached active file."
                    }
                }

                chatTool(.visualStudioCode) {
                    services.workspaceFileService.openSelectedInVSCode()
                }

                chatTool(.syncVSCode) {
                    services.workspaceFileService.syncActiveFileFromVSCode()
                }

                chatTool(.xcode) {
                    services.workspaceFileService.openRootInXcode()
                }

                chatTool(.terminal) {
                    services.permissionService.grant(.terminalExecution)
                    services.workspaceFileService.terminalCommand = services.workspaceFileService.terminalCommand.isEmpty ? "pwd" : services.workspaceFileService.terminalCommand
                    services.workspaceFileService.runTerminalCommand()
                }

                ICOSButton("Web Search", icon: .browserUse, role: webSearchEnabled ? .primary : .secondary) {
                    webSearchEnabled.toggle()
                }

                if services.developerVoiceService.isRecording {
                    Text("Listening...")
                        .font(ICOSTypography.caption)
                        .foregroundStyle(ICOSColors.destructive)
                } else if !services.developerVoiceService.transcript.isEmpty {
                    ICOSButton("Use transcript", icon: .knowledge, role: .secondary) {
                        inputText = services.developerVoiceService.transcript
                    }
                }
            }
            .padding(.horizontal, ICOSSpacing.xs)
            .padding(.vertical, ICOSSpacing.xs)
        }
        .background(ICOSSidebarColors.background.opacity(0))
    }

    private func chatTool(_ action: DeveloperExtensionAction, handler: @escaping () -> Void) -> some View {
        ICOSButton(action.rawValue, icon: icon(for: action), role: .secondary, action: handler)
            .help(action.rawValue)
    }

    private func icon(for action: DeveloperExtensionAction) -> ICOSIcon {
        switch action {
        case .attachFile:
            return .add
        case .activeFile:
            return .file
        case .visualStudioCode:
            return .fileManager
        case .syncVSCode:
            return .sync
        case .xcode:
            return .workspace
        case .terminal:
            return .terminal
        case .textEdit:
            return .file
        case .webSearch:
            return .browserUse
        case .voice:
            return .voice
        }
    }

    // MARK: - Send
    
    private func send() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !appState.activeSession.isResponding else { return }
        
        appState.activeSession.submit(trimmed)
        
        inputText = ""
        
        let payload = sessionRoutedInput(for: trimmed)

        Task {
            await appState.orchestrator.process(input: payload, appState: appState)
        }
    }

    private func sessionRoutedInput(for userInput: String) -> String {
        services.workspaceFileService.runtimeContextSnapshot(
            userInput: userInput,
            project: services.projectManager.activeProject,
            agent: services.agentRuntimeService.selectedAgent,
            runtime: runtimeSettings,
            mode: .ask,
            webSearchEnabled: webSearchEnabled
        )
    }

    private func handleVoiceInput() {
        let voice = services.developerVoiceService
        services.permissionService.grant(.voiceTranscription)

        if voice.isRecording {
            voice.stopRecording()
            let transcript = voice.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !transcript.isEmpty else { return }
            inputText = transcript
            send()
        } else {
            voice.startRecording()
        }
    }
    
    private func shouldShowThinkingIndicator() -> Bool {
        appState.activeSession.isResponding
    }

    private func handleAction(_ action: DeveloperExtensionAction) {
        switch action {
        case .attachFile:
            services.workspaceFileService.attachFileUsingPanel()
        case .activeFile:
            services.workspaceFileService.addSelectedToActiveFiles()
            if inputText.isEmpty {
                inputText = "Review the attached active file."
            }
        case .terminal:
            services.permissionService.grant(.terminalExecution)
            services.workspaceFileService.terminalCommand = services.workspaceFileService.terminalCommand.isEmpty ? "pwd" : services.workspaceFileService.terminalCommand
            services.workspaceFileService.runTerminalCommand()
        case .visualStudioCode:
            services.workspaceFileService.openSelectedInVSCode()
        case .syncVSCode:
            services.workspaceFileService.syncActiveFileFromVSCode()
            services.gitStatusService.refresh(rootURL: services.workspaceFileService.rootURL)
        case .xcode:
            services.workspaceFileService.openRootInXcode()
        case .textEdit:
            services.workspaceFileService.openSelectedInTextEdit()
        case .webSearch:
            webSearchEnabled.toggle()
        case .voice:
            handleVoiceInput()
        }
    }
}

private struct ICOSConsoleWelcomeView: View {
    var body: some View {
        VStack(spacing: ICOSSpacing.md) {
            ICOSBrandLockup(
                title: "ICOS",
                subtitle: "Neuroartan Cognitive Runtime",
                markSize: ICOSConsoleViewTokens.welcomeMarkSize,
                orientation: .vertical
            )

            Text("What can I help build?")
                .font(ICOSTypography.displaySection)
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Text("Develop, inspect, route models, and operate local workspaces from one sovereign runtime.")
                .font(ICOSTypography.displayBody)
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: ICOSDeveloperComposerTokens.shellMaxWidth)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, ICOSSpacing.xl)
    }
}
