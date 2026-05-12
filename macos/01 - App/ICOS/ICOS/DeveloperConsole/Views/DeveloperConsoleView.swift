import AppKit
import SwiftUI

// MARK: - Developer Console View

struct DeveloperConsoleView: View {
    // MARK: - Initialization
    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }

    // MARK: - Properties
    @ObservedObject var appState: ICOSAppState
    @EnvironmentObject private var services: SystemServices
    @State private var chatInput = ""
    @State private var webSearchEnabled = false
    @State private var rightPanel: DeveloperRightPanel = .projects

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    // MARK: - Body

    var body: some View {
        DeveloperConsoleShell(
            appState: appState,
            inputText: $chatInput,
            webSearchEnabled: $webSearchEnabled,
            rightPanel: $rightPanel
        )
        .onAppear {
            RuntimeEventBus.shared.emit(type: .runtimeBoot, payload: ["surface": "developer_console"])
            developer.selectedSection = .plan
        }
    }
}

// MARK: - Unified Session View

struct UnifiedSessionView: View {
    // MARK: - Initialization

    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }

    // MARK: - Properties

    @ObservedObject var appState: ICOSAppState
    @EnvironmentObject private var services: SystemServices
    @State private var inputText = ""
    @State private var webSearchEnabled = false
    @State private var rightPanel: DeveloperRightPanel = .projects

    // MARK: - Body

    var body: some View {
        DeveloperConsoleCenterCanvas(
            appState: appState,
            inputText: $inputText,
            webSearchEnabled: $webSearchEnabled,
            rightPanel: $rightPanel
        )
        .onAppear {
            RuntimeEventBus.shared.emit(type: .runtimeBoot, payload: ["surface": "unified_session"])
        }
    }
}

// MARK: - Developer Right Panel

enum DeveloperRightPanel: String, CaseIterable, Identifiable {
    case projects = "Workspace"
    case patch = "Review"
    case sessions = "Sessions"
    case models = "Runtime"

    // MARK: - Identity
    var id: String { rawValue }

    // MARK: - Icon
    var icon: ICOSIcon {
        switch self {
        case .projects: return .workspace
        case .patch: return .review
        case .sessions: return .session
        case .models: return .model
        }
    }
}

// MARK: - Developer Console Top Bar

struct DeveloperConsoleTopBar: View {
    // MARK: - Properties

    @Binding var webSearchEnabled: Bool
    @Binding var rightPanel: DeveloperRightPanel
    @ObservedObject var appState: ICOSAppState
    @ObservedObject private var runtime = RuntimeSettingsState.shared
    @EnvironmentObject private var services: SystemServices

    // MARK: - Body

    var body: some View {
        HStack(spacing: ICOSDeveloperTopBarTokens.itemSpacing) {
            VStack(alignment: .leading, spacing: ICOSDeveloperTopBarTokens.titleSpacing) {
                Text("New Chat")
                    .font(ICOSTypography.section)

                Text(runtime.activeModelTitle)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Menu {
                Section("Runtime") {
                    ForEach(RuntimeMode.allCases) { mode in
                        Button(mode.title) {
                            runtime.mode = mode
                            runtime.save()
                        }
                    }
                }

                Divider()
                    .background(ICOSMaterials.separator)

                Button(runtime.localProviderEnabled ? "Disable Offline ICOS base" : "Enable Offline ICOS base") {
                    runtime.localProviderEnabled.toggle()
                    runtime.save()
                }

                Button(runtime.externalProviderEnabled ? "Disable LM Studio / OpenAI-compatible" : "Enable LM Studio / OpenAI-compatible") {
                    runtime.externalProviderEnabled.toggle()
                    runtime.save()
                }

            } label: {
                topBarPill(icon: .cloud, text: runtime.activeProviderTitle)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    rightPanel = .projects
                }
            } label: {
                topBarPill(icon: .workspace, text: "Workspace")
            }
            .buttonStyle(.plain)

            Button {
                rightPanel = .patch
            } label: {
                topBarPill(icon: .review, text: "Review")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, ICOSSidebarTokens.accountOuterPadding)
        .padding(.top, ICOSSidebarTokens.accountOuterPadding)
        .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)
        .onAppear {
            runtime.refreshLocalModels()
            runtime.synchronizeActiveRuntimeSummary()
        }
        .onChange(of: runtime.mode) { _, _ in
            runtime.save()
        }
        .onChange(of: runtime.localProviderEnabled) { _, _ in
            runtime.save()
        }
        .onChange(of: runtime.externalProviderEnabled) { _, _ in
            runtime.save()
        }
    }

    // MARK: - Top Bar Pill

    private func topBarPill(icon: ICOSIcon, text: String) -> some View {
        HStack(spacing: ICOSDeveloperTopBarTokens.pillSpacing) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSDeveloperTopBarTokens.pillIconSize,
                    height: ICOSDeveloperTopBarTokens.pillIconSize
                )
            Text(text)
                .font(ICOSTypography.caption.weight(.medium))
                .lineLimit(1)
        }
        .padding(.horizontal, ICOSDeveloperTopBarTokens.pillHorizontalPadding)
        .padding(.vertical, ICOSDeveloperTopBarTokens.pillVerticalPadding)
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(
                cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                style: .continuous
            )
        )
    }
}


// MARK: - Developer Review Panel

struct DeveloperPatchReviewPanel: View {
    // MARK: - Properties
    @ObservedObject var files: WorkspaceFileService
    @EnvironmentObject private var services: SystemServices

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            panelHeader(title: "Review", icon: .review)

            ICOSScrollView {
                VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                    if files.selectedURL == nil {
                        emptyPanel("Select a file or folder to inspect workspace context.", icon: .file)
                    } else {
                        selectedContextMetadata

                        if files.selectedIsDirectory {
                            emptyPanel("Folder selected. Use the file tree context menu for file and folder actions.", icon: .folder)
                        } else if !isEditableSelectedFile {
                            filePreviewSurface
                        } else if !files.isFileDirty {
                            fileEditorSurface
                            emptyPanel("No draft patch. Edit the file or ask ICOS to propose a change.", icon: .rename)
                        } else {
                            Text(files.selectedURL?.path ?? "")
                                .font(ICOSTypography.monoCaption)
                                .foregroundStyle(ICOSSidebarColors.textSecondary)
                                .textSelection(.enabled)

                            DeveloperDiffPreview(
                                original: files.filePreview,
                                updated: files.editableContent
                            )
                        }
                    }

                    if !files.lastPatchStatus.isEmpty {
                        Text(files.lastPatchStatus)
                            .font(ICOSTypography.caption)
                            .foregroundStyle(ICOSSidebarColors.textSecondary)
                    }
                }
                .padding(ICOSSpacing.md)
            }

            HStack(spacing: ICOSSpacing.sm) {
                ICOSButton("Apply Patch", icon: .success, role: .primary) {
                    files.saveSelectedFile()
                }
                .disabled(!files.isFileDirty || files.selectedURL == nil || files.selectedIsDirectory)

                ICOSButton("Rollback", role: .secondary) {
                    files.rollbackSelectedFile()
                }
                .disabled(files.selectedURL == nil || files.selectedIsDirectory)

                Spacer()
            }
            .padding(ICOSSpacing.md)
        }
    }

    private var selectedContextMetadata: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
            if let url = files.selectedURL {
                let metadata = files.metadata(for: url)
                panelHeader(title: metadata.isDirectory ? "Selected Folder" : "Selected File", icon: metadata.isDirectory ? .folder : .file)
                metadataRow("Name", metadata.name)
                metadataRow("Relative", metadata.relativePath)
                metadataRow("Path", metadata.absolutePath)
                metadataRow("Type", metadata.isDirectory ? "Folder" : (metadata.fileExtension.isEmpty ? "File" : metadata.fileExtension.uppercased()))
                if metadata.isDirectory {
                    metadataRow("Items", "\(metadata.itemCount)")
                } else {
                    metadataRow("Size", metadata.byteSize.map { ByteCountFormatter.string(fromByteCount: Int64($0), countStyle: .file) } ?? "Unknown")
                    metadataRow("Lines", metadata.lineCount.map(String.init) ?? "Binary/unsupported")
                }
                metadataRow("Modified", metadata.modifiedAt?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")
                metadataRow("Git", gitStatus(for: metadata.relativePath))
            }
        }
        .padding(ICOSSpacing.sm)
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
        )
    }

    private func metadataRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key)
                .foregroundStyle(ICOSSidebarColors.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .font(ICOSTypography.monoCaption)
    }

    private var filePreviewSurface: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
            panelHeader(title: previewTitle, icon: previewIcon)

            Group {
                if let url = files.selectedURL, isImage(url), let image = NSImage(contentsOf: url) {
                    imagePreview(image)
                } else if let url = files.selectedURL, isMarkdown(url) {
                    markdownPreview(files.filePreview)
                } else {
                    codePreview(files.filePreview)
                }
            }
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
            )
        }
    }

    private var fileEditorSurface: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
            panelHeader(title: editorTitle, icon: .file)

            TextEditor(text: Binding(
                get: { files.editableContent },
                set: { files.updateEditableContent($0) }
            ))
            .font(ICOSTypography.monoCaption)
            .foregroundStyle(ICOSSidebarColors.textPrimary)
            .scrollContentBackground(.hidden)
            .padding(ICOSSpacing.sm)
            .frame(minHeight: ICOSDeveloperPanelTokens.editorMinHeight)
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
            )

            if let url = files.selectedURL, isMarkdown(url) {
                disclosureMarkdownPreview
            }
        }
    }

    private var disclosureMarkdownPreview: some View {
        DisclosureGroup {
            markdownPreview(files.editableContent)
        } label: {
            HStack(spacing: ICOSSpacing.sm) {
                SVGImageView(icon: .review)
                    .frame(width: ICOSDeveloperPanelTokens.headerIconSize, height: ICOSDeveloperPanelTokens.headerIconSize)
                Text("Rendered Markdown")
                    .font(ICOSTypography.caption.weight(.semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
            }
        }
        .padding(ICOSSpacing.sm)
        .background(
            ICOSMaterials.panelBackground,
            in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
        )
    }

    private var previewTitle: String {
        guard let url = files.selectedURL else { return "Preview" }
        if isImage(url) { return "Image Preview" }
        if isMarkdown(url) { return "Markdown Preview" }
        return "Code Preview"
    }

    private var editorTitle: String {
        guard let url = files.selectedURL else { return "Editor" }
        if isMarkdown(url) { return "Markdown Editor" }
        return "Code Editor"
    }

    private var previewIcon: ICOSIcon {
        return .file
    }

    private var isEditableSelectedFile: Bool {
        guard let url = files.selectedURL, !files.selectedIsDirectory else { return false }
        if isImage(url) { return false }
        return files.filePreview != "Binary or unsupported file preview."
    }

    private func imagePreview(_ image: NSImage) -> some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: ICOSDeveloperPanelTokens.filePreviewMaxHeight)

            if let url = files.selectedURL {
                let metadata = files.metadata(for: url)
                metadataRow("Image", metadata.name)
                metadataRow("Size", metadata.byteSize.map { ByteCountFormatter.string(fromByteCount: Int64($0), countStyle: .file) } ?? "Unknown")
            }
        }
        .padding(ICOSSpacing.sm)
    }

    private func markdownPreview(_ markdown: String) -> some View {
        ICOSScrollView {
            Text(markdownAttributedString(markdown))
                .font(ICOSTypography.body)
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(ICOSSpacing.sm)
        }
        .frame(maxHeight: ICOSDeveloperPanelTokens.filePreviewMaxHeight)
    }

    private func codePreview(_ text: String) -> some View {
        ICOSScrollView {
            Text(text)
                .font(ICOSTypography.monoCaption)
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(ICOSSpacing.sm)
        }
        .frame(maxHeight: ICOSDeveloperPanelTokens.filePreviewMaxHeight)
    }

    private func markdownAttributedString(_ markdown: String) -> AttributedString {
        (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }

    private func isMarkdown(_ url: URL) -> Bool {
        ["md", "markdown", "mdx"].contains(url.pathExtension.lowercased())
    }

    private func isImage(_ url: URL) -> Bool {
        ["png", "jpg", "jpeg", "gif", "heic", "tiff", "webp", "svg"].contains(url.pathExtension.lowercased())
    }

    private func gitStatus(for relativePath: String) -> String {
        services.gitStatusService.changedFiles.first(where: { $0.path == relativePath })?.status ?? "Clean"
    }
}

// MARK: - Developer Diff Preview

private struct DeveloperDiffPreview: View {
    // MARK: - Properties
    let original: String
    let updated: String

    // MARK: - Rows
    private var rows: [DiffRow] {
        let old = original.components(separatedBy: .newlines)
        let new = updated.components(separatedBy: .newlines)
        let maxCount = max(old.count, new.count)

        return (0..<maxCount).flatMap { index -> [DiffRow] in
            let oldLine = index < old.count ? old[index] : nil
            let newLine = index < new.count ? new[index] : nil

            if oldLine == newLine {
                return [DiffRow(kind: .same, text: oldLine ?? "")]
            }

            var changed: [DiffRow] = []
            if let oldLine {
                changed.append(DiffRow(kind: .removed, text: oldLine))
            }
            if let newLine {
                changed.append(DiffRow(kind: .added, text: newLine))
            }
            return changed
        }
        .prefix(260)
        .map { $0 }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.diffRowSpacing) {
            ForEach(rows) { row in
                HStack(alignment: .top, spacing: ICOSDeveloperPanelTokens.diffColumnSpacing) {
                    Text(row.kind.prefix)
                        .font(ICOSTypography.monoCaption)
                        .frame(width: ICOSDeveloperPanelTokens.diffPrefixWidth)
                        .foregroundStyle(row.kind.color)

                    Text(row.text.isEmpty ? " " : row.text)
                        .font(ICOSTypography.monoCaption)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, ICOSDeveloperPanelTokens.diffHorizontalPadding)
                .padding(.vertical, ICOSDeveloperPanelTokens.diffVerticalPadding)
                .background(
                    row.kind.background,
                    in: RoundedRectangle(
                        cornerRadius: ICOSRadius.xs,
                        style: .continuous
                    )
                )
            }
        }
    }
}

// MARK: - Diff Row

private struct DiffRow: Identifiable {
    enum Kind {
        case same
        case added
        case removed

        var prefix: String {
            switch self {
            case .same: return " "
            case .added: return "+"
            case .removed: return "-"
            }
        }

        var color: Color {
            switch self {
            case .same: return ICOSSidebarColors.textSecondary
            case .added: return ICOSSidebarColors.textPrimary
            case .removed: return ICOSSidebarColors.textSecondary
            }
        }

        var background: Color {
            switch self {
            case .same: return ICOSSidebarColors.background.opacity(ICOSDeveloperPanelTokens.diffUnchangedOpacity)
            case .added: return ICOSMaterials.floatingSurface
            case .removed: return ICOSMaterials.floatingSurface
            }
        }
    }

    let id = UUID()
    let kind: Kind
    let text: String
}

// MARK: - Developer Workspace Panel

struct DeveloperProjectsPanel: View {
    // MARK: - Properties
    @EnvironmentObject private var services: SystemServices

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            panelHeader(title: "Workspace", icon: .workspace)

            ProjectManagerView(viewModel: services.projectManager)
        }
    }
}

// MARK: - Developer Sessions Panel

struct DeveloperSessionsPanel: View {
    @ObservedObject var appState: ICOSAppState

    private var sessions: [SessionSummary] {
        SessionStore().listSessions()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            panelHeader(title: "Sessions", icon: .session)

            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                ICOSButton("New Chat", icon: .add, role: .primary) {
                    appState.startNewChat()
                }

                if sessions.isEmpty {
                    emptyPanel("No saved sessions yet. Send a message to create the first persistent session.", icon: .session)
                } else {
                    ForEach(sessions) { session in
                        sessionButton(session)
                    }
                }
            }
            .padding(ICOSSpacing.md)
        }
    }

    private func sessionButton(_ session: SessionSummary) -> some View {
        Button {
            appState.loadChatSession(id: session.id)
        } label: {
            VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.sessionRowTextSpacing) {
                Text(session.title)
                    .font(ICOSTypography.caption.weight(.semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .lineLimit(ICOSDeveloperPanelTokens.sessionTitleLineLimit)

                Text("\(session.messageCount) messages · \(session.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(ICOSTypography.monoCaption)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(ICOSDeveloperPanelTokens.sessionRowPadding)
            .background(
                appState.activeSession.sessionID == session.id ? ICOSSidebarColors.rowActiveFill : ICOSMaterials.floatingSurface,
                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Developer Runtime Panel

struct DeveloperModelsPanel: View {
    @EnvironmentObject private var services: SystemServices

    var body: some View {
        DeveloperRuntimePanelContent(
            runtime: services.runtimeSettings,
            agents: services.agentRuntimeService
        )
    }
}

private struct DeveloperRuntimePanelContent: View {
    @ObservedObject var runtime: RuntimeSettingsState
    @ObservedObject var agents: AgentRuntimeService

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            panelHeader(title: "Runtime", icon: .model)

            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                inspectorRow(title: "Active Provider", detail: runtime.activeProviderTitle, icon: .configuration)
                inspectorRow(title: "Active Model", detail: runtime.activeModelTitle, icon: .model)
                inspectorRow(title: "Endpoint", detail: runtime.activeEndpointTitle, icon: .cloud)
                inspectorRow(title: "Selected Agent", detail: agents.selectedAgent?.name ?? "No agent selected", icon: .agent)

                HStack(spacing: ICOSSpacing.sm) {
                    ICOSButton("Save Runtime", icon: .success, role: .primary) {
                        runtime.save()
                    }
                    ICOSButton("Scan LM Studio", icon: .search) {
                        runtime.enableLMStudioPreset()
                        Task { await runtime.refreshExternalModels() }
                    }
                }

                if !agents.agents.isEmpty {
                    Text("Agents")
                        .font(ICOSTypography.caption.weight(.semibold))

                    ForEach(agents.agents) { agent in
                        Button {
                            agents.selectAgent(id: agent.id)
                        } label: {
                            inspectorRow(
                                title: agent.name,
                                detail: "\(agent.kind.rawValue) · \(agent.providerConnector.rawValue)",
                                icon: .agent,
                                active: agents.selectedAgent?.id == agent.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    emptyPanel("No agent profiles are registered yet.", icon: .agent)
                }

                if !runtime.localModels.isEmpty {
                    Text("Local GGUF")
                        .font(ICOSTypography.caption.weight(.semibold))
                    ForEach(runtime.localModels) { model in
                        modelButton(title: model.name, detail: model.path, active: runtime.selectedLocalModelID == model.id) {
                            runtime.activateLocalModel(id: model.id)
                        }
                    }
                }

                if !runtime.discoveredModels.isEmpty {
                    Text("OpenAI-Compatible")
                        .font(ICOSTypography.caption.weight(.semibold))
                    ForEach(runtime.discoveredModels) { model in
                        modelButton(title: model.id, detail: model.owner, active: runtime.selectedModelID == model.id) {
                            runtime.activateExternalModel(id: model.id)
                        }
                    }
                }

                Text(runtime.modelDiscoveryStatus)
                    .font(ICOSTypography.monoCaption)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
            .padding(ICOSSpacing.md)
        }
        .onAppear {
            runtime.refreshLocalModels()
            runtime.synchronizeActiveRuntimeSummary()
        }
    }

    private func modelButton(title: String, detail: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            inspectorRow(title: title, detail: detail, icon: .model, active: active)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Panel Header

// MARK: - Panel Header

private func panelHeader(title: String, icon: ICOSIcon) -> some View {
    HStack(spacing: ICOSDeveloperPanelTokens.headerSpacing) {
        SVGImageView(icon: icon)
            .frame(
                width: ICOSDeveloperPanelTokens.headerIconSize,
                height: ICOSDeveloperPanelTokens.headerIconSize
            )
        Text(title)
            .font(ICOSTypography.caption.weight(.semibold))
        Spacer()
    }
    .padding(.horizontal, ICOSSpacing.md)
    .frame(height: ICOSDeveloperPanelTokens.headerHeight)
}

// MARK: - Empty Panel

private func emptyPanel(_ text: String, icon: ICOSIcon) -> some View {
    VStack(spacing: ICOSDeveloperPanelTokens.emptyPanelSpacing) {
        SVGImageView(icon: icon)
            .frame(
                width: ICOSDeveloperPanelTokens.emptyPanelIconSize,
                height: ICOSDeveloperPanelTokens.emptyPanelIconSize
            )
        Text(text)
            .font(ICOSTypography.caption)
            .foregroundStyle(ICOSSidebarColors.textSecondary)
            .multilineTextAlignment(.center)
    }
    .frame(
        maxWidth: .infinity,
        minHeight: ICOSDeveloperPanelTokens.emptyPanelMinHeight
    )
}

private func inspectorRow(title: String, detail: String, icon: ICOSIcon, active: Bool = false) -> some View {
    HStack(spacing: ICOSSpacing.sm) {
        SVGImageView(icon: icon)
            .frame(width: ICOSDeveloperPanelTokens.headerIconSize, height: ICOSDeveloperPanelTokens.headerIconSize)

        VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
            Text(title)
                .font(ICOSTypography.caption.weight(.semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .lineLimit(1)

            Text(detail)
                .font(ICOSTypography.monoCaption)
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .lineLimit(2)
                .truncationMode(.middle)
        }

        Spacer(minLength: 0)
    }
    .padding(ICOSSpacing.sm)
    .background(
        active ? ICOSSidebarColors.rowActiveFill : ICOSMaterials.floatingSurface,
        in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
    )
}

// MARK: - Previews

#Preview("Developer Console") {
    let services = SystemServices.preview()
    return DeveloperConsoleView(appState: services.appState)
        .environmentObject(services)
        .environmentObject(services.themeEngine)
        .environmentObject(services.behaviorEngine)
        .frame(
            width: ICOSDeveloperPreviewTokens.consoleWidth,
            height: ICOSDeveloperPreviewTokens.consoleHeight
        )
}

#Preview("Patch Review Panel") {
    let services = SystemServices.preview()
    services.workspaceFileService.updateEditableContent(
        services.workspaceFileService.editableContent.replacingOccurrences(of: "Preview-safe", with: "Codex-grade preview-safe")
    )
    return DeveloperPatchReviewPanel(files: services.workspaceFileService)
        .environmentObject(services)
        .frame(
            width: ICOSDeveloperPreviewTokens.patchPanelWidth,
            height: ICOSDeveloperPreviewTokens.patchPanelHeight
        )
}
