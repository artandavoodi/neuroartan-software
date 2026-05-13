import SwiftUI

// MARK: - File Manager View

struct FileManagerView: View {
    @Environment(\.icosTypographyScale) private var typographyScale
    @State private var selectedPath: String = "No file selected"
    @State private var statusText: String = "Import a directory to inspect the local workspace tree."
    @State private var activeFiles: [String] = []
    @State private var filePreview: String = ""
    @State private var renameText: String = ""
    @State private var isRenaming = false
    @State private var workspaceRootURL: URL?

    var body: some View {
        HStack(spacing: 0) {
            sidebar

            Divider()
                .background(ICOSMaterials.separator)

            fileDetail
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minHeight: 520)
        .background(
            ICOSMaterials.panelBackground,
            in: RoundedRectangle(cornerRadius: ICOSPanelTokens.cornerRadius, style: .continuous)
        )
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            toolbar

            Spacer()

            emptyState

            Spacer()
        }
        .frame(minWidth: 320, idealWidth: 360, maxWidth: 420)
        .padding(scaled(ICOSSidebarTokens.contentHorizontalPadding))
        .background(ICOSMaterials.sidebarGlass)
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("Import Directory", icon: .folder, role: .primary) { importDirectory() }

                Spacer()

                ICOSButton("Refresh") { refreshDirectory() }
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("New File", icon: .file) { createFile() }

                ICOSButton("New Folder", icon: .folder) { createFolder() }

                ICOSButton("Rename") { isRenaming = true; renameText = selectedPath }
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("Move") { moveSelectedItem() }

                ICOSButton("Delete", role: .destructive) { deleteSelectedItem() }
            }

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("Active File", icon: .file) {
                    if !activeFiles.contains(selectedPath) {
                        activeFiles.append(selectedPath)
                    }
                }
                ICOSButton("Open in VS Code") { openSelectedItemInVSCode() }

                ICOSButton("Open Directory", icon: .folder) { openWorkspaceDirectory() }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: scaled(ICOSSpacing.sm)) {
            SVGImageView(icon: .fileManager)
                .frame(
                    width: scaled(ICOSFileManagerTokens.emptyIconSize),
                    height: scaled(ICOSFileManagerTokens.emptyIconSize)
                )
                .foregroundStyle(ICOSColors.textSecondary)

            Text("Import a directory to inspect the local workspace tree.")
                .font(.system(size: scaled(ICOSFileManagerTokens.emptyTitleFontSize)))
                .foregroundStyle(ICOSColors.textSecondary)
                .multilineTextAlignment(.center)

            Text("File operations run through the local workspace file system.")
                .font(.system(size: scaled(ICOSFileManagerTokens.emptySubtitleFontSize)))
                .foregroundStyle(ICOSSidebarColors.textSecondary.opacity(ICOSFileManagerTokens.secondaryTextOpacity))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - File Detail

    private var fileDetail: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                SVGImageView(icon: .file)
                    .frame(
                        width: scaled(ICOSFileManagerTokens.detailIconSize),
                        height: scaled(ICOSFileManagerTokens.detailIconSize)
                    )
                    .foregroundStyle(ICOSColors.textSecondary)

                Text(selectedPath)
                    .font(.system(size: scaled(ICOSFileManagerTokens.detailTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)

                Spacer()
            }

            if isRenaming {
                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    ICOSTextInput("Name", placeholder: "Name", text: $renameText)

                    ICOSButton("Save", icon: .success, role: .primary) {
                        selectedPath = renameText.isEmpty ? selectedPath : renameText
                        isRenaming = false
                    }

                    ICOSButton("Cancel", icon: .close, role: .ghost) {
                        isRenaming = false
                    }
                }
            }

            Text(selectedPath == "No file selected" ? "Select a file or folder from the tree." : selectedPath)
                .font(.system(size: scaled(ICOSFileManagerTokens.pathFontSize), design: .monospaced))
                .foregroundStyle(ICOSColors.textSecondary)
                .textSelection(.enabled)

            if !statusText.isEmpty {
                Text(statusText)
                    .font(.system(size: scaled(ICOSFileManagerTokens.statusFontSize)))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            activeFilesSection

            filePreviewSection

            ICOSButton("Grant Workspace Write Permission", icon: .key, role: .primary) {
                importDirectory()
            }

            Spacer()
        }
        .padding(scaled(ICOSSidebarTokens.contentHorizontalPadding))
        .background(ICOSMaterials.panelBackground)
    }

    // MARK: - Active Files

    @ViewBuilder
    private var activeFilesSection: some View {
        if !activeFiles.isEmpty {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
                Text("Active Files")
                    .font(.system(size: scaled(ICOSFileManagerTokens.sectionTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textSecondary)

                ForEach(activeFiles, id: \.self) { file in
                    HStack(spacing: scaled(ICOSSpacing.sm)) {
                        Text(file)
                            .font(.system(size: scaled(ICOSFileManagerTokens.pathFontSize), design: .monospaced))
                            .foregroundStyle(ICOSColors.textPrimary)
                            .lineLimit(ICOSControlTokens.rowValueLineLimit)

                        Spacer()

                        ICOSButton("Remove", role: .secondary) {
                            activeFiles.removeAll { $0 == file }
                        }
                    }
                    .padding(scaled(ICOSSpacing.sm))
                    .background(
                        ICOSMaterials.floatingSurface,
                        in: RoundedRectangle(cornerRadius: ICOSControlTokens.fieldCornerRadius, style: .continuous)
                    )
                }
            }
        }
    }

    // MARK: - File Preview

    private var filePreviewSection: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            TextEditor(text: $filePreview)
                .font(.system(size: scaled(ICOSFileManagerTokens.previewFontSize), design: .monospaced))
                .foregroundStyle(ICOSColors.textPrimary)
                .frame(minHeight: scaled(ICOSFileManagerTokens.previewMinHeight))
                .padding(scaled(ICOSSpacing.sm))
                .background(
                    ICOSMaterials.floatingSurface,
                    in: RoundedRectangle(cornerRadius: ICOSControlTokens.fieldCornerRadius, style: .continuous)
                )

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("Save File", icon: .success, role: .primary) {
                    saveFilePreview()
                }

                Spacer()
            }
        }
    }
}

// MARK: - File Operations

private extension FileManagerView {

    func importDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true

        if panel.runModal() == .OK, let url = panel.url {
            workspaceRootURL = url
            selectedPath = url.path
            loadDirectory(url)
        }
    }

    func refreshDirectory() {
        guard let workspaceRootURL else {
            statusText = "Import a directory first."
            return
        }

        loadDirectory(workspaceRootURL)
    }

    func loadDirectory(_ url: URL) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            activeFiles = contents
                .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
                .map(\.path)

            statusText = "Loaded \(activeFiles.count) items from \(url.path)"
        } catch {
            statusText = "Directory load failed: \(error.localizedDescription)"
        }
    }

    func createFile() {
        guard let workspaceRootURL else {
            statusText = "Import a directory first."
            return
        }

        let url = workspaceRootURL.appendingPathComponent("Untitled.md")

        if FileManager.default.createFile(
            atPath: url.path,
            contents: Data(),
            attributes: nil
        ) {
            selectedPath = url.path
            filePreview = ""
            refreshDirectory()
        } else {
            statusText = "File creation failed."
        }
    }

    func createFolder() {
        guard let workspaceRootURL else {
            statusText = "Import a directory first."
            return
        }

        let url = workspaceRootURL.appendingPathComponent("Untitled Folder")

        do {
            try FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: false
            )
            selectedPath = url.path
            refreshDirectory()
        } catch {
            statusText = "Folder creation failed: \(error.localizedDescription)"
        }
    }

    func moveSelectedItem() {
        guard selectedPath != "No file selected" else {
            statusText = "Select an item first."
            return
        }

        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK, let destination = panel.url else {
            return
        }

        let sourceURL = URL(fileURLWithPath: selectedPath)
        let destinationURL = destination.appendingPathComponent(sourceURL.lastPathComponent)

        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            selectedPath = destinationURL.path
            refreshDirectory()
        } catch {
            statusText = "Move failed: \(error.localizedDescription)"
        }
    }

    func deleteSelectedItem() {
        guard selectedPath != "No file selected" else {
            statusText = "Select an item first."
            return
        }

        do {
            try FileManager.default.trashItem(
                at: URL(fileURLWithPath: selectedPath),
                resultingItemURL: nil
            )
            selectedPath = "No file selected"
            filePreview = ""
            refreshDirectory()
        } catch {
            statusText = "Delete failed: \(error.localizedDescription)"
        }
    }

    func openSelectedItemInVSCode() {
        guard selectedPath != "No file selected" else {
            statusText = "Select an item first."
            return
        }

        runProcess(
            executableURL: URL(fileURLWithPath: "/usr/bin/open"),
            arguments: ["-a", "Visual Studio Code", selectedPath]
        )
    }

    func openWorkspaceDirectory() {
        guard let workspaceRootURL else {
            statusText = "Import a directory first."
            return
        }

        runProcess(
            executableURL: URL(fileURLWithPath: "/usr/bin/open"),
            arguments: [workspaceRootURL.path]
        )
    }

    func saveFilePreview() {
        guard selectedPath != "No file selected" else {
            statusText = "Select a file first."
            return
        }

        do {
            try filePreview.write(
                to: URL(fileURLWithPath: selectedPath),
                atomically: true,
                encoding: .utf8
            )
            statusText = "Saved \(selectedPath)"
        } catch {
            statusText = "Save failed: \(error.localizedDescription)"
        }
    }

    func runProcess(
        executableURL: URL,
        arguments: [String]
    ) {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = arguments

        do {
            try process.run()
            statusText = "Opened successfully."
        } catch {
            statusText = "Open failed: \(error.localizedDescription)"
        }
    }
}
