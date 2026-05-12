import Foundation

struct UserProfile: Codable, Identifiable {
    let id: UUID

    // Account Identity
    var authUserID: String
    var accountEmail: String
    var phoneNumber: String
    var username: String
    var usernameStatus: UsernameStatus
    var accountProvider: AccountProvider

    // Private Identity
    var displayName: String
    var firstName: String
    var lastName: String

    // Public Profile
    var publicDisplayName: String
    var publicBio: String
    var publicProfileEnabled: Bool
    var publicProfileDiscoverable: Bool
    var profileVisibility: ProfileVisibility
    var avatarURL: String
    var headerImageURL: String

    // Model Identity
    var modelName: String
    var modelPrivacy: ModelPrivacy
    var modelSummary: String

    // Cognitive Style
    var tone: ToneProfile
    var responseStyle: ResponseStyle

    // Memory Configuration
    var memoryEnabled: Bool
    var memoryScope: MemoryScope

    // Governance Boundary
    var allowsSelfModification: Bool
    var allowsModelTraining: Bool
    var allowsPublicModelDisplay: Bool

    // Metadata
    var privacyPolicyAcceptedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    var normalizedUsername: String {
        username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    var publicIdentityName: String {
        let publicName = publicDisplayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !publicName.isEmpty { return publicName }
        return displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "User" : displayName
    }

    init(
        id: UUID,
        authUserID: String = "",
        accountEmail: String = "",
        phoneNumber: String = "",
        username: String = "",
        usernameStatus: UsernameStatus = .unreserved,
        accountProvider: AccountProvider = .local,
        displayName: String,
        firstName: String = "",
        lastName: String = "",
        publicDisplayName: String = "",
        publicBio: String = "",
        publicProfileEnabled: Bool = false,
        publicProfileDiscoverable: Bool = false,
        profileVisibility: ProfileVisibility = .private,
        avatarURL: String = "",
        headerImageURL: String = "",
        modelName: String,
        modelPrivacy: ModelPrivacy = .private,
        modelSummary: String = "",
        tone: ToneProfile,
        responseStyle: ResponseStyle,
        memoryEnabled: Bool,
        memoryScope: MemoryScope,
        allowsSelfModification: Bool,
        allowsModelTraining: Bool,
        allowsPublicModelDisplay: Bool = false,
        privacyPolicyAcceptedAt: Date? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.authUserID = authUserID
        self.accountEmail = accountEmail
        self.phoneNumber = phoneNumber
        self.username = username
        self.usernameStatus = usernameStatus
        self.accountProvider = accountProvider
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.publicDisplayName = publicDisplayName
        self.publicBio = publicBio
        self.publicProfileEnabled = publicProfileEnabled
        self.publicProfileDiscoverable = publicProfileDiscoverable
        self.profileVisibility = profileVisibility
        self.avatarURL = avatarURL
        self.headerImageURL = headerImageURL
        self.modelName = modelName
        self.modelPrivacy = modelPrivacy
        self.modelSummary = modelSummary
        self.tone = tone
        self.responseStyle = responseStyle
        self.memoryEnabled = memoryEnabled
        self.memoryScope = memoryScope
        self.allowsSelfModification = allowsSelfModification
        self.allowsModelTraining = allowsModelTraining
        self.allowsPublicModelDisplay = allowsPublicModelDisplay
        self.privacyPolicyAcceptedAt = privacyPolicyAcceptedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fallback = UserProfile.default()

        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? fallback.id
        self.authUserID = try container.decodeIfPresent(String.self, forKey: .authUserID) ?? fallback.authUserID
        self.accountEmail = try container.decodeIfPresent(String.self, forKey: .accountEmail) ?? fallback.accountEmail
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? fallback.phoneNumber
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? fallback.username
        self.usernameStatus = try container.decodeIfPresent(UsernameStatus.self, forKey: .usernameStatus) ?? fallback.usernameStatus
        self.accountProvider = try container.decodeIfPresent(AccountProvider.self, forKey: .accountProvider) ?? fallback.accountProvider
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? fallback.displayName
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? fallback.firstName
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? fallback.lastName
        self.publicDisplayName = try container.decodeIfPresent(String.self, forKey: .publicDisplayName) ?? fallback.publicDisplayName
        self.publicBio = try container.decodeIfPresent(String.self, forKey: .publicBio) ?? fallback.publicBio
        self.publicProfileEnabled = try container.decodeIfPresent(Bool.self, forKey: .publicProfileEnabled) ?? fallback.publicProfileEnabled
        self.publicProfileDiscoverable = try container.decodeIfPresent(Bool.self, forKey: .publicProfileDiscoverable) ?? fallback.publicProfileDiscoverable
        self.profileVisibility = try container.decodeIfPresent(ProfileVisibility.self, forKey: .profileVisibility) ?? fallback.profileVisibility
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? fallback.avatarURL
        self.headerImageURL = try container.decodeIfPresent(String.self, forKey: .headerImageURL) ?? fallback.headerImageURL
        self.modelName = try container.decodeIfPresent(String.self, forKey: .modelName) ?? fallback.modelName
        self.modelPrivacy = try container.decodeIfPresent(ModelPrivacy.self, forKey: .modelPrivacy) ?? fallback.modelPrivacy
        self.modelSummary = try container.decodeIfPresent(String.self, forKey: .modelSummary) ?? fallback.modelSummary
        self.tone = try container.decodeIfPresent(ToneProfile.self, forKey: .tone) ?? fallback.tone
        self.responseStyle = try container.decodeIfPresent(ResponseStyle.self, forKey: .responseStyle) ?? fallback.responseStyle
        self.memoryEnabled = try container.decodeIfPresent(Bool.self, forKey: .memoryEnabled) ?? fallback.memoryEnabled
        self.memoryScope = try container.decodeIfPresent(MemoryScope.self, forKey: .memoryScope) ?? fallback.memoryScope
        self.allowsSelfModification = try container.decodeIfPresent(Bool.self, forKey: .allowsSelfModification) ?? fallback.allowsSelfModification
        self.allowsModelTraining = try container.decodeIfPresent(Bool.self, forKey: .allowsModelTraining) ?? fallback.allowsModelTraining
        self.allowsPublicModelDisplay = try container.decodeIfPresent(Bool.self, forKey: .allowsPublicModelDisplay) ?? fallback.allowsPublicModelDisplay
        self.privacyPolicyAcceptedAt = try container.decodeIfPresent(Date.self, forKey: .privacyPolicyAcceptedAt)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? fallback.createdAt
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? fallback.updatedAt
    }
}

// MARK: - Supporting Models

enum UsernameStatus: String, Codable {
    case unreserved
    case reserved
    case unavailable
}

enum AccountProvider: String, Codable, CaseIterable {
    case local
    case supabase
    case google
    case apple
    case phone
}

enum ProfileVisibility: String, Codable, CaseIterable {
    case `private`
    case accountOnly
    case publicPreview
    case publicSearchable
}

enum ModelPrivacy: String, Codable, CaseIterable {
    case `private`
    case sharedWithAccount
    case publicPreview
    case trainingAuthorized
}

enum ToneProfile: String, Codable {
    case neutral
    case analytical
    case expressive
    case minimal
}

enum ResponseStyle: String, Codable {
    case concise
    case balanced
    case detailed
}

enum MemoryScope: String, Codable {
    case session
    case persistent
    case hybrid
}

// MARK: - Default Factory

extension UserProfile {
    static func `default`() -> UserProfile {
        return UserProfile(
            id: UUID(),
            authUserID: "",
            accountEmail: "",
            phoneNumber: "",
            username: "",
            usernameStatus: .unreserved,
            accountProvider: .local,
            displayName: "User",
            firstName: "",
            lastName: "",
            publicDisplayName: "",
            publicBio: "",
            publicProfileEnabled: false,
            publicProfileDiscoverable: false,
            profileVisibility: .private,
            avatarURL: "",
            headerImageURL: "",
            modelName: "ICOS Model",
            modelPrivacy: .private,
            modelSummary: "Local ICOS runtime model record.",
            tone: .neutral,
            responseStyle: .balanced,
            memoryEnabled: true,
            memoryScope: .hybrid,
            allowsSelfModification: true,
            allowsModelTraining: true,
            allowsPublicModelDisplay: false,
            privacyPolicyAcceptedAt: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
