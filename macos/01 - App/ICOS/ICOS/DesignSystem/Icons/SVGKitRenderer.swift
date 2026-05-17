import Foundation
import AppKit
import SwiftUI

// MARK: - SVG Runtime Renderer (Production Layer)

final class SVGKitRenderer {

    static let shared = SVGKitRenderer()

    private let fileManager = FileManager.default

    private var imageCache: [String: NSImage] = [:]
    private var missingIconCache = Set<String>()

    private init() {}

    // MARK: - Public API
    func load(icon: ICOSIcon) -> NSImage? {

        guard let iconURL = resolveIconURL(icon: icon) else {
            return missingIconImage(icon: icon)
        }

        let cacheKey = iconURL.path

        if let cachedImage = imageCache[cacheKey] {
            return cachedImage
        }

        guard let data = try? Data(contentsOf: iconURL) else {
            print("[SVGKitRenderer] Failed reading icon: \(iconURL.path)")
            return missingIconImage(icon: icon)
        }

        let image = render(data: data, sourceURL: iconURL)
        imageCache[cacheKey] = image
        return image
    }

    // MARK: - Registry Path Resolution
    private func resolveIconURL(icon: ICOSIcon) -> URL? {

        let normalizedPath = normalizeIconPath(icon.path)
        let normalizedResourceName = normalizeIconPath(icon.resourceName)
        let iconRootURLs = iconRootCandidates()

        let relativeCandidates = [
            normalizedPath,
            normalizedResourceName
        ]

        for rootURL in iconRootURLs {
            for candidate in relativeCandidates {
                let url = rootURL.appendingPathComponent(candidate)

                if fileManager.fileExists(atPath: url.path) {
                    return url
                }
            }
        }

        logMissingIcon(icon: icon, attemptedPaths: relativeCandidates)
        return nil
    }

    private func normalizeIconPath(_ rawPath: String) -> String {

        var path = rawPath
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if !path.hasSuffix(".svg") {
            path += ".svg"
        }

        return path
    }

    private func iconRootCandidates() -> [URL] {
        [
            URL(fileURLWithPath: "/Users/artan/Documents/Neuroartan/control-center/registry/icons/public/assets"),
            URL(fileURLWithPath: "/Users/artan/Documents/Neuroartan/control-center/registry/icons/source"),
            URL(fileURLWithPath: "/Users/artan/Documents/Neuroartan/website/docs/registry/icons/public/assets"),
            URL(fileURLWithPath: "/Users/artan/Documents/Neuroartan/website/docs/assets/icons/system")
        ]
    }

    // MARK: - SVG Rendering
    private func render(data: Data, sourceURL: URL) -> NSImage {

        if let image = NSImage(contentsOf: sourceURL), image.isValid {
            image.isTemplate = true
            return image
        }

        if let image = NSImage(data: data), image.isValid {
            image.isTemplate = true
            return image
        }

        print("[SVGKitRenderer] Failed rendering icon: \(sourceURL.path)")
        return neutralFallbackImage()
    }

    // MARK: - Diagnostics
    private func logMissingIcon(icon: ICOSIcon, attemptedPaths: [String]) {

        let key = "\(icon.resourceName)|\(icon.path)"

        guard !missingIconCache.contains(key) else {
            return
        }

        missingIconCache.insert(key)

        print("[SVGKitRenderer] Missing icon resource for: \(icon.resourceName)")
        print("[SVGKitRenderer] ICOSIcon.path: \(icon.path)")
        print("[SVGKitRenderer] Icon roots:")
        iconRootCandidates().forEach { rootURL in
            print("  - \(rootURL.path)")
        }
        print("[SVGKitRenderer] Attempted paths:")

        attemptedPaths.forEach { path in
            print("  - \(path)")
        }
    }

    // MARK: - Fallbacks
    private func missingIconImage(icon: ICOSIcon) -> NSImage {
        neutralFallbackImage()
    }

    private func neutralFallbackImage() -> NSImage {

        let image = NSImage(size: NSSize(width: 24, height: 24))

        image.lockFocus()

        NSColor.clear.setFill()
        NSRect(x: 0, y: 0, width: 24, height: 24).fill()

        let rect = NSRect(x: 6, y: 6, width: 12, height: 12)
        let path = NSBezierPath(roundedRect: rect, xRadius: 3, yRadius: 3)

        NSColor.secondaryLabelColor.setStroke()
        path.lineWidth = 1.5
        path.stroke()

        image.unlockFocus()
        image.isTemplate = true

        return image
    }
}
