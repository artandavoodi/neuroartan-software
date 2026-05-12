import Foundation

/// Central access point for compiled doctrine used in prompt construction.
/// Owns load → compile → cache lifecycle. No business logic here.
final class DoctrineRegistry {

    static let shared = DoctrineRegistry()

    private let loader = DoctrineLoader.shared
    private let compiler = DoctrineCompiler.shared

    private var cachedCompiled: String?
    private let lock = NSLock()

    private init() {}

    /// Returns compiled doctrine string. Cached after first build.
    func compiledDoctrine() -> String {
        lock.lock()
        defer { lock.unlock() }

        if let cached = cachedCompiled {
            return cached
        }

        let raw = loader.loadAllDoctrines()
        let compiled = compiler.compile(raw: raw)

        cachedCompiled = compiled
        return compiled
    }

    /// Force refresh (e.g., during development or after updates)
    func reload() {
        lock.lock()
        defer { lock.unlock() }

        cachedCompiled = nil
    }
}
