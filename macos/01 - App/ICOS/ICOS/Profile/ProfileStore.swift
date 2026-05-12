import Foundation

final class ProfileStore {

    private let fileURL: URL

    init() {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = directory.appendingPathComponent("ICOS", isDirectory: true)

        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        self.fileURL = folder.appendingPathComponent("user_profile.json")
    }

    // MARK: - Save

    func save(_ profile: UserProfile) {
        do {
            let data = try JSONEncoder().encode(profile)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("ProfileStore save error:", error)
        }
    }

    // MARK: - Load

    func load() -> UserProfile? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(UserProfile.self, from: data)
        } catch {
            print("ProfileStore load error:", error)
            return nil
        }
    }
}
