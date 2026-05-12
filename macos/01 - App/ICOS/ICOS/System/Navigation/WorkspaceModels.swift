import Foundation

// MARK: - Workspace Core Models

struct WorkspaceDepartment: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let offices: [WorkspaceOffice]
}

struct WorkspaceOffice: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let projects: [WorkspaceProject]
}

struct WorkspaceProject: Identifiable, Hashable {
    let id = UUID()
    let title: String
}