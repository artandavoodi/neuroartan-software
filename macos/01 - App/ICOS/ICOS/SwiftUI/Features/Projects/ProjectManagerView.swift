import SwiftUI
import AppKit
import Combine

// MARK: - Project Manager View

struct ProjectManagerView: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @EnvironmentObject private var services: SystemServices
    @ObservedObject var viewModel: ProjectManagerViewModel

    init(viewModel: ProjectManagerViewModel, shellState: Any? = nil) {
        self.viewModel = viewModel
    }

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSProjectManagerTokens.mainSectionSpacing)) {
                sectionCard(title: "Project Lifecycle", icon: .projectManagement) {
                    HStack(spacing: scaled(ICOSProjectManagerTokens.actionRowSpacing)) {
                        projectTextInput("New project name", text: $viewModel.newProjectName)

                        ICOSButton("Create", icon: .add, role: .primary) {
                            viewModel.createProject()
                        }
                        .disabled(viewModel.newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }

                    HStack(spacing: scaled(ICOSProjectManagerTokens.actionRowSpacing)) {
                        projectTextInput("New folder/group", text: $viewModel.newFolderName)

                        ICOSButton("New Folder", icon: .folder) {
                            viewModel.createFolder()
                        }
                        .disabled(viewModel.newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        ICOSButton("Add Directory", icon: .folder) {
                            viewModel.importProjectDirectory()
                        }
                    }

                    if !viewModel.statusText.isEmpty {
                        Text(viewModel.statusText)
                            .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                            .foregroundStyle(ICOSColors.textSecondary)
                    }
                }

                sectionCard(title: "Projects", icon: .repository) {
                    projectGroup(title: "Ungrouped", folderID: nil)

                    ForEach(viewModel.folders) { folder in
                        DisclosureGroup(isExpanded: viewModel.folderExpansionBinding(folder.id)) {
                            projectGroup(title: folder.name, folderID: folder.id)
                                .padding(.leading, scaled(ICOSSpacing.md))
                        } label: {
                            HStack(spacing: scaled(ICOSSpacing.sm)) {
                                SVGImageView(icon: .folder)
                                    .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))

                                Text(folder.name)
                                    .font(.system(size: scaledFont(ICOSControlTokens.settingsRowFontSize), weight: .semibold))
                                    .foregroundStyle(ICOSColors.textPrimary)

                                Spacer()

                                Text(String(viewModel.projects(in: folder.id).count))
                                    .font(.system(size: scaledFont(ICOSControlTokens.projectMetaFontSize), weight: .semibold))
                                    .foregroundStyle(ICOSColors.textSecondary)
                            }
                        }
                        .contextMenu {
                            Button("Rename Folder") {
                                viewModel.prepareRenameFolder(folder)
                            }

                            Button("Delete Empty Folder") {
                                viewModel.deleteFolder(folder)
                            }
                        }

                        if viewModel.renamingFolderID == folder.id {
                            renameField(
                                text: $viewModel.renameText,
                                commit: viewModel.commitFolderRename,
                                cancel: viewModel.cancelRename
                            )
                        }
                    }
                }

                if let activeProject = viewModel.activeProject {
                    sectionCard(title: "Active Project Definition", icon: .workspace) {
                        projectDetailSummary(activeProject)

                        projectTextInput("Description", text: viewModel.activeProjectBinding(\.projectDescription))
                        projectTextInput("Project definition", text: viewModel.activeProjectBinding(\.definition))
                        projectTextInput("Objectives, comma separated", text: viewModel.activeProjectListBinding(\.objectives))
                        projectTextInput("Goals, comma separated", text: viewModel.activeProjectListBinding(\.goals))
                        projectTextInput("Members, comma separated", text: viewModel.activeProjectListBinding(\.members))
                        projectTextInput("Status", text: viewModel.activeProjectBinding(\.status))
                        projectTextInput("Repository metadata", text: viewModel.activeProjectBinding(\.repositoryMetadata))

                        HStack(spacing: scaled(ICOSProjectManagerTokens.actionRowSpacing)) {
                            ICOSButton(activeProject.isPinned == true ? "Unpin" : "Pin", icon: .workspace, role: .ghost) {
                                viewModel.togglePinned(activeProject)
                            }

                            ICOSButton("Set Active", icon: .success, role: .primary) {
                                activateProject(activeProject)
                            }
                        }
                    }
                }
            }
            .padding(scaled(ICOSProjectManagerTokens.contentPadding))
        }
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.panelBackground
            }
        }
        .onAppear {
            syncActiveProjectWorkspace()
        }
        .onChange(of: viewModel.activeProjectID) { _, _ in
            syncActiveProjectWorkspace()
        }
        .onChange(of: viewModel.projects) { _, _ in
            syncActiveProjectWorkspace()
        }
    }

    // MARK: - Project Groups

    private func projectGroup(title: String, folderID: UUID?) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSProjectManagerTokens.groupSpacing)) {
            if folderID == nil {
                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            ForEach(viewModel.projects(in: folderID)) { project in
                if viewModel.renamingProjectID == project.id {
                    renameField(
                        text: $viewModel.renameText,
                        commit: viewModel.commitProjectRename,
                        cancel: viewModel.cancelRename
                    )
                } else {
                    projectRow(project)
                }
            }

            if viewModel.projects(in: folderID).isEmpty {
                Text("No projects in this group.")
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(scaled(ICOSProjectManagerTokens.emptyGroupPadding))
            }
        }
    }

    private func projectRow(_ project: ICOSProject) -> some View {
        Button {
            activateProject(project)
        } label: {
            HStack(spacing: scaled(ICOSProjectManagerTokens.projectRowSpacing)) {
                SVGImageView(icon: .folder)
                    .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))
                    .foregroundStyle(ICOSColors.textSecondary)

                VStack(alignment: .leading, spacing: scaled(ICOSProjectManagerTokens.projectRowTextSpacing)) {
                    Text(project.name)
                        .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Text(project.metadata)
                        .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                        .foregroundStyle(ICOSColors.textSecondary)

                    if let path = project.path {
                        Text(path)
                            .font(.system(size: scaledFont(ICOSControlTokens.projectPathFontSize), weight: .regular, design: .monospaced))
                            .foregroundStyle(ICOSColors.textTertiary)
                            .lineLimit(ICOSControlTokens.rowValueLineLimit)
                            .truncationMode(.middle)
                    }
                }

                Spacer()

                if project.isPinned == true {
                    SVGImageView(icon: .workspace)
                        .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))
                        .foregroundStyle(ICOSColors.textPrimary)
                }

                if viewModel.activeProjectID == project.id {
                    SVGImageView(icon: .success)
                        .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))
                        .foregroundStyle(ICOSColors.textPrimary)
                }
            }
            .padding(scaled(ICOSProjectManagerTokens.projectRowPadding))
            .background {
                RoundedRectangle(cornerRadius: scaled(ICOSControlTokens.fieldCornerRadius), style: .continuous)
                    .fill(
                        viewModel.activeProjectID == project.id
                        ? ICOSColors.activeFill
                        : (ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.floatingSurface : .clear)
                    )
            }
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Rename") {
                viewModel.prepareRenameProject(project)
            }

            Button("Move Directory") {
                viewModel.moveProjectDirectory(project)
            }

            Button(project.isPinned == true ? "Unpin" : "Pin") {
                viewModel.togglePinned(project)
            }

            Menu("Move to Folder") {
                Button("Ungrouped") {
                    viewModel.moveProject(project, to: nil)
                }

                ForEach(viewModel.folders) { folder in
                    Button(folder.name) {
                        viewModel.moveProject(project, to: folder.id)
                    }
                }
            }

            Button("New Folder") {
                viewModel.newFolderName = "New Group"
                viewModel.createFolder()
            }

            Divider()
                .background(ICOSMaterials.separator)

            Button("Remove Project") {
                viewModel.removeProject(project)
            }
        }
    }

    private func projectDetailSummary(_ project: ICOSProject) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSProjectManagerTokens.detailSummarySpacing)) {
            Text(project.name)
                .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            Text(project.path ?? "No directory assigned")
                .font(.system(size: scaledFont(ICOSControlTokens.projectPathFontSize), weight: .regular, design: .monospaced))
                .foregroundStyle(ICOSColors.textSecondary)
                .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
                .truncationMode(.middle)
        }
    }

    private func renameField(text: Binding<String>, commit: @escaping () -> Void, cancel: @escaping () -> Void) -> some View {
        HStack(spacing: scaled(ICOSProjectManagerTokens.actionRowSpacing)) {
            projectTextInput("Name", text: text)

            ICOSButton("Save", icon: .success, role: .primary, action: commit)
            ICOSButton("Cancel", icon: .close, role: .ghost, action: cancel)
        }
    }

    // MARK: - Workspace Synchronization

    private func activateProject(_ project: ICOSProject) {
        services.activateProject(project)
    }

    private func syncActiveProjectWorkspace() {
        services.synchronizeActiveProjectWorkspace()
    }

    // MARK: - Components

    private func sectionCard<Content: View>(
        title: String,
        icon: ICOSIcon,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSProjectManagerTokens.sectionCardSpacing)) {
            HStack(spacing: scaled(ICOSProjectManagerTokens.sectionHeaderSpacing)) {
                SVGImageView(icon: icon)
                    .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))

                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)
            }

            content()
        }
        .padding(scaled(ICOSProjectManagerTokens.sectionCardPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(cornerRadius: scaled(ICOSPanelTokens.cornerRadius), style: .continuous)
                    .fill(ICOSMaterials.elevatedSurface)
            }
        }
    }

    private func projectTextInput(_ placeholder: String, text: Binding<String>) -> some View {
        ICOSTextInput(placeholder, placeholder: placeholder, text: text)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Project Manager Tokens

private enum ICOSProjectManagerTokens {
    static let mainSectionSpacing: CGFloat = ICOSSpacing.lg
    static let contentPadding: CGFloat = ICOSSpacing.xxl
    static let actionRowSpacing: CGFloat = ICOSSpacing.sm
    static let groupSpacing: CGFloat = ICOSSpacing.sm
    static let emptyGroupPadding: CGFloat = ICOSSpacing.sm
    static let projectRowSpacing: CGFloat = ICOSSpacing.sm
    static let projectRowTextSpacing: CGFloat = ICOSSpacing.xs
    static let projectRowPadding: CGFloat = ICOSSpacing.sm
    static let detailSummarySpacing: CGFloat = ICOSSpacing.xs
    static let sectionCardSpacing: CGFloat = ICOSSpacing.md
    static let sectionHeaderSpacing: CGFloat = ICOSSpacing.sm
    static let sectionCardPadding: CGFloat = ICOSControlTokens.cardPadding
}

// MARK: - ICOS Project Models

struct ICOSProject: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var metadata: String
    var path: String?
    var folderID: UUID?
    var projectDescription: String? = nil
    var definition: String? = nil
    var objectives: [String]? = nil
    var goals: [String]? = nil
    var deadline: Date? = nil
    var members: [String]? = nil
    var status: String? = nil
    var repositoryMetadata: String? = nil
    var isPinned: Bool? = nil
    var isRecent: Bool? = nil
    var lastOpenedAt: Date? = nil
}

struct ICOSProjectFolder: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
}

struct ProjectManagerSnapshot: Codable {
    var projects: [ICOSProject]
    var folders: [ICOSProjectFolder]
    var activeProjectID: UUID?
}

// MARK: - Project Manager View Model

@MainActor
final class ProjectManagerViewModel: ObservableObject {
    static let shared = ProjectManagerViewModel()
    @Published var newProjectName = ""
    @Published var newFolderName = ""
    @Published var renameText = ""
    @Published var renamingProjectID: UUID?
    @Published var renamingFolderID: UUID?
    @Published var activeProjectID: UUID?
    @Published var projects: [ICOSProject] = []
    @Published var folders: [ICOSProjectFolder] = []
    @Published var expandedFolderIDs: Set<UUID> = []
    @Published var statusText = ""

    enum Keys {
        static let snapshot = "ICOS.Developer.ProjectManager.Snapshot"
    }

    var activeProject: ICOSProject? {
        guard let activeProjectID else { return nil }
        return projects.first { $0.id == activeProjectID }
    }

    var sortedProjects: [ICOSProject] {
        projects.sorted { lhs, rhs in
            if (lhs.isPinned ?? false) != (rhs.isPinned ?? false) {
                return lhs.isPinned == true
            }

            let lhsDate = lhs.lastOpenedAt ?? .distantPast
            let rhsDate = rhs.lastOpenedAt ?? .distantPast
            if lhsDate != rhsDate {
                return lhsDate > rhsDate
            }

            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
    }

    init() {
        load()
    }

    func projects(in folderID: UUID?) -> [ICOSProject] {
        projects
            .filter { $0.folderID == folderID }
            .sorted { lhs, rhs in
                if (lhs.isPinned ?? false) != (rhs.isPinned ?? false) {
                    return lhs.isPinned == true
                }

                let lhsDate = lhs.lastOpenedAt ?? .distantPast
                let rhsDate = rhs.lastOpenedAt ?? .distantPast
                if lhsDate != rhsDate {
                    return lhsDate > rhsDate
                }

                return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
    }

    func folderExpansionBinding(_ id: UUID) -> Binding<Bool> {
        Binding(
            get: { self.expandedFolderIDs.contains(id) },
            set: { isExpanded in
                if isExpanded {
                    self.expandedFolderIDs.insert(id)
                } else {
                    self.expandedFolderIDs.remove(id)
                }
            }
        )
    }

    func selectProject(_ project: ICOSProject) {
        activeProjectID = project.id
        updateProject(project.id) {
            $0.isRecent = true
            $0.lastOpenedAt = Date()
        }
        statusText = "Active project: \(project.name)"
        save()
    }

    func createProject() {
        let trimmed = newProjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let project = ICOSProject(name: trimmed, metadata: "Created locally", path: nil, folderID: nil)
        projects.append(project)
        activeProjectID = project.id
        updateProject(project.id) {
            $0.isRecent = true
            $0.lastOpenedAt = Date()
        }
        newProjectName = ""
        statusText = "Created project \(trimmed)."
        save()
    }

    func importProjectDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK, let url = panel.url else { return }

        let project = ICOSProject(
            name: url.lastPathComponent,
            metadata: "Local development workspace",
            path: url.path,
            folderID: nil
        )

        if let existing = projects.first(where: { $0.path == project.path }) {
            activeProjectID = existing.id
            updateProject(existing.id) {
                $0.isRecent = true
                $0.lastOpenedAt = Date()
            }
            statusText = "Project already exists: \(existing.name)."
            save()
        } else {
            projects.append(project)
            activeProjectID = project.id
            updateProject(project.id) {
                $0.isRecent = true
                $0.lastOpenedAt = Date()
            }
            statusText = "Imported \(project.name)."
            save()
        }
    }

    func createFolder() {
        let trimmed = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let folder = ICOSProjectFolder(name: trimmed)
        folders.append(folder)
        expandedFolderIDs.insert(folder.id)
        newFolderName = ""
        statusText = "Created folder \(trimmed)."
        save()
    }

    func prepareRenameProject(_ project: ICOSProject) {
        renamingProjectID = project.id
        renamingFolderID = nil
        renameText = project.name
    }

    func prepareRenameFolder(_ folder: ICOSProjectFolder) {
        renamingFolderID = folder.id
        renamingProjectID = nil
        renameText = folder.name
    }

    func commitProjectRename() {
        guard let id = renamingProjectID else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        updateProject(id) { $0.name = trimmed }
        statusText = "Renamed project to \(trimmed)."
        cancelRename()
        save()
    }

    func commitFolderRename() {
        guard let id = renamingFolderID else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let index = folders.firstIndex(where: { $0.id == id }) {
            folders[index].name = trimmed
            statusText = "Renamed folder to \(trimmed)."
        }
        cancelRename()
        save()
    }

    func cancelRename() {
        renamingProjectID = nil
        renamingFolderID = nil
        renameText = ""
    }

    func removeProject(_ project: ICOSProject) {
        projects.removeAll { $0.id == project.id }
        if activeProjectID == project.id {
            activeProjectID = projects.first?.id
        }
        statusText = "Removed project record. Files were not deleted."
        save()
    }

    func moveProject(_ project: ICOSProject, to folderID: UUID?) {
        updateProject(project.id) { $0.folderID = folderID }
        if let folderID {
            expandedFolderIDs.insert(folderID)
        }
        statusText = "Moved \(project.name)."
        save()
    }

    func togglePinned(_ project: ICOSProject) {
        updateProject(project.id) {
            $0.isPinned = !($0.isPinned ?? false)
        }
        statusText = project.isPinned == true ? "Unpinned \(project.name)." : "Pinned \(project.name)."
        save()
    }

    func activeProjectBinding(_ keyPath: WritableKeyPath<ICOSProject, String?>) -> Binding<String> {
        Binding(
            get: {
                guard let project = self.activeProject else { return "" }
                return project[keyPath: keyPath] ?? ""
            },
            set: { value in
                guard let activeProjectID = self.activeProjectID else { return }
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                self.updateProject(activeProjectID) {
                    $0[keyPath: keyPath] = trimmed.isEmpty ? nil : trimmed
                }
                self.statusText = "Updated active project."
                self.save()
            }
        )
    }

    func activeProjectListBinding(_ keyPath: WritableKeyPath<ICOSProject, [String]?>) -> Binding<String> {
        Binding(
            get: {
                guard let project = self.activeProject else { return "" }
                return project[keyPath: keyPath]?.joined(separator: ", ") ?? ""
            },
            set: { value in
                guard let activeProjectID = self.activeProjectID else { return }
                let values = value
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                self.updateProject(activeProjectID) {
                    $0[keyPath: keyPath] = values.isEmpty ? nil : values
                }
                self.statusText = "Updated active project."
                self.save()
            }
        )
    }

    func moveProjectDirectory(_ project: ICOSProject) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Set Project Directory"

        guard panel.runModal() == .OK, let url = panel.url else { return }
        updateProject(project.id) {
            $0.path = url.path
            $0.metadata = "Local development workspace"
        }
        statusText = "Updated directory for \(project.name)."
        save()
        if activeProjectID == project.id {
            statusText = "Updated active workspace: \(project.name)."
        }
    }

    func deleteFolder(_ folder: ICOSProjectFolder) {
        guard projects(in: folder.id).isEmpty else {
            statusText = "Move projects out of \(folder.name) before deleting it."
            return
        }
        folders.removeAll { $0.id == folder.id }
        expandedFolderIDs.remove(folder.id)
        statusText = "Deleted empty folder \(folder.name)."
        save()
    }

    private func updateProject(_ id: UUID, mutate: (inout ICOSProject) -> Void) {
        guard let index = projects.firstIndex(where: { $0.id == id }) else { return }
        mutate(&projects[index])
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Keys.snapshot),
           let decoded = try? JSONDecoder().decode(ProjectManagerSnapshot.self, from: data),
           !decoded.projects.isEmpty {
            projects = decoded.projects
            folders = decoded.folders
            activeProjectID = decoded.activeProjectID ?? decoded.projects.first?.id
            expandedFolderIDs = Set(decoded.folders.map(\.id))
            return
        }

        projects = [
            ICOSProject(name: "ICOS", metadata: "Primary cognitive runtime", path: "/Users/artan/Neuroartan-software/macos/01 - App/ICOS", folderID: nil),
            ICOSProject(name: "Website", metadata: "Neuroartan platform website", path: "/Users/artan/Documents/Neuroartan/website", folderID: nil)
        ]
        activeProjectID = projects.first?.id
        save()
    }

    func save() {
        let snapshot = ProjectManagerSnapshot(projects: projects, folders: folders, activeProjectID: activeProjectID)
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: Keys.snapshot)
            UserDefaults.standard.synchronize()
        }
    }
}
