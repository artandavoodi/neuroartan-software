import Foundation

/* =============================================================================
   00) PATCH OPERATION
============================================================================= */
struct PatchOperation: Identifiable {
    let id: UUID
    let filePath: String
    let originalContent: String
    let updatedContent: String
    let createdAt: Date

    init(
        filePath: String,
        originalContent: String,
        updatedContent: String
    ) {
        self.id = UUID()
        self.filePath = filePath
        self.originalContent = originalContent
        self.updatedContent = updatedContent
        self.createdAt = Date()
    }
}

/* =============================================================================
   01) PATCH RESULT
============================================================================= */
struct PatchResult {
    let success: Bool
    let filePath: String
    let message: String
}

/* =============================================================================
   02) PATCH ENGINE
============================================================================= */
final class PatchEngine {

    static let shared = PatchEngine()

    private(set) var operations: [PatchOperation] = []

    private init() {}

    /* -------------------------------------------------------------------------
       FILE PATCH APPLICATION
    ------------------------------------------------------------------------- */
    func applyPatch(
        filePath: String,
        updatedContent: String
    ) -> PatchResult {

        do {
            let originalContent = try String(
                contentsOfFile: filePath,
                encoding: .utf8
            )

            let operation = PatchOperation(
                filePath: filePath,
                originalContent: originalContent,
                updatedContent: updatedContent
            )

            try updatedContent.write(
                toFile: filePath,
                atomically: true,
                encoding: .utf8
            )

            operations.append(operation)

            RuntimeEventBus.shared.emit(
                type: .patchApplied,
                payload: [
                    "filePath": filePath,
                    "status": "success"
                ]
            )

            return PatchResult(
                success: true,
                filePath: filePath,
                message: "Patch applied successfully."
            )

        } catch {

            RuntimeEventBus.shared.emit(
                type: .patchRejected,
                payload: [
                    "filePath": filePath,
                    "error": error.localizedDescription
                ]
            )

            return PatchResult(
                success: false,
                filePath: filePath,
                message: error.localizedDescription
            )
        }
    }

    /* -------------------------------------------------------------------------
       PATCH HISTORY
    ------------------------------------------------------------------------- */
    func latestOperation() -> PatchOperation? {
        operations.last
    }

    func clearHistory() {
        operations.removeAll()
    }
}