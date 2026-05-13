import Foundation

// ============================================================
// ICOS · Database Layer
// ============================================================

final class ICOSDatabase {

    // ========================================================
    // Singleton
    // ========================================================

    static let shared = ICOSDatabase()

    // ========================================================
    // Storage Root
    // ========================================================

    private let fileManager = FileManager.default

    private lazy var rootURL: URL = {
        let base = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!

        let root = base.appendingPathComponent(
            "ICOS",
            isDirectory: true
        )

        createDirectoryIfNeeded(root)

        return root
    }()

    // ========================================================
    // Stores
    // ========================================================

    private lazy var conversationStore: URL = {
        let url = rootURL.appendingPathComponent(
            "conversation_memory.json"
        )

        ensureFileExists(url)

        return url
    }()

    private lazy var cognitionStore: URL = {
        let url = rootURL.appendingPathComponent(
            "cognitive_state.json"
        )

        ensureFileExists(url)

        return url
    }()

    private lazy var runtimeStore: URL = {
        let url = rootURL.appendingPathComponent(
            "runtime_state.json"
        )

        ensureFileExists(url)

        return url
    }()

    // ========================================================
    // Init
    // ========================================================

    private init() {
        bootstrap()
    }

    // ========================================================
    // Bootstrap
    // ========================================================

    private func bootstrap() {
        _ = conversationStore
        _ = cognitionStore
        _ = runtimeStore
    }

    // ========================================================
    // Directory Creation
    // ========================================================

    private func createDirectoryIfNeeded(_ url: URL) {
        guard !fileManager.fileExists(atPath: url.path) else {
            return
        }

        try? fileManager.createDirectory(
            at: url,
            withIntermediateDirectories: true
        )
    }

    // ========================================================
    // File Creation
    // ========================================================

    private func ensureFileExists(_ url: URL) {
        guard !fileManager.fileExists(atPath: url.path) else {
            return
        }

        let emptyObject = "{}".data(using: .utf8)

        fileManager.createFile(
            atPath: url.path,
            contents: emptyObject
        )
    }

    // ========================================================
    // Generic Save
    // ========================================================

    func save<T: Encodable>(
        _ object: T,
        to url: URL
    ) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(object)
            try data.write(to: url)
        } catch {
            print("ICOSDatabase save error:", error)
        }
    }

    // ========================================================
    // Generic Load
    // ========================================================

    func load<T: Decodable>(
        from url: URL,
        as type: T.Type
    ) -> T? {
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("ICOSDatabase load error:", error)
            return nil
        }
    }

    // ========================================================
    // Runtime Access
    // ========================================================

    func conversationStoreURL() -> URL {
        conversationStore
    }

    func cognitionStoreURL() -> URL {
        cognitionStore
    }

    func runtimeStoreURL() -> URL {
        runtimeStore
    }
}