import Foundation
import Combine

final class ProfileManager: ObservableObject {

    static let shared = ProfileManager()

    private let store = ProfileStore()
    @Published private(set) var activeProfile: UserProfile

    private init() {
        if let saved = store.load() {
            self.activeProfile = saved
        } else {
            let profile = UserProfile.default()
            self.activeProfile = profile
            store.save(profile)
        }
    }

    // MARK: - Access

    func current() -> UserProfile {
        return activeProfile
    }

    var accountID: String {
        let trimmedAuthID = activeProfile.authUserID.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedAuthID.isEmpty {
            return trimmedAuthID
        }

        return String(activeProfile.id.uuidString.prefix(8))
    }

    // MARK: - Update

    func update(_ mutation: (inout UserProfile) -> Void) {
        var profile = activeProfile
        mutation(&profile)
        profile.updatedAt = Date()

        activeProfile = profile
        store.save(profile)
    }

    // MARK: - Replace

    func setProfile(_ profile: UserProfile) {
        activeProfile = profile
        store.save(profile)
    }
}
