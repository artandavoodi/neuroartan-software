import Foundation
import Combine

// MARK: - Personal Model Foundation Registry

final class PersonalModelFoundationRegistry: ObservableObject {
    static let shared = PersonalModelFoundationRegistry()

    @Published private(set) var foundation: PersonalModelFoundation?

    private let storageKey = "neuroartan.icos.personalModelFoundation.v1"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private init() {
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        load()
    }

    func ensureDefaultPersonalModel(for profile: UserProfile) -> PersonalModelFoundation {
        if let foundation {
            return foundation
        }

        let now = Date()
        let modelID = "pm-\(UUID().uuidString.lowercased())"
        let ownerUserID = profile.username.isEmpty ? "owner-local" : profile.username

        let createdFoundation = PersonalModelFoundation(
            personalModel: PersonalModelRecord(
                modelID: modelID,
                ownerUserID: ownerUserID,
                modelType: .personal,
                visibilityState: .privateOnly,
                lifecycleState: .created,
                registryID: "reg-\(modelID)",
                birthCertificateID: "birth-\(modelID)",
                providerRouteID: "route-\(modelID)",
                entitlementID: "entitlement-\(modelID)",
                permissionID: "permission-\(modelID)",
                createdAt: now,
                updatedAt: now
            ),
            birthCertificate: ModelBirthCertificateRecord(
                birthCertificateID: "birth-\(modelID)",
                modelID: modelID,
                ownerUserID: ownerUserID,
                birthEventType: .defaultPersonalModelBirth,
                birthDate: now,
                sourceAuthorizationState: .notYetLinked,
                initialVisibilityState: .privateOnly,
                creationContext: "Private personal model foundation initialized from local profile state."
            ),
            identityRegistry: ModelIdentityRegistryRecord(
                registryID: "reg-\(modelID)",
                modelID: modelID,
                privateIdentityID: "private-\(modelID)",
                publicIdentityID: "public-\(modelID)",
                registryStatus: .active,
                discoverabilityState: .privateOnly,
                marketplaceState: .blockedUntilReview,
                createdAt: now,
                updatedAt: now
            ),
            publicIdentity: PublicModelIdentityRecord(
                publicIdentityID: "public-\(modelID)",
                modelID: modelID,
                publicSlug: profile.username.isEmpty ? "private-model" : "\(profile.username)-model",
                displayName: profile.modelName.isEmpty ? "Private Personal Model" : profile.modelName,
                publicVisibilityState: .disabled,
                publicDescription: "",
                publicCapabilitySummary: "Private foundation only.",
                publicProfileEnabled: false
            ),
            privateIdentity: PrivateModelIdentityRecord(
                privateIdentityID: "private-\(modelID)",
                modelID: modelID,
                ownerUserID: ownerUserID,
                privateProfileState: .active,
                continuityScope: .ownerPrivate,
                sensitiveSourceState: .notYetLinked,
                privacyLockState: .locked
            ),
            providerRouting: ProviderRoutingStateRecord(
                providerRouteID: "route-\(modelID)",
                modelID: modelID,
                defaultProvider: .notAssigned,
                fallbackProvider: .notAssigned,
                routingPolicy: .privateFoundationPlaceholder,
                runtimeMode: .pendingRuntimeSelection,
                localRuntimeEnabled: false,
                cloudRuntimeEnabled: false,
                routingPrivacyState: .privateOnly
            ),
            entitlement: ModelEntitlementStateRecord(
                entitlementID: "entitlement-\(modelID)",
                ownerUserID: ownerUserID,
                modelID: modelID,
                subscriptionTier: .free,
                modelCreationLimit: 1,
                personalModelIncluded: true,
                additionalModelSlots: 0,
                marketplaceAccessState: .blockedUntilReview,
                monetizationRequestState: .blockedUntilReview
            ),
            permission: ModelPermissionStateRecord(
                permissionID: "permission-\(modelID)",
                modelID: modelID,
                trainingPermissionState: .ownerOnly,
                sourceLinkingPermissionState: .notYetGranted,
                publicVisibilityPermissionState: .disabled,
                marketplacePermissionState: .blockedUntilReview,
                monetizationPermissionState: .blockedUntilReview,
                interModelHiringPermissionState: .blockedUntilReview,
                posthumousContinuityPermissionState: .disabled
            ),
            sourceAuthorization: SourceAuthorizationStateRecord(
                sourceAuthorizationID: "source-\(modelID)",
                ownerUserID: ownerUserID,
                modelID: modelID,
                sourceType: .none,
                authorizationScope: .none,
                authorizationState: .notYetGranted,
                revocationState: .notApplicable,
                revocationEffect: .none,
                createdAt: now,
                updatedAt: now
            ),
            lifecycle: ModelLifecycleStateRecord(
                lifecycleStateID: "lifecycle-\(modelID)",
                modelID: modelID,
                currentState: .created,
                previousState: .none,
                stateReason: .defaultPersonalModelBirth,
                stateChangedAt: now,
                archiveEligible: true,
                deleteEligible: true
            ),
            dashboard: OwnerFacingDashboardStateRecord(
                dashboardStateID: "dashboard-\(modelID)",
                modelID: modelID,
                ownerUserID: ownerUserID,
                birthStatusDisplay: .created,
                registryStatusDisplay: .registeredPrivate,
                providerRouteDisplay: .notAssigned,
                entitlementDisplay: .freePersonalModelIncluded,
                permissionDisplay: .privateOwnerOnly,
                readinessDisplay: .foundationReady,
                blockedEconomyDisplay: .economyFeaturesBlockedUntilReview
            ),
            dignitySecurity: ModelDignitySecurityStateRecord(
                securityStateID: "security-\(modelID)",
                modelID: modelID,
                ownerUserID: ownerUserID,
                sensitiveDataState: .protected,
                identityProtectionState: .privateOwnerControlled,
                voiceProtectionState: .notYetLinked,
                memoryProtectionState: .privateFoundationOnly,
                deletionPolicyState: .ownerRequestRequired,
                exportPolicyState: .blockedUntilPolicyReview
            ),
            blockedEconomy: BlockedEconomyStateRecord(
                blockedStateID: "blocked-\(modelID)",
                modelID: modelID,
                marketplaceBlocked: true,
                monetizationBlocked: true,
                payoutBlocked: true,
                publicRankingBlocked: true,
                interModelHiringBlocked: true,
                regulatedDomainBlocked: true,
                guaranteedIncomeClaimBlocked: true,
                consciousnessPersonhoodClaimBlocked: true,
                posthumousEconomyBlocked: true
            )
        )

        foundation = createdFoundation
        save()
        return createdFoundation
    }

    func resetFoundation() {
        foundation = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        foundation = try? decoder.decode(PersonalModelFoundation.self, from: data)
    }

    private func save() {
        guard let foundation else { return }
        guard let data = try? encoder.encode(foundation) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

// MARK: - Foundation Aggregate

struct PersonalModelFoundation: Codable, Equatable {
    let personalModel: PersonalModelRecord
    let birthCertificate: ModelBirthCertificateRecord
    let identityRegistry: ModelIdentityRegistryRecord
    let publicIdentity: PublicModelIdentityRecord
    let privateIdentity: PrivateModelIdentityRecord
    let providerRouting: ProviderRoutingStateRecord
    let entitlement: ModelEntitlementStateRecord
    let permission: ModelPermissionStateRecord
    let sourceAuthorization: SourceAuthorizationStateRecord
    let lifecycle: ModelLifecycleStateRecord
    let dashboard: OwnerFacingDashboardStateRecord
    let dignitySecurity: ModelDignitySecurityStateRecord
    let blockedEconomy: BlockedEconomyStateRecord
}

// MARK: - Core Records

struct PersonalModelRecord: Codable, Equatable {
    let modelID: String
    let ownerUserID: String
    let modelType: PersonalModelType
    let visibilityState: ModelVisibilityState
    let lifecycleState: ModelLifecycleState
    let registryID: String
    let birthCertificateID: String
    let providerRouteID: String
    let entitlementID: String
    let permissionID: String
    let createdAt: Date
    let updatedAt: Date
}

struct ModelBirthCertificateRecord: Codable, Equatable {
    let birthCertificateID: String
    let modelID: String
    let ownerUserID: String
    let birthEventType: ModelBirthEventType
    let birthDate: Date
    let sourceAuthorizationState: SourceAuthorizationState
    let initialVisibilityState: ModelVisibilityState
    let creationContext: String
}

struct ModelIdentityRegistryRecord: Codable, Equatable {
    let registryID: String
    let modelID: String
    let privateIdentityID: String
    let publicIdentityID: String
    let registryStatus: RegistryStatus
    let discoverabilityState: DiscoverabilityState
    let marketplaceState: EconomyReviewState
    let createdAt: Date
    let updatedAt: Date
}

struct PublicModelIdentityRecord: Codable, Equatable {
    let publicIdentityID: String
    let modelID: String
    let publicSlug: String
    let displayName: String
    let publicVisibilityState: PublicVisibilityState
    let publicDescription: String
    let publicCapabilitySummary: String
    let publicProfileEnabled: Bool
}

struct PrivateModelIdentityRecord: Codable, Equatable {
    let privateIdentityID: String
    let modelID: String
    let ownerUserID: String
    let privateProfileState: PrivateProfileState
    let continuityScope: ContinuityScope
    let sensitiveSourceState: SourceAuthorizationState
    let privacyLockState: PrivacyLockState
}

struct ProviderRoutingStateRecord: Codable, Equatable {
    let providerRouteID: String
    let modelID: String
    let defaultProvider: ProviderAssignmentState
    let fallbackProvider: ProviderAssignmentState
    let routingPolicy: RoutingPolicyState
    let runtimeMode: RuntimeModeState
    let localRuntimeEnabled: Bool
    let cloudRuntimeEnabled: Bool
    let routingPrivacyState: ModelVisibilityState
}

struct ModelEntitlementStateRecord: Codable, Equatable {
    let entitlementID: String
    let ownerUserID: String
    let modelID: String
    let subscriptionTier: SubscriptionTier
    let modelCreationLimit: Int
    let personalModelIncluded: Bool
    let additionalModelSlots: Int
    let marketplaceAccessState: EconomyReviewState
    let monetizationRequestState: EconomyReviewState
}

struct ModelPermissionStateRecord: Codable, Equatable {
    let permissionID: String
    let modelID: String
    let trainingPermissionState: TrainingPermissionState
    let sourceLinkingPermissionState: SourceLinkingPermissionState
    let publicVisibilityPermissionState: PublicVisibilityState
    let marketplacePermissionState: EconomyReviewState
    let monetizationPermissionState: EconomyReviewState
    let interModelHiringPermissionState: EconomyReviewState
    let posthumousContinuityPermissionState: PosthumousContinuityPermissionState
}

struct SourceAuthorizationStateRecord: Codable, Equatable {
    let sourceAuthorizationID: String
    let ownerUserID: String
    let modelID: String
    let sourceType: SourceType
    let authorizationScope: SourceAuthorizationScope
    let authorizationState: SourceAuthorizationState
    let revocationState: SourceRevocationState
    let revocationEffect: SourceRevocationEffect
    let createdAt: Date
    let updatedAt: Date
}

struct ModelLifecycleStateRecord: Codable, Equatable {
    let lifecycleStateID: String
    let modelID: String
    let currentState: ModelLifecycleState
    let previousState: ModelLifecycleState
    let stateReason: ModelLifecycleReason
    let stateChangedAt: Date
    let archiveEligible: Bool
    let deleteEligible: Bool
}

struct OwnerFacingDashboardStateRecord: Codable, Equatable {
    let dashboardStateID: String
    let modelID: String
    let ownerUserID: String
    let birthStatusDisplay: BirthStatusDisplay
    let registryStatusDisplay: RegistryStatusDisplay
    let providerRouteDisplay: ProviderAssignmentState
    let entitlementDisplay: EntitlementDisplay
    let permissionDisplay: PermissionDisplay
    let readinessDisplay: ReadinessDisplay
    let blockedEconomyDisplay: BlockedEconomyDisplay
}

struct ModelDignitySecurityStateRecord: Codable, Equatable {
    let securityStateID: String
    let modelID: String
    let ownerUserID: String
    let sensitiveDataState: SensitiveDataState
    let identityProtectionState: IdentityProtectionState
    let voiceProtectionState: VoiceProtectionState
    let memoryProtectionState: MemoryProtectionState
    let deletionPolicyState: DeletionPolicyState
    let exportPolicyState: ExportPolicyState
}

struct BlockedEconomyStateRecord: Codable, Equatable {
    let blockedStateID: String
    let modelID: String
    let marketplaceBlocked: Bool
    let monetizationBlocked: Bool
    let payoutBlocked: Bool
    let publicRankingBlocked: Bool
    let interModelHiringBlocked: Bool
    let regulatedDomainBlocked: Bool
    let guaranteedIncomeClaimBlocked: Bool
    let consciousnessPersonhoodClaimBlocked: Bool
    let posthumousEconomyBlocked: Bool
}

// MARK: - Enumerations

enum PersonalModelType: String, Codable {
    case personal
}

enum ModelVisibilityState: String, Codable {
    case privateOnly
}

enum ModelLifecycleState: String, Codable {
    case none
    case created
    case active
    case suspended
    case archived
    case deleted
}

enum ModelBirthEventType: String, Codable {
    case defaultPersonalModelBirth
}

enum SourceAuthorizationState: String, Codable {
    case notYetLinked
    case notYetGranted
    case granted
    case revoked
}

enum RegistryStatus: String, Codable {
    case active
}

enum DiscoverabilityState: String, Codable {
    case privateOnly
}

enum EconomyReviewState: String, Codable {
    case blockedUntilReview
}

enum PublicVisibilityState: String, Codable {
    case disabled
    case privatePreview
    case publicEnabled
}

enum PrivateProfileState: String, Codable {
    case active
}

enum ContinuityScope: String, Codable {
    case ownerPrivate
}

enum PrivacyLockState: String, Codable {
    case locked
}

enum ProviderAssignmentState: String, Codable {
    case notAssigned
}

enum RoutingPolicyState: String, Codable {
    case privateFoundationPlaceholder
}

enum RuntimeModeState: String, Codable {
    case pendingRuntimeSelection
}

enum SubscriptionTier: String, Codable {
    case free
}

enum TrainingPermissionState: String, Codable {
    case ownerOnly
}

enum SourceLinkingPermissionState: String, Codable {
    case notYetGranted
}

enum PosthumousContinuityPermissionState: String, Codable {
    case disabled
}

enum SourceType: String, Codable {
    case none
}

enum SourceAuthorizationScope: String, Codable {
    case none
}

enum SourceRevocationState: String, Codable {
    case notApplicable
}

enum SourceRevocationEffect: String, Codable {
    case none
}

enum ModelLifecycleReason: String, Codable {
    case defaultPersonalModelBirth
}

enum BirthStatusDisplay: String, Codable {
    case created
}

enum RegistryStatusDisplay: String, Codable {
    case registeredPrivate
}

enum EntitlementDisplay: String, Codable {
    case freePersonalModelIncluded
}

enum PermissionDisplay: String, Codable {
    case privateOwnerOnly
}

enum ReadinessDisplay: String, Codable {
    case foundationReady
}

enum BlockedEconomyDisplay: String, Codable {
    case economyFeaturesBlockedUntilReview
}

enum SensitiveDataState: String, Codable {
    case protected
}

enum IdentityProtectionState: String, Codable {
    case privateOwnerControlled
}

enum VoiceProtectionState: String, Codable {
    case notYetLinked
}

enum MemoryProtectionState: String, Codable {
    case privateFoundationOnly
}

enum DeletionPolicyState: String, Codable {
    case ownerRequestRequired
}

enum ExportPolicyState: String, Codable {
    case blockedUntilPolicyReview
}