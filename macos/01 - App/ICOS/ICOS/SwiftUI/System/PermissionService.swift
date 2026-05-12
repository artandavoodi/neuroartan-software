import Foundation
import Combine

@MainActor
final class PermissionService: ObservableObject {
    @Published private(set) var grants: Set<ICOSPermissionDimension> = [.fileRead]
    @Published private(set) var auditLog: [ICOSAuditEvent] = []

    func grant(_ permission: ICOSPermissionDimension) {
        grants.insert(permission)
    }

    func revoke(_ permission: ICOSPermissionDimension) {
        grants.remove(permission)
    }

    func validate(_ permission: ICOSPermissionDimension, action: String, url: URL?) -> Bool {
        let path = url?.path ?? ""
        guard grants.contains(permission) else {
            let reason = "Permission denied: \(permission.rawValue) is not granted."
            auditLog.insert(ICOSAuditEvent(action: action, targetPath: path, allowed: false, reason: reason), at: 0)
            auditLog = Array(auditLog.prefix(100))
            return false
        }

        if let url, shouldValidateWorkspaceRoot(permission) {
            let gateResult = PermissionGate.shared.validate(path: url.path, action: permissionAction(for: permission))
            auditLog.insert(ICOSAuditEvent(action: action, targetPath: gateResult.path, allowed: gateResult.allowed, reason: gateResult.message), at: 0)
            auditLog = Array(auditLog.prefix(100))
            return gateResult.allowed
        }

        let allowed = true
        let reason = "Permission granted."
        auditLog.insert(ICOSAuditEvent(action: action, targetPath: path, allowed: allowed, reason: reason), at: 0)
        auditLog = Array(auditLog.prefix(100))
        return allowed
    }

    private func shouldValidateWorkspaceRoot(_ permission: ICOSPermissionDimension) -> Bool {
        switch permission {
        case .fileRead, .fileWrite, .terminalExecution, .buildExecution, .deploymentExecution:
            return true
        default:
            return false
        }
    }

    private func permissionAction(for permission: ICOSPermissionDimension) -> PermissionAction {
        switch permission {
        case .fileWrite:
            return .write
        case .terminalExecution, .buildExecution, .deploymentExecution:
            return .execute
        default:
            return .read
        }
    }
}
