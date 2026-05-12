import Foundation

/* =============================================================================
   00) PERMISSION ACTION
============================================================================= */
enum PermissionAction: String {
    case read
    case write
    case execute
    case delete
}

/* =============================================================================
   01) PERMISSION RESULT
============================================================================= */
struct PermissionResult {
    let allowed: Bool
    let path: String
    let action: PermissionAction
    let message: String
}

/* =============================================================================
   02) PERMISSION GATE
============================================================================= */
final class PermissionGate {

    static let shared = PermissionGate()

    private let allowedRoots: [String] = [
        "/Users/artan/Neuroartan-software"
    ]
    private var userAuthorizedRoots: Set<String> = []

    private init() {}

    func registerAuthorizedRoot(_ path: String) {
        let normalizedPath = URL(fileURLWithPath: path).standardized.path
        userAuthorizedRoots.insert(normalizedPath)
    }

    /* -------------------------------------------------------------------------
       ACCESS VALIDATION
    ------------------------------------------------------------------------- */
    func validate(
        path: String,
        action: PermissionAction
    ) -> PermissionResult {

        let normalizedPath = URL(
            fileURLWithPath: path
        ).standardized.path

        let roots = allowedRoots + Array(userAuthorizedRoots)
        let allowed = roots.contains {
            normalizedPath.hasPrefix($0)
        }

        if allowed {

            RuntimeEventBus.shared.emit(
                type: .patchApplied,
                payload: [
                    "path": normalizedPath,
                    "action": action.rawValue,
                    "permission": "granted"
                ]
            )

            return PermissionResult(
                allowed: true,
                path: normalizedPath,
                action: action,
                message: "Permission granted."
            )
        }

        RuntimeEventBus.shared.emit(
            type: .patchRejected,
            payload: [
                "path": normalizedPath,
                "action": action.rawValue,
                "permission": "denied"
            ]
        )

        return PermissionResult(
            allowed: false,
            path: normalizedPath,
            action: action,
            message: "Access denied outside sovereign workspace."
        )
    }

    /* -------------------------------------------------------------------------
       ROOT ACCESS
    ------------------------------------------------------------------------- */
    func registeredRoots() -> [String] {
        allowedRoots + Array(userAuthorizedRoots).sorted()
    }
}
