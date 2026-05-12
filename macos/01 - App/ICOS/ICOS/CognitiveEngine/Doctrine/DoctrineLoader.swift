import Foundation

final class DoctrineLoader {

    static let shared = DoctrineLoader()

    private let doctrineDirectory = "Doctrine"

    private init() {}

    func loadAllDoctrines() -> [String] {
        guard let basePath = Bundle.main.resourcePath else {
            return []
        }

        let rootPath = (basePath as NSString).appendingPathComponent(doctrineDirectory)

        let fileManager = FileManager.default

        // Layered doctrine buckets
        var collected: [String] = []
        var core: [String] = []
        var product: [String] = []
        var safety: [String] = []
        var response: [String] = []

        guard fileManager.fileExists(atPath: rootPath) else {
            return []
        }

        // Load order from Doctrine Loading Order
        let orderFile = (rootPath as NSString).appendingPathComponent("00 - Index/01 - Doctrine Loading Order.md")

        guard let orderContent = try? String(contentsOfFile: orderFile, encoding: .utf8) else {
            return []
        }

        // Extract .md paths from loading order
        let lines = orderContent.components(separatedBy: .newlines)

        var orderedPaths: [String] = []

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("- ") && trimmed.contains(".md") {
                let path = trimmed.replacingOccurrences(of: "- ", with: "")
                orderedPaths.append(path)
            }
        }

        for relativePath in orderedPaths {
            let fullPath = (rootPath as NSString).appendingPathComponent(relativePath)

            guard let content = try? String(contentsOfFile: fullPath, encoding: .utf8) else {
                continue
            }

            if relativePath.contains("Core") {
                core.append(content)
            } else if relativePath.contains("Product") {
                product.append(content)
            } else if relativePath.contains("Safety") {
                safety.append(content)
            } else if relativePath.contains("Response") {
                response.append(content)
            } else {
                core.append(content)
            }
        }

        collected = core + product + safety + response

        return collected
    }

    func loadCompiledDoctrine() -> String {
        let doctrines = loadAllDoctrines()

        if doctrines.isEmpty {
            return ""
        }

        return doctrines.joined(separator: "\n\n")
    }
}
