import Foundation

/* =============================================================================
   00) ROLLBACK SNAPSHOT
============================================================================= */
struct RollbackSnapshot: Identifiable {
    let id: UUID
    let filePath: String
    let content: String
    let createdAt: Date

    init(
        filePath: String,
        content: String
    ) {
        self.id = UUID()
        self.filePath = filePath
        self.content = content
        self.createdAt = Date()
    }
}

/* =============================================================================
   01) ROLLBACK RESULT
============================================================================= */
struct RollbackResult {
    let success: Bool
    let filePath: String
    let message: String
}

/* =============================================================================
   02) ROLLBACK MANAGER
============================================================================= */
final class RollbackManager {

    static let shared = RollbackManager()

    private(set) var snapshots: [RollbackSnapshot] = []

    private init() {}

    /* -------------------------------------------------------------------------
       SNAPSHOT CREATION
    ------------------------------------------------------------------------- */
    func createSnapshot(filePath: String) {

        guard let content = try? String(
            contentsOfFile: filePath,
            encoding: .utf8
        ) else {
            return
        }

        let snapshot = RollbackSnapshot(
            filePath: filePath,
            content: content
        )

        snapshots.append(snapshot)
    }

    /* -------------------------------------------------------------------------
       ROLLBACK EXECUTION
    ------------------------------------------------------------------------- */
    func rollback(filePath: String) -> RollbackResult {

        guard let snapshot = snapshots
            .last(where: { $0.filePath == filePath }) else {

            return RollbackResult(
                success: false,
                filePath: filePath,
                message: "No rollback snapshot found."
            )
        }

        do {
            try snapshot.content.write(
                toFile: filePath,
                atomically: true,
                encoding: .utf8
            )

            RuntimeEventBus.shared.emit(
                type: .patchApplied,
                payload: [
                    "filePath": filePath,
                    "status": "rollback_success"
                ]
            )

            return RollbackResult(
                success: true,
                filePath: filePath,
                message: "Rollback completed successfully."
            )

        } catch {

            RuntimeEventBus.shared.emit(
                type: .patchRejected,
                payload: [
                    "filePath": filePath,
                    "error": error.localizedDescription
                ]
            )

            return RollbackResult(
                success: false,
                filePath: filePath,
                message: error.localizedDescription
            )
        }
    }

    /* -------------------------------------------------------------------------
       SNAPSHOT ACCESS
    ------------------------------------------------------------------------- */
    func latestSnapshot() -> RollbackSnapshot? {
        snapshots.last
    }

    func clearSnapshots() {
        snapshots.removeAll()
    }
}