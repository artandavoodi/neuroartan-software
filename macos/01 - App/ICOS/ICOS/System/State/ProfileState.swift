import Foundation
import Combine

final class ProfileState: ObservableObject {
    
    // MARK: - Identity
    @Published var userID: UUID = UUID()
    @Published var displayName: String = "Artan"
    
    // MARK: - Preferences
    @Published var preferredModel: String = "gemma:4b"
    @Published var theme: AppTheme = .dark
    
    // MARK: - Permissions
    @Published var canEditFiles: Bool = true
    @Published var canExecuteCommands: Bool = true
    
}

// MARK: - Theme

enum AppTheme {
    case light
    case dark
}
