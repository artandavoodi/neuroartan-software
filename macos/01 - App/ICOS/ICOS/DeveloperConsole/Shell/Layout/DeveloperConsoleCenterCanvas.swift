import SwiftUI

// MARK: - Developer Console Center Canvas

struct DeveloperConsoleCenterCanvas: View {

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState

    @Binding var inputText: String
    @Binding var webSearchEnabled: Bool
    @Binding var rightPanel: DeveloperRightPanel
    @State private var composerMode: DeveloperComposerMode = .ask
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            messageCanvas
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: -(scaled(ICOSDeveloperComposerTokens.inputMinHeight) / 2)) {
                    DeveloperComposerShell(
                        appState: appState,
                        inputText: $inputText,
                        webSearchEnabled: $webSearchEnabled,
                        rightPanel: $rightPanel,
                        mode: $composerMode,
                        onSend: send,
                        onStop: { appState.activeSession.cancelResponse() },
                        onVoice: handleVoice,
                        onAction: handleAction
                    )
                    .padding(.horizontal, scaled(ICOSSidebarTokens.accountOuterPadding))
                    .padding(.bottom, scaled(ICOSSidebarTokens.accountOuterPadding))
                }
        }
        .onReceive(services.developerVoiceService.$transcript) { transcript in
            guard services.developerVoiceService.isRecording else { return }
            let trimmed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            inputText = trimmed
        }
    }

    // MARK: - Message Canvas

    private var messageCanvas: some View {
        ScrollViewReader { proxy in
            ICOSScrollView {
                VStack(spacing: scaled(ICOSDeveloperCanvasTokens.messageSpacing)) {
                    ForEach(appState.activeSession.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }

                    if appState.activeSession.isResponding {
                        ThinkingIndicatorView()
                    }
                }
                .frame(maxWidth: scaled(ICOSDeveloperComposerTokens.shellMaxWidth))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, scaled(ICOSSidebarTokens.accountOuterPadding))
                .padding(.top, scaled(ICOSSidebarTokens.accountOuterPadding))
                .padding(.bottom, scaled(ICOSSidebarTokens.accountOuterPadding * 2))
            }
            .mask {
                VStack(spacing: 0) {
                    Color.black

                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.35),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: ICOSSidebarTokens.accountOuterPadding / 3)
                }
            }
            .onChange(of: appState.activeSession.messages.count) { _, _ in
                if let last = appState.activeSession.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }

    // MARK: - Send

    private func send() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return
        }

        appState.activeSession.submit(trimmed)
        let routedInput = developerRoutedInput(for: trimmed)
        inputText = ""

        Task {
            await appState.orchestrator.process(input: routedInput, appState: appState)
        }
    }

    private func developerRoutedInput(for userInput: String) -> String {
        let files = services.workspaceFileService
        let runtime = services.runtimeSettings
        let agent = services.agentRuntimeService.selectedAgent
        let project = services.projectManager.activeProject

        return files.runtimeContextSnapshot(
            userInput: userInput,
            project: project,
            agent: agent,
            runtime: runtime,
            mode: composerMode,
            webSearchEnabled: webSearchEnabled
        )
    }

    private func handleVoice() {
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

    private func handleAction(_ action: DeveloperExtensionAction) {
        switch action {
        case .attachFile:
            services.workspaceFileService.attachFileUsingPanel()
        case .activeFile:
            services.workspaceFileService.addSelectedToActiveFiles()
        case .terminal:
            services.workspaceFileService.terminalCommand = services.workspaceFileService.terminalCommand.isEmpty ? "pwd" : services.workspaceFileService.terminalCommand
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
            handleVoice()
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }
}
