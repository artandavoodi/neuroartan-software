import Foundation

struct PersistedSession: Codable {
    var sessionID: UUID
    var createdAt: Date
    var messages: [ChatMessage]
}

struct SessionSummary: Identifiable, Hashable {
    let id: UUID
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let messageCount: Int
}

final class SessionStore {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let isInMemory: Bool
    private var inMemorySession: PersistedSession?

    convenience init() {
        self.init(inMemory: false, seed: nil)
    }

    init(inMemory: Bool, seed: PersistedSession?) {
        self.isInMemory = inMemory
        self.inMemorySession = seed
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func loadActiveSession() -> PersistedSession? {
        if isInMemory {
            return inMemorySession
        }

        guard FileManager.default.fileExists(atPath: activeSessionURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: activeSessionURL)
            return try decoder.decode(PersistedSession.self, from: data)
        } catch {
            return nil
        }
    }

    func saveActiveSession(_ session: PersistedSession) {
        if isInMemory {
            inMemorySession = session
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: sessionsDirectory,
                withIntermediateDirectories: true
            )
            let data = try encoder.encode(session)
            try data.write(to: activeSessionURL, options: [.atomic])
            try data.write(to: sessionURL(id: session.sessionID), options: [.atomic])
        } catch {
            // Persistence failure must not break live inference.
        }
    }

    func listSessions() -> [SessionSummary] {
        if isInMemory {
            guard let inMemorySession else { return [] }
            return [summary(for: inMemorySession, updatedAt: Date())]
        }

        guard let files = try? FileManager.default.contentsOfDirectory(
            at: sessionsDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return files
            .filter { $0.pathExtension == "json" && $0.lastPathComponent != activeSessionURL.lastPathComponent }
            .compactMap { url -> SessionSummary? in
                guard
                    let data = try? Data(contentsOf: url),
                    let session = try? decoder.decode(PersistedSession.self, from: data)
                else {
                    return nil
                }
                let updatedAt = (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? session.createdAt
                return summary(for: session, updatedAt: updatedAt)
            }
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    func activateSession(id: UUID) -> PersistedSession? {
        if isInMemory {
            return inMemorySession
        }

        let url = sessionURL(id: id)
        guard
            let data = try? Data(contentsOf: url),
            let session = try? decoder.decode(PersistedSession.self, from: data)
        else {
            return nil
        }

        saveActiveSession(session)
        return session
    }

    func clearActiveSession() {
        if isInMemory {
            inMemorySession = nil
            return
        }

        do {
            guard FileManager.default.fileExists(atPath: activeSessionURL.path) else { return }
            try FileManager.default.removeItem(at: activeSessionURL)
        } catch {
            // Clearing chat history must not break live inference.
        }
    }

    private var activeSessionURL: URL {
        sessionsDirectory.appendingPathComponent("active-session.json")
    }

    private func sessionURL(id: UUID) -> URL {
        sessionsDirectory.appendingPathComponent("\(id.uuidString).json")
    }

    private func summary(for session: PersistedSession, updatedAt: Date) -> SessionSummary {
        let title = session.messages.first(where: { $0.role == .user })?.content
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return SessionSummary(
            id: session.sessionID,
            title: title?.isEmpty == false ? title! : "New Chat",
            createdAt: session.createdAt,
            updatedAt: updatedAt,
            messageCount: session.messages.count
        )
    }

    private var sessionsDirectory: URL {
        FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Neuroartan", isDirectory: true)
            .appendingPathComponent("ICOS", isDirectory: true)
            .appendingPathComponent("Sessions", isDirectory: true)
    }
}
