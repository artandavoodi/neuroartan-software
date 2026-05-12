import Foundation

struct MemoryEntry: Codable, Identifiable, Hashable {
    enum Kind: String, Codable {
        case preference
        case profileFact
        case correction
        case projectContext
    }

    let id: UUID
    var kind: Kind
    var content: String
    var tags: [String]
    var weight: Double
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        kind: Kind,
        content: String,
        tags: [String] = [],
        weight: Double = 1.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.kind = kind
        self.content = content
        self.tags = tags
        self.weight = weight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
