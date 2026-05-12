import Foundation

enum DeveloperToolRegistry {
    static let tools: [DeveloperToolDescriptor] = [
        DeveloperToolDescriptor(
            id: "intent-planner",
            title: "Execution Planner",
            summary: "Turns a development request into a local-first execution plan.",
            category: .planning,
            status: .available,
            requiredPermission: nil
        ),
        DeveloperToolDescriptor(
            id: "workspace-scanner",
            title: "Workspace Scanner",
            summary: "Indexes files from the imported local project without guessing paths.",
            category: .repository,
            status: .available,
            requiredPermission: .fileRead
        ),
        DeveloperToolDescriptor(
            id: "owner-chain",
            title: "Owner Chain Resolver",
            summary: "Locates canonical source files before edit or replacement work.",
            category: .repository,
            status: .available,
            requiredPermission: .fileRead
        ),
        DeveloperToolDescriptor(
            id: "draft-editor",
            title: "Governed File Editor",
            summary: "Edits selected local files through a save gate and permission audit.",
            category: .editing,
            status: .permissionRequired,
            requiredPermission: .fileWrite
        ),
        DeveloperToolDescriptor(
            id: "local-terminal",
            title: "Workspace Terminal",
            summary: "Runs scoped shell commands inside the imported workspace directory.",
            category: .terminal,
            status: .permissionRequired,
            requiredPermission: .terminalExecution
        ),
        DeveloperToolDescriptor(
            id: "git-review",
            title: "Repository Review",
            summary: "Runs local git status and review-oriented scans.",
            category: .review,
            status: .available,
            requiredPermission: .fileRead
        ),
        DeveloperToolDescriptor(
            id: "xcode-build",
            title: "Xcode Build Adapter",
            summary: "Builds and verifies native Apple targets from the local workspace.",
            category: .build,
            status: .permissionRequired,
            requiredPermission: .buildExecution
        ),
        DeveloperToolDescriptor(
            id: "deployment-adapter",
            title: "Deployment Adapter",
            summary: "Prepares governed deployment commands for configured project targets.",
            category: .deployment,
            status: .needsConfiguration,
            requiredPermission: .deploymentExecution
        ),
        DeveloperToolDescriptor(
            id: "github-connector",
            title: "GitHub Connector",
            summary: "Connects repositories, branches, pull requests, and remote review state.",
            category: .integration,
            status: .needsConfiguration,
            requiredPermission: .networkConnector
        ),
        DeveloperToolDescriptor(
            id: "agent-runtime",
            title: "Agent Runtime",
            summary: "Creates repository-aware development agents with file, terminal, patch, rollback, and provider routing permissions.",
            category: .planning,
            status: .available,
            requiredPermission: nil
        ),
        DeveloperToolDescriptor(
            id: "connector-registry",
            title: "Connector Registry",
            summary: "Stores connector configuration, credentials, status, logs, and agent-access permissions.",
            category: .integration,
            status: .available,
            requiredPermission: .networkConnector
        )
    ]
}
