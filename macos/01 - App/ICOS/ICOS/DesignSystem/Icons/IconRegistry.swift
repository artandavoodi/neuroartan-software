import Foundation
import SwiftUI

// MARK: - Icon Registry (Semantic Mapping Layer)
// Bridges ICOS semantic icons to website SVG paths

final class IconRegistry {

    static let shared = IconRegistry()
    private init() {}

    // Resolve icon → canonical SVG path (source: website system)
    func resolve(_ icon: ICOSIcon) -> String {
        return icon.path
    }

    // Optional future extension: theme override layer
    func themedResolve(_ icon: ICOSIcon, theme: String? = nil) -> String {
        return resolve(icon)
    }
}