import SwiftUI

extension AccountProvider {
    var title: String {
        switch self {
        case .local: return "Local"
        case .supabase: return "Supabase"
        case .google: return "Google"
        case .apple: return "Apple"
        case .phone: return "Phone"
        }
    }
}

extension ProfileVisibility {
    var title: String {
        switch self {
        case .private: return "Private"
        case .accountOnly: return "Account only"
        case .publicPreview: return "Public preview"
        case .publicSearchable: return "Public searchable"
        }
    }
}

extension ModelPrivacy {
    var title: String {
        switch self {
        case .private: return "Private"
        case .sharedWithAccount: return "Shared with account"
        case .publicPreview: return "Public preview"
        case .trainingAuthorized: return "Training authorized"
        }
    }
}
