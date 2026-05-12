import Foundation

// MARK: - Chat Message Model (RR-003)

struct ChatMessage: Identifiable, Hashable, Codable {
    
    enum Role: String, Codable {
        case user
        case system
        case assistant
    }
    
    let id: UUID
    let role: Role
    var content: String
    let timestamp: Date
    
    init(role: Role, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
}
