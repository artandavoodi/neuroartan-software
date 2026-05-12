import SwiftUI
import Combine

/// ICOS Theme Engine
/// Controls global visual theme state for all SwiftUI components
public final class ThemeEngine: ObservableObject {

    // MARK: - Theme State
    @Published public var isDarkMode: Bool = false

    // MARK: - Colors
    public struct Colors {

        public static var primary: Color {
            .primary
        }

        public static var background: Color {
            ThemeEngine.shared.isDarkMode ? Color.black : ICOSColors.background
        }

        public static var secondaryBackground: Color {
            ThemeEngine.shared.isDarkMode ? Color(nsColor: .darkGray) : ICOSColors.surface
        }

        public static var textPrimary: Color {
            ThemeEngine.shared.isDarkMode ? Color.white : Color.primary
        }

        public static var textSecondary: Color {
            ThemeEngine.shared.isDarkMode ? Color.gray : Color.secondary
        }
    }

    // MARK: - Spacing
    public struct Spacing {
        public static let xs: CGFloat = ICOSSpacing.xs
        public static let sm: CGFloat = ICOSSpacing.sm
        public static let md: CGFloat = ICOSSpacing.lg
        public static let lg: CGFloat = ICOSSpacing.xl
        public static let xl: CGFloat = ICOSSpacing.xxl
    }

    // MARK: - Radius
    public struct Radius {
        public static let sm: CGFloat = ICOSRadius.sm
        public static let md: CGFloat = ICOSRadius.md
        public static let lg: CGFloat = ICOSRadius.lg
    }

    // MARK: - Singleton
    public static let shared = ThemeEngine()
    private init() {}

    // MARK: - Theme Toggle
    public func toggleTheme() {
        isDarkMode.toggle()
    }

    /// Aligns legacy `ThemeEngine.Colors` consumers with `ICOSMaterials.mode` after `ThemeState` updates.
    @MainActor
    public func syncFromICOSMaterials() {
        isDarkMode = ICOSMaterials.mode != .light
        objectWillChange.send()
    }
}
