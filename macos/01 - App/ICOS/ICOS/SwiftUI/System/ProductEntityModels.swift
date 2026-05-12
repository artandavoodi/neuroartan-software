import Foundation

struct NeuroartanAccount: Identifiable, Codable, Hashable {
    enum SecurityState: String, Codable {
        case localOnly
        case verified
        case restricted
    }

    let id: UUID
    var displayName: String
    var securityState: SecurityState
    var legalAcceptanceState: Bool

    static func localDefault(profile: UserProfile) -> NeuroartanAccount {
        NeuroartanAccount(
            id: profile.id,
            displayName: profile.publicIdentityName,
            securityState: .localOnly,
            legalAcceptanceState: profile.privacyPolicyAcceptedAt != nil
        )
    }
}

struct NeuroartanModelRecord: Identifiable, Codable, Hashable {
    enum Visibility: String, Codable {
        case `private`
        case publicPreview
        case searchable
    }

    enum LifecycleState: String, Codable {
        case draft
        case configured
        case sourceLinked
        case ingesting
        case training
        case ready
        case paused
        case blocked
    }

    enum ReadinessState: String, Codable {
        case notReady
        case preparing
        case partiallyReady
        case ready
        case degraded
        case blocked
    }

    let id: UUID
    var profileID: UUID
    var slug: String
    var name: String
    var description: String
    var visibility: Visibility
    var lifecycleState: LifecycleState
    var readinessState: ReadinessState
    var routingClass: RuntimeMode
    var sourceCount: Int
    var trainingState: String
    var createdAt: Date
    var updatedAt: Date

    static func localDefault(profile: UserProfile) -> NeuroartanModelRecord {
        NeuroartanModelRecord(
            id: UUID(),
            profileID: profile.id,
            slug: "local-icos-model",
            name: profile.modelName,
            description: profile.modelSummary.isEmpty ? "Local ICOS runtime model record." : profile.modelSummary,
            visibility: profile.allowsPublicModelDisplay ? .publicPreview : .private,
            lifecycleState: .configured,
            readinessState: .partiallyReady,
            routingClass: .local,
            sourceCount: 0,
            trainingState: "uninitialized",
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}

enum ICOSPermissionDimension: String, Codable, CaseIterable, Identifiable {
    case visibility
    case discoverability
    case interaction
    case trainingAuthorization
    case verificationAuthorization
    case publicDisplayAuthorization
    case legacyActivation
    case fileRead
    case fileWrite
    case terminalExecution
    case buildExecution
    case deploymentExecution
    case networkConnector
    case voiceTranscription

    var id: String { rawValue }
}

struct ICOSAuditEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var action: String
    var targetPath: String
    var allowed: Bool
    var reason: String
    var timestamp: Date

    init(action: String, targetPath: String, allowed: Bool, reason: String) {
        self.id = UUID()
        self.action = action
        self.targetPath = targetPath
        self.allowed = allowed
        self.reason = reason
        self.timestamp = Date()
    }
}
