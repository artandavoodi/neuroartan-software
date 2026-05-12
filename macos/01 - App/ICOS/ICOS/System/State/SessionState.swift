import Foundation
import Combine

// MARK: - Session State

@MainActor
final class SessionState: ObservableObject {
    
    // MARK: - Session Identity
    
    let sessionID: UUID
    let createdAt: Date
    
    // MARK: - Chat Messages
    
    @Published var messages: [ChatMessage] = [] {
        didSet { persist() }
    }
    @Published private(set) var isResponding: Bool = false

    private let store: SessionStore

    init() {
        self.store = SessionStore()
        if let persisted = store.loadActiveSession() {
            self.sessionID = persisted.sessionID
            self.createdAt = persisted.createdAt
            self.messages = persisted.messages
        } else {
            self.sessionID = UUID()
            self.createdAt = Date()
            self.messages = []
            persist()
        }
    }

    init(store: SessionStore) {
        self.store = store

        if let persisted = store.loadActiveSession() {
            self.sessionID = persisted.sessionID
            self.createdAt = persisted.createdAt
            self.messages = persisted.messages
        } else {
            self.sessionID = UUID()
            self.createdAt = Date()
            self.messages = []
            persist()
        }
    }
    
    // MARK: - Derived Output
    
    var currentOutput: String {
        return messages.last(where: { $0.role == .assistant })?.content ?? ""
    }
    
    // MARK: - User Messages
    
    func appendUser(_ text: String) {
        let message = ChatMessage(role: .user, content: text)
        messages.append(message)
        isResponding = true
    }
    
    // MARK: - System Messages
    
    func appendSystem(_ text: String) {
        let message = ChatMessage(role: .system, content: text)
        messages.append(message)
    }
    
    // MARK: - Assistant Messages
    
    func appendAssistant(_ text: String) {
        var cleaned = text

        if let range = cleaned.range(of: "Self-Correction", options: .caseInsensitive) {
            cleaned = String(cleaned[..<range.lowerBound])
        }

        let bannedTokens = ["<turn>", "<|turn|>", "</s>", "<bos>"]
        for token in bannedTokens {
            cleaned = cleaned.replacingOccurrences(of: token, with: "")
        }

        let parts = cleaned.components(separatedBy: "\n")
        let unique = Array(NSOrderedSet(array: parts)) as? [String] ?? parts
        cleaned = unique.joined(separator: "\n")

        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else {
            isResponding = false
            return
        }

        if let last = messages.last, last.role == .assistant, last.content == cleaned {
            isResponding = false
            return
        }

        let message = ChatMessage(role: .assistant, content: cleaned)
        messages.append(message)
        isResponding = false
    }
    
    // MARK: - Submission
    
    func submit(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return
        }

        appendUser(trimmed)
    }

    func cancelResponse() {
        isResponding = false
    }

    // MARK: - Persistence
    
    private func persist() {
        store.saveActiveSession(
            PersistedSession(
                sessionID: sessionID,
                createdAt: createdAt,
                messages: messages
            )
        )
    }
}
