
import SwiftUI

// MARK: - Workspace Tree View

struct WorkspaceTreeView: View {
    let searchText: String
    let onSelectProject: () -> Void

    @EnvironmentObject private var services: SystemServices
    @State private var expandedNodes: Set<URL> = []

    private var workspaceFileService: WorkspaceFileService {
        services.workspaceFileService
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            ICOSScrollView {
                LazyVStack(alignment: .leading, spacing: ICOSSpacing.xxs) {
                    if let rootNode = workspaceFileService.rootNode {
                        fileNodeBlock(rootNode, depth: 0)
                    } else {
                        emptyState
                    }
                }
                .padding(.horizontal, ICOSSidebarTokens.contentHorizontalPadding)
                .padding(.bottom, ICOSSidebarTokens.contentBottomPadding)
            }
        }
        .frame(width: ICOSSidebarTokens.workspacePanelWidth)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: ICOSSpacing.sm) {
            Text("Workspace")
                .font(ICOSTypography.caption.weight(.semibold))
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Spacer()

            Button {
                workspaceFileService.reload()
            } label: {
                Text("Reload")
                    .font(ICOSTypography.caption.weight(.medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, ICOSSidebarTokens.headerHorizontalPadding)
        .padding(.vertical, ICOSSpacing.md)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
            Text("No workspace loaded")
                .font(ICOSTypography.caption.weight(.medium))
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Text(workspaceFileService.statusText.isEmpty ? "Import or load a workspace to begin." : workspaceFileService.statusText)
                .font(ICOSTypography.caption)
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .lineLimit(3)

            Button {
                workspaceFileService.importDirectory()
            } label: {
                Text("Open Workspace")
                    .font(ICOSTypography.caption.weight(.semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
                    .padding(.vertical, ICOSSpacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                            .fill(ICOSSidebarColors.rowActiveFill)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
        .padding(.vertical, ICOSSpacing.md)
    }

    // MARK: - File Tree

    private func fileNodeBlock(_ node: FileNode, depth: Int) -> AnyView {
        guard matchesSearch(node) || containsMatchingDescendant(node) else {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: ICOSSpacing.xxs) {
                treeRow(node: node, depth: depth)

                if node.isDirectory && isExpanded(node) {
                    ForEach(filteredChildren(for: node)) { child in
                        fileNodeBlock(child, depth: depth + 1)
                    }
                }
            }
        )
    }

    private func treeRow(node: FileNode, depth: Int) -> some View {
        let isActive = workspaceFileService.selectedURL == node.url

        return Button {
            handleSelection(node)
        } label: {
            HStack(spacing: ICOSSpacing.sm) {
                SVGImageView(icon: node.isDirectory ? disclosureIcon(for: node) : .file)
                    .frame(width: ICOSSidebarTokens.iconXS, height: ICOSSidebarTokens.iconXS)
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)

                SVGImageView(icon: node.isDirectory ? .folder : .file)
                    .frame(width: ICOSSidebarTokens.iconXS, height: ICOSSidebarTokens.iconXS)
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)

                Text(node.name)
                    .font(ICOSTypography.caption.weight(isActive ? .medium : .regular))
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.leading, CGFloat(depth) * ICOSSidebarTokens.treeIndent + ICOSSidebarTokens.rowHorizontalPadding)
            .padding(.trailing, ICOSSidebarTokens.rowHorizontalPadding)
            .padding(.vertical, ICOSSpacing.xs)
            .background {
                RoundedRectangle(cornerRadius: ICOSSidebarTokens.rowCornerRadius, style: .continuous)
                    .fill(
                        isActive
                        ? ICOSSidebarColors.rowActiveFill
                        : (ICOSMaterials.showsLayeredSurfaces ? ICOSSidebarColors.background.opacity(0) : .clear)
                    )
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Copy Path") {
                workspaceFileService.copyRelativePath(node.url)
            }

            Button("Reveal in Finder") {
                workspaceFileService.revealInFinder(node.url)
            }

            Button("Open in VS Code") {
                workspaceFileService.select(node.url)
                workspaceFileService.openSelectedInVSCode()
            }
        }
    }

    // MARK: - Actions

    private func handleSelection(_ node: FileNode) {
        workspaceFileService.select(node.url)

        if node.isDirectory {
            toggle(node)
        } else {
            onSelectProject()
        }
    }

    private func toggle(_ node: FileNode) {
        if expandedNodes.contains(node.url) {
            expandedNodes.remove(node.url)
        } else {
            expandedNodes.insert(node.url)
        }
    }

    // MARK: - Filtering

    private func filteredChildren(for node: FileNode) -> [FileNode] {
        let query = normalizedQuery
        guard !query.isEmpty else { return node.children }

        return node.children.filter { child in
            matchesSearch(child) || containsMatchingDescendant(child)
        }
    }

    private func matchesSearch(_ node: FileNode) -> Bool {
        let query = normalizedQuery
        guard !query.isEmpty else { return true }
        return node.name.lowercased().contains(query)
    }

    private func containsMatchingDescendant(_ node: FileNode) -> Bool {
        node.children.contains { child in
            matchesSearch(child) || containsMatchingDescendant(child)
        }
    }

    private var normalizedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - State

    private func isExpanded(_ node: FileNode) -> Bool {
        expandedNodes.contains(node.url) || !normalizedQuery.isEmpty || node.url == workspaceFileService.rootURL
    }

    private func disclosureIcon(for node: FileNode) -> ICOSIcon {
        isExpanded(node) ? .chevronDown : .chevronRight
    }
}
