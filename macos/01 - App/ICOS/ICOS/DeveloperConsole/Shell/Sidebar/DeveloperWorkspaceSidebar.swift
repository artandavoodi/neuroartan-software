import SwiftUI

// MARK: - Developer Workspace Sidebar

struct DeveloperWorkspaceSidebar: View {

    @ObservedObject var appState: ICOSAppState
    @ObservedObject var projects: ProjectManagerViewModel
    @ObservedObject var files: WorkspaceFileService
    @Binding var rightPanel: DeveloperRightPanel
    @Binding var isCollapsed: Bool
    @EnvironmentObject private var services: SystemServices

    private var developer: DeveloperWorkspaceService { services.developerWorkspaceService }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            sidebarHeader

            if !isCollapsed {
                searchSection
                if developer.isSearchActive {
                    searchResultsSection
                } else {
                    sidebarDivider
                    navigationSection
                    workspaceSection
                    renameSection
                }
            } else {
                collapsedNavigation
            }

            Spacer(minLength: 0)

            if !isCollapsed {
                sidebarFooter
            }
        }
        .padding(.vertical, ICOSSidebarTokens.accountOuterPadding)
        .onAppear {
            services.synchronizeActiveProjectWorkspace()
        }
        .onChange(of: projects.activeProjectID) { _, _ in
            services.synchronizeActiveProjectWorkspace()
        }
        .alert("Move to Trash?", isPresented: pendingDeleteBinding) {
            Button("Cancel", role: .cancel) {
                files.cancelPendingDelete()
            }
            Button("Move to Trash", role: .destructive) {
                files.confirmPendingDelete()
            }
        } message: {
            Text(files.pendingDeleteURL?.lastPathComponent ?? "Selected item")
        }
    }

    // MARK: - Header

    private var sidebarHeader: some View {
        HStack(spacing: ICOSDeveloperSidebarTokens.headerSpacing) {
            Button {
                isCollapsed.toggle()
            } label: {
                SVGImageView(icon: isCollapsed ? .panelLeftDeactivated : .panelLeftActivated)
                    .frame(width: ICOSDeveloperSidebarTokens.headerButtonIconSize, height: ICOSDeveloperSidebarTokens.headerButtonIconSize)
                    .frame(width: ICOSDeveloperSidebarTokens.headerButtonSize, height: ICOSDeveloperSidebarTokens.headerButtonSize)
                    .background(
                        ICOSMaterials.floatingSurface,
                        in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                    )
            }
            .buttonStyle(.plain)

            if !isCollapsed {
                Spacer()
            }
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)
    }

    // MARK: - Search

    private var searchSection: some View {
        HStack(spacing: ICOSDeveloperSidebarTokens.searchSpacing) {
            SVGImageView(icon: .search)
                .frame(width: ICOSDeveloperSidebarTokens.searchIconSize, height: ICOSDeveloperSidebarTokens.searchIconSize)
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            ICOSTextInput(
                "",
                placeholder: "Search",
                text: Binding(
                    get: { developer.searchQuery },
                    set: { value in
                        developer.searchQuery = value
                        developer.bindSearchSources(projectManager: projects, appState: appState)
                        developer.runSearch()
                    }
                ),
                showBorder: false,
                compact: true
            )
            .onSubmit {
                developer.bindSearchSources(projectManager: projects, appState: appState)
                developer.runSearch()
            }
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.searchInnerHorizontalPadding)
        .padding(.vertical, ICOSDeveloperSidebarTokens.searchInnerVerticalPadding)
        .background(
            ICOSMaterials.workspaceBackground,
            in: RoundedRectangle(cornerRadius: ICOSDeveloperSidebarTokens.searchCornerRadius, style: .continuous)
        )
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.bottom, ICOSSidebarTokens.sectionGroupSpacing)
    }

    private var searchResultsSection: some View {
        Group {
            if !developer.searchResults.isEmpty {
                sidebarDivider

                VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.navigationSpacing) {
                    sectionLabel("SEARCH RESULTS")

                    ForEach(developer.searchResults.prefix(8)) { result in
                        Button {
                            openSearchResult(result)
                        } label: {
                            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                                Text(searchResultTitle(result))
                                    .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: .semibold))
                                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                                    .lineLimit(1)

                                Text(searchResultSubtitle(result))
                                    .font(.system(size: ICOSDeveloperSidebarTokens.rowSubtitleFontSize, weight: .regular, design: .monospaced))
                                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
                            .padding(.vertical, ICOSDeveloperSidebarTokens.rowVerticalPadding)
                            .background(
                                ICOSMaterials.floatingSurface,
                                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
                .padding(.top, ICOSSidebarTokens.sectionGroupSpacing)
            } else if developer.isSearchActive {
                sidebarDivider

                VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.navigationSpacing) {
                    sectionLabel("SEARCH RESULTS")

                    Text(developer.statusText)
                        .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: .regular))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
                        .padding(.vertical, ICOSDeveloperSidebarTokens.rowVerticalPadding)
                }
                .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
                .padding(.top, ICOSSidebarTokens.sectionGroupSpacing)
            }
        }
    }

    private var renameSection: some View {
        Group {
            if files.isRenaming {
                VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                    sectionLabel("RENAME")
                    ICOSTextInput(
                        "Name",
                        placeholder: "Name",
                        text: Binding(
                            get: { files.renameText },
                            set: { files.renameText = $0 }
                        )
                    )

                    HStack(spacing: ICOSSpacing.sm) {
                        ICOSButton("Save", icon: .success, role: .primary) {
                            files.commitRename()
                        }
                        ICOSButton("Cancel", icon: .close, role: .ghost) {
                            files.cancelRename()
                        }
                    }
                }
                .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
                .padding(.top, ICOSSidebarTokens.sectionGroupSpacing)
            }
        }
    }

    // MARK: - Navigation

    private var navigationSection: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.navigationSpacing) {
            navigationButton(title: "New Chat", icon: .add, active: appState.activeSession.messages.isEmpty) {
                appState.startNewChat()
            }
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.top, ICOSDeveloperSidebarTokens.navigationTopPadding)
    }

    private var collapsedNavigation: some View {
        VStack(spacing: ICOSDeveloperSidebarTokens.collapsedRailSpacing) {
            collapsedButton(icon: .add) { appState.startNewChat() }
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
    }

    private func collapsedButton(icon: ICOSIcon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(width: ICOSDeveloperSidebarTokens.rowIconSize, height: ICOSDeveloperSidebarTokens.rowIconSize)
                .frame(width: ICOSDeveloperSidebarTokens.headerButtonSize, height: ICOSDeveloperSidebarTokens.headerButtonSize)
                .background(
                    ICOSMaterials.floatingSurface,
                    in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Workspace Tree

    private var workspaceSection: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.navigationSpacing) {
            sectionLabel("WORKSPACE")

            if let rootNode = filteredRootNode {
                ICOSScrollView {
                    DeveloperFileNodeRow(
                        node: rootNode,
                        selectedURL: files.selectedURL,
                        onSelect: selectNode,
                        onAction: handleNodeAction
                    )
                }
                .frame(maxHeight: .infinity)
            } else {
                Text("Import a project directory to show the file tree.")
                    .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: .regular))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
                    .padding(.vertical, ICOSDeveloperSidebarTokens.rowVerticalPadding)
            }
        }
        .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        .padding(.top, ICOSSidebarTokens.sectionGroupSpacing)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Footer

    private var sidebarFooter: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.footerSpacing) {
            sidebarDivider

            workspaceMenu
                .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
        }
    }

    private var workspaceMenu: some View {
        Menu {
            if projects.projects.isEmpty {
                Button("No workspaces yet") {}
                    .disabled(true)
            } else {
                ForEach(projects.sortedProjects) { project in
                    Button {
                        activateWorkspace(project)
                    } label: {
                        Text(project.name)
                    }
                    .disabled(project.path == nil)
                }
            }

            Divider()
                .background(ICOSMaterials.separator)

            Button("Manage Workspaces") {
                rightPanel = .projects
            }
        } label: {
            HStack(spacing: ICOSDeveloperSidebarTokens.rowSpacing) {
                SVGImageView(icon: .folder)
                    .frame(width: ICOSDeveloperSidebarTokens.rowIconSize, height: ICOSDeveloperSidebarTokens.rowIconSize)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)

                VStack(alignment: .leading, spacing: ICOSDeveloperSidebarTokens.workspaceMenuTextSpacing) {
                    Text(activeWorkspaceTitle)
                        .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: .semibold))
                        .foregroundStyle(ICOSSidebarColors.textPrimary)
                        .lineLimit(1)

                    Text("Workspace")
                        .font(.system(size: ICOSDeveloperSidebarTokens.rowSubtitleFontSize, weight: .regular))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                SVGImageView(icon: .chevronRight)
                    .frame(width: ICOSSidebarTokens.iconSM, height: ICOSSidebarTokens.iconSM)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
            .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
            .padding(.vertical, ICOSDeveloperSidebarTokens.rowVerticalPadding)
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
            )
        }
        .menuStyle(.borderlessButton)
        .buttonStyle(.plain)
    }

    private var activeWorkspaceTitle: String {
        projects.activeProject?.name ?? files.rootURL?.lastPathComponent ?? "No workspace"
    }

    private func activateWorkspace(_ project: ICOSProject) {
        guard project.path?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            rightPanel = .projects
            return
        }

        services.activateProject(project)
    }

    private func openSearchResult(_ result: DeveloperSearchResult) {
        switch result.kind {
        case .session:
            if let sessionID = result.sessionID {
                appState.loadChatSession(id: sessionID)
            }
            rightPanel = .sessions
            return

        case .project:
            if let projectID = result.projectID,
               let project = developer.searchResultProject(id: projectID) {
                services.activateProject(project)
            }
            rightPanel = .projects
            return

        case .file, .folder, .content:
            let url = URL(fileURLWithPath: result.path)
            files.select(url)
            rightPanel = .patch
        }
    }

    private func searchResultTitle(_ result: DeveloperSearchResult) -> String {
        switch result.kind {
        case .project:
            return result.preview.replacingOccurrences(of: "Project: ", with: "")
        case .session:
            return "Session"
        case .file, .folder, .content:
            return URL(fileURLWithPath: result.path).lastPathComponent
        }
    }

    private func searchResultSubtitle(_ result: DeveloperSearchResult) -> String {
        let prefix: String
        switch result.kind {
        case .file: prefix = "File"
        case .folder: prefix = "Folder"
        case .content: prefix = result.line.map { "Line \($0)" } ?? "Content"
        case .project: prefix = "Project"
        case .session: prefix = "Session"
        }
        return "\(prefix): \(result.preview)"
    }

    private var sidebarDivider: some View {
        Rectangle()
            .fill(ICOSMaterials.separator)
            .frame(height: ICOSDeveloperSidebarTokens.dividerHeight)
            .padding(.horizontal, ICOSDeveloperSidebarTokens.navigationHorizontalPadding)
    }

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: ICOSDeveloperSidebarTokens.sectionLabelFontSize, weight: .semibold))
            .foregroundStyle(ICOSSidebarColors.textSecondary.opacity(ICOSDeveloperSidebarTokens.sectionLabelOpacity))
            .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
            .padding(.top, ICOSDeveloperSidebarTokens.sectionLabelTopPadding)
            .padding(.bottom, ICOSDeveloperSidebarTokens.sectionLabelBottomPadding)
    }

    private func navigationButton(title: String, icon: ICOSIcon, active: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: ICOSDeveloperSidebarTokens.rowSpacing) {
                SVGImageView(icon: icon)
                    .frame(width: ICOSDeveloperSidebarTokens.rowIconSize, height: ICOSDeveloperSidebarTokens.rowIconSize)

                Text(title)
                    .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: active ? .semibold : .regular))
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .foregroundStyle(active ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
            .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
            .padding(.vertical, ICOSDeveloperSidebarTokens.rowVerticalPadding)
            .background(
                active ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.background.opacity(ICOSDeveloperSidebarTokens.inactiveRowOpacity),
                in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }

    private var pendingDeleteBinding: Binding<Bool> {
        Binding(
            get: { files.pendingDeleteURL != nil },
            set: { isPresented in
                if !isPresented { files.cancelPendingDelete() }
            }
        )
    }

    private var filteredRootNode: FileNode? {
        guard let rootNode = files.rootNode else { return nil }
        let query = developer.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return rootNode }
        return filter(node: rootNode, query: query.lowercased())
    }

    private func filter(node: FileNode, query: String) -> FileNode? {
        let relative = files.relativePath(for: node.url).lowercased()
        let matches = node.name.lowercased().contains(query) || relative.contains(query)
        let children = node.children.compactMap { filter(node: $0, query: query) }
        if matches || !children.isEmpty {
            return FileNode(id: node.id, url: node.url, name: node.name, isDirectory: node.isDirectory, children: children)
        }
        return nil
    }

    private func selectNode(_ url: URL) {
        files.select(url)
        rightPanel = .patch
    }

    private func handleNodeAction(_ action: DeveloperFileNodeAction, _ url: URL) {
        files.select(url)
        switch action {
        case .newFile:
            files.createFile()
        case .newFolder:
            files.createFolder()
        case .rename:
            files.prepareRename()
        case .delete:
            files.requestDelete(url)
        case .reveal:
            files.revealInFinder(url)
        case .openVSCode:
            files.openSelectedInVSCode()
        case .copyRelativePath:
            files.copyRelativePath(url)
        case .refresh:
            files.reload()
            services.gitStatusService.refresh(rootURL: files.rootURL)
        }
    }
}

// MARK: - Developer File Node Row

private enum DeveloperFileNodeAction {
    case newFile
    case newFolder
    case rename
    case delete
    case reveal
    case openVSCode
    case copyRelativePath
    case refresh
}

private struct DeveloperFileNodeRow: View {
    let node: FileNode
    let selectedURL: URL?
    let onSelect: (URL) -> Void
    let onAction: (DeveloperFileNodeAction, URL) -> Void
    @State private var isExpanded = false

    var body: some View {
        if node.isDirectory {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(node.children) { child in
                    DeveloperFileNodeRow(node: child, selectedURL: selectedURL, onSelect: onSelect, onAction: onAction)
                        .padding(.leading, ICOSSpacing.sm)
                }
            } label: {
                rowLabel(icon: .folder)
            }
            .contextMenu { contextMenuItems }
        } else {
            Button {
                onSelect(node.url)
            } label: {
                rowLabel(icon: .file)
            }
            .buttonStyle(.plain)
            .contextMenu { contextMenuItems }
        }
    }

    @ViewBuilder
    private var contextMenuItems: some View {
        if node.isDirectory {
            Button("New File") { onAction(.newFile, node.url) }
            Button("New Folder") { onAction(.newFolder, node.url) }
            Divider()
                .background(ICOSMaterials.separator)
        }
        Button("Rename") { onAction(.rename, node.url) }
        Button("Move to Trash") { onAction(.delete, node.url) }
        Divider()
            .background(ICOSMaterials.separator)
        Button("Reveal in Finder") { onAction(.reveal, node.url) }
        Button("Open in VS Code") { onAction(.openVSCode, node.url) }
        Button("Copy Relative Path") { onAction(.copyRelativePath, node.url) }
        Button("Refresh") { onAction(.refresh, node.url) }
    }

    private func rowLabel(icon: ICOSIcon) -> some View {
        HStack(spacing: ICOSDeveloperSidebarTokens.rowSpacing) {
            SVGImageView(icon: icon)
                .frame(width: ICOSDeveloperSidebarTokens.rowIconSize, height: ICOSDeveloperSidebarTokens.rowIconSize)

            Text(node.name)
                .font(.system(size: ICOSDeveloperSidebarTokens.rowTitleFontSize, weight: selectedURL == node.url ? .semibold : .regular))
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer(minLength: 0)
        }
        .foregroundStyle(selectedURL == node.url ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
        .padding(.horizontal, ICOSDeveloperSidebarTokens.rowHorizontalPadding)
        .padding(.vertical, ICOSDeveloperSidebarTokens.fileNodeVerticalPadding)
        .background(
            selectedURL == node.url ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.background.opacity(ICOSDeveloperSidebarTokens.inactiveRowOpacity),
            in: RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
        )
    }

}
