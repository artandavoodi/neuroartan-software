import Foundation
import Combine

final class ProfileState: ObservableObject {

    // MARK: - Private Foundation
    @Published private(set) var personalModelFoundation: PersonalModelFoundation?

    private let personalModelFoundationRegistry = PersonalModelFoundationRegistry.shared

    // MARK: - Identity
    @Published var userID: UUID = UUID()
    @Published var displayName: String = "Artan"

    // MARK: - Preferences
    @Published var preferredModel: String = "gemma:4b"
    @Published var theme: AppTheme = .dark

    // MARK: - Permissions
    @Published var canEditFiles: Bool = true
    @Published var canExecuteCommands: Bool = true

    // MARK: - Lifecycle

    init() {
        ensureDefaultPersonalModelFoundation()
    }

    // MARK: - Personal Model Foundation

    func ensureDefaultPersonalModelFoundation() {
        var profile = UserProfile.default()
        profile.displayName = displayName
        profile.publicDisplayName = displayName
        profile.username = normalizedOwnerIdentifier(from: displayName)
        profile.modelName = preferredModel

        personalModelFoundation = personalModelFoundationRegistry.ensureDefaultPersonalModel(for: profile)
    }

    private func normalizedOwnerIdentifier(from value: String) -> String {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")

        return normalized.isEmpty ? "owner-local" : normalized
    }

}

// MARK: - Theme

enum AppTheme {
    case light
    case dark
}
