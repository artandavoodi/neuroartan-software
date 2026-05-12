import Foundation

// MARK: - Workspace Seed Data

enum WorkspaceSeed {
    static let departments: [WorkspaceDepartment] = [
        WorkspaceDepartment(
            title: "Software",
            offices: [
                WorkspaceOffice(
                    title: "Runtime",
                    projects: [
                        WorkspaceProject(title: "Native Runtime"),
                        WorkspaceProject(title: "Model Registry"),
                        WorkspaceProject(title: "API Gateway")
                    ]
                ),
                WorkspaceOffice(
                    title: "Application",
                    projects: [
                        WorkspaceProject(title: "Developer Console"),
                        WorkspaceProject(title: "Sidebar Shell"),
                        WorkspaceProject(title: "Workspace Tree")
                    ]
                )
            ]
        ),
        WorkspaceDepartment(
            title: "Operations",
            offices: [
                WorkspaceOffice(
                    title: "Execution Control",
                    projects: [
                        WorkspaceProject(title: "Master Checklist"),
                        WorkspaceProject(title: "Phase Tracker")
                    ]
                )
            ]
        ),
        WorkspaceDepartment(
            title: "Knowledge",
            offices: [
                WorkspaceOffice(
                    title: "Research",
                    projects: [
                        WorkspaceProject(title: "Neuroscience"),
                        WorkspaceProject(title: "Cognition")
                    ]
                )
            ]
        )
    ]
}