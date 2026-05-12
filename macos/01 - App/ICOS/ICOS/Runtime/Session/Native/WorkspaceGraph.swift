import Foundation

/* =============================================================================
   00) WORKSPACE FILE
============================================================================= */
struct WorkspaceFile: Identifiable {
    let id: UUID
    let path: String
    let fileName: String
    let fileExtension: String
    let createdAt: Date

    init(path: String) {
        self.id = UUID()
        self.path = path
        self.fileName = URL(fileURLWithPath: path)
            .lastPathComponent
        self.fileExtension = URL(fileURLWithPath: path)
            .pathExtension
        self.createdAt = Date()
    }
}

/* =============================================================================
   01) WORKSPACE GRAPH
============================================================================= */
final class WorkspaceGraph {

    static let shared = WorkspaceGraph()

    private(set) var workspaceRoot: String?
    private(set) var indexedFiles: [WorkspaceFile] = []

    private let fileManager = FileManager.default

    private init() {}

    /* -------------------------------------------------------------------------
       WORKSPACE REGISTRATION
    ------------------------------------------------------------------------- */
    func registerWorkspace(root: String) {

        workspaceRoot = root

        RuntimeEventBus.shared.emit(
            type: .workspaceIndexed,
            payload: [
                "workspaceRoot": root,
                "status": "registered"
            ]
        )
    }

    /* -------------------------------------------------------------------------
       WORKSPACE INDEXING
    ------------------------------------------------------------------------- */
    func indexWorkspace() {

        guard let workspaceRoot else {
            return
        }

        indexedFiles.removeAll()

        guard let enumerator = fileManager.enumerator(
            at: URL(fileURLWithPath: workspaceRoot),
            includingPropertiesForKeys: nil
        ) else {
            return
        }

        for case let fileURL as URL in enumerator {

            if fileURL.hasDirectoryPath {
                continue
            }

            let file = WorkspaceFile(
                path: fileURL.path
            )

            indexedFiles.append(file)
        }

        RuntimeEventBus.shared.emit(
            type: .workspaceIndexed,
            payload: [
                "workspaceRoot": workspaceRoot,
                "indexedFiles": String(indexedFiles.count)
            ]
        )
    }

    /* -------------------------------------------------------------------------
       WORKSPACE ACCESS
    ------------------------------------------------------------------------- */
    func files(withExtension extensionName: String) -> [WorkspaceFile] {
        indexedFiles.filter {
            $0.fileExtension.lowercased()
                == extensionName.lowercased()
        }
    }

    func contains(path: String) -> Bool {
        indexedFiles.contains(where: {
            $0.path == path
        })
    }

    func totalFiles() -> Int {
        indexedFiles.count
    }

    func clearIndex() {
        indexedFiles.removeAll()
    }
}