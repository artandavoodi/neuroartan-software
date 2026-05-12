import AppKit
import SwiftUI

// MARK: - Surface Layer Mode

enum ICOSSurfaceLayerMode: String, CaseIterable, Identifiable {
    case plain
    case layered

    var id: String { rawValue }

    var title: String {
        switch self {
        case .plain: return "Plain"
        case .layered: return "Layered"
        }
    }
}

// MARK: - Stroke Contrast Mode

enum ICOSStrokeContrastMode: String, CaseIterable, Identifiable {
    case low
    case standard
    case high

    var id: String { rawValue }

    var title: String {
        switch self {
        case .low: return "Low"
        case .standard: return "Standard"
        case .high: return "High"
        }
    }
}

// MARK: - Material System
// Centralized Apple-native material layering.
// No shell view should hardcode material, surface, or color values directly.

enum ICOSMaterials {

    // MARK: - Active Theme

    static var palette: ICOSThemePalette = .company
    static var contrast: ICOSThemeContrast = .standard
    static var surfaceLayerMode: ICOSSurfaceLayerMode = .layered
    static var strokeContrastMode: ICOSStrokeContrastMode = .standard
    static var mode: ThemeMode = .default
    static var customSeed: ICOSThemeColorSeed = .coral
    static var backgroundSeed: ICOSThemeColorSeed?
    static var surfaceSeed: ICOSThemeColorSeed?

    // MARK: - Window

    static var windowBackground: Color { resolvedWindowBackground }
    static var workspaceBackground: Color { resolvedWorkspaceBackground }

    private static var resolvedWindowBackground: Color {
        mode == .custom ? (backgroundSeed?.color ?? theme.windowBackground) : theme.windowBackground
    }

    private static var resolvedWorkspaceBackground: Color {
        mode == .custom ? (backgroundSeed?.color ?? theme.workspaceBackground) : theme.workspaceBackground
    }

    // MARK: - Sidebar

    static var sidebarBackground: Color { usesLayeredSurfaces ? (resolvedSurface ?? theme.sidebarBackground) : resolvedWindowBackground }
    static var sidebarGlass: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(surfaceOpacity) ?? theme.sidebarGlass) : resolvedWindowBackground }

    // MARK: - Panels

    static var panelBackground: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(surfaceOpacity) ?? theme.panelBackground) : resolvedWindowBackground }
    static var solidPanelBackground: Color { usesLayeredSurfaces ? (resolvedSurface ?? theme.panelSurface) : resolvedWindowBackground }
    static var secondarySidebarBackground: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(surfaceOpacity) ?? theme.inspectorBackground) : resolvedWindowBackground }
    static var inspectorBackground: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(surfaceOpacity) ?? theme.inspectorBackground) : resolvedWindowBackground }

    // MARK: - Surface

    static var elevatedSurface: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(0.88) ?? theme.elevatedSurface) : resolvedWindowBackground }
    static var floatingSurface: Color { usesLayeredSurfaces ? (resolvedSurface?.opacity(0.78) ?? theme.floatingSurface) : resolvedWindowBackground }

    // MARK: - Interactive

    static var hoverSurface: Color { usesLayeredSurfaces ? theme.hoverSurface : plainHoverSurface }
    static var pressedSurface: Color { usesLayeredSurfaces ? theme.pressedSurface : plainPressedSurface }

    // MARK: - Overlays

    static var overlayScrim: Color { mode == .light ? Color.black : Color.black }

    // MARK: - Separators

    static var separator: Color { strokeColor(opacity: strokeOpacity(.separator)) }
    static var softSeparator: Color { strokeColor(opacity: strokeOpacity(.softSeparator)) }
    static var stroke: Color { strokeColor(opacity: strokeOpacity(.stroke)) }
    static var softStroke: Color { strokeColor(opacity: strokeOpacity(.softStroke)) }

    // MARK: - Global Surface Behavior

    static var showsLayeredSurfaces: Bool { usesLayeredSurfaces }
    static var showsPlainSeparators: Bool { !usesLayeredSurfaces }
    static var showsSurfaceBorders: Bool { usesLayeredSurfaces }
    static var showsPlainBorders: Bool { !usesLayeredSurfaces }

    // MARK: - Settings Surface Compatibility

    static var showsSettingsPaletteSurfaces: Bool { showsLayeredSurfaces }
    static var showsSettingsRowSeparators: Bool { showsPlainSeparators }

    // MARK: - Stroke Metrics

    static var strokeWidth: CGFloat { strokeWidthValue(.standard) }
    static var softStrokeWidth: CGFloat { strokeWidthValue(.soft) }

    // MARK: - Text

    static var textPrimary: Color { theme.textPrimary }
    static var textSecondary: Color { theme.textSecondary }
    static var textTertiary: Color { theme.textTertiary }

    // MARK: - Theme Resolver

    private static var usesLayeredSurfaces: Bool {
        surfaceLayerMode == .layered
    }

    private enum StrokeRole {
        case separator
        case softSeparator
        case stroke
        case softStroke
    }

    private enum StrokeWidthRole {
        case standard
        case soft
    }

    private static func strokeColor(opacity: Double) -> Color {
        switch mode {
        case .light:
            return Color.black.opacity(opacity)
        case .default, .dark, .system, .custom:
            return Color.white.opacity(opacity)
        }
    }

    private static func strokeOpacity(_ role: StrokeRole) -> Double {
        let base: Double
        switch role {
        case .separator:
            base = usesLayeredSurfaces ? themeSeparatorBase : 0.20
        case .softSeparator:
            base = usesLayeredSurfaces ? themeSoftSeparatorBase : 0.12
        case .stroke:
            base = usesLayeredSurfaces ? themeSeparatorBase : 0.26
        case .softStroke:
            base = usesLayeredSurfaces ? themeSoftSeparatorBase : 0.16
        }

        switch strokeContrastMode {
        case .low:
            return max(base - 0.05, 0.04)
        case .standard:
            return base
        case .high:
            return min(base + 0.12, 1.0)
        }
    }

    private static func strokeWidthValue(_ role: StrokeWidthRole) -> CGFloat {
        switch (role, strokeContrastMode) {
        case (.standard, .low):
            return 0.75
        case (.standard, .standard):
            return 1.0
        case (.standard, .high):
            return 1.5
        case (.soft, .low):
            return 0.5
        case (.soft, .standard):
            return 0.75
        case (.soft, .high):
            return 1.0
        }
    }

    private static var themeSeparatorBase: Double {
        theme.separatorOpacityBase
    }

    private static var themeSoftSeparatorBase: Double {
        theme.softSeparatorOpacityBase
    }

    private static var plainHoverSurface: Color {
        switch mode {
        case .light:
            return Color.black.opacity(strokeOpacity(.softSeparator) * 0.5)
        case .default, .dark, .system, .custom:
            return Color.white.opacity(strokeOpacity(.softSeparator) * 0.55)
        }
    }

    private static var plainPressedSurface: Color {
        switch mode {
        case .light:
            return Color.black.opacity(strokeOpacity(.separator) * 0.5)
        case .default, .dark, .system, .custom:
            return Color.white.opacity(strokeOpacity(.separator) * 0.55)
        }
    }

    private static var theme: ICOSMaterialTheme {
        ICOSMaterialTheme.resolve(mode: mode, palette: palette, contrast: contrast)
    }

    private static var resolvedSurface: Color? {
        guard mode == .custom else { return nil }

        if let surfaceSeed {
            return surfaceSeed.color
        }

        guard let backgroundSeed else { return nil }
        return backgroundSeed.adjusted(saturation: 0.42, brightness: 0.20).color
    }

    private static var surfaceOpacity: Double {
        switch contrast {
        case .standard: return 0.96
        case .elevated: return 0.98
        case .high: return 1.0
        }
    }
}

// MARK: - Material Theme

struct ICOSMaterialTheme {
    let windowBackground: Color
    let workspaceBackground: Color
    let sidebarBackground: Color
    let sidebarGlass: Color
    let panelBackground: Color
    let panelSurface: Color
    let inspectorBackground: Color
    let elevatedSurface: Color
    let floatingSurface: Color
    let hoverSurface: Color
    let pressedSurface: Color
    let separator: Color
    let softSeparator: Color
    let separatorOpacityBase: Double
    let softSeparatorOpacityBase: Double
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color

    static func resolve(mode: ThemeMode, palette: ICOSThemePalette, contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        switch mode {
        case .default:
            return dark(.company, contrast)
        case .system:
            return dark(palette, contrast)
        case .light:
            return light(palette, contrast)
        case .dark:
            return dark(palette, contrast)
        case .custom:
            return dark(palette, contrast)
        }
    }

    // MARK: - Dark Palettes

    private static func dark(_ palette: ICOSThemePalette, _ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        switch palette {
        case .company: return company(contrast)
        case .graphite: return graphite(contrast)
        case .slate: return slate(contrast)
        case .sand: return sand(contrast)
        case .blue: return blue(contrast)
        case .coral: return coral(contrast)
        }
    }

    private static func company(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.569, green: 0.486, blue: 0.435),
            workspaceBackground: Color(red: 0.569, green: 0.486, blue: 0.435),
            sidebarBackground: Color(red: 0.333, green: 0.282, blue: 0.252),
            sidebarGlass: Color(red: 0.376, green: 0.318, blue: 0.286).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.408, green: 0.348, blue: 0.312).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.408, green: 0.348, blue: 0.312),
            inspectorBackground: Color(red: 0.360, green: 0.306, blue: 0.274).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.470, green: 0.400, blue: 0.360).opacity(opacity(0.88, contrast)),
            floatingSurface: Color(red: 0.525, green: 0.450, blue: 0.405).opacity(opacity(0.86, contrast)),
            hoverSurface: Color(red: 0.630, green: 0.545, blue: 0.496).opacity(opacity(0.54, contrast)),
            pressedSurface: Color(red: 0.710, green: 0.620, blue: 0.565).opacity(opacity(0.62, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.18, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.10, contrast)),
            separatorOpacityBase: separatorOpacity(0.18, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.10, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.94, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.68, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.46, contrast))
        )
    }

    private static func graphite(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.028, green: 0.031, blue: 0.035),
            workspaceBackground: Color(red: 0.060, green: 0.067, blue: 0.074),
            sidebarBackground: Color(red: 0.070, green: 0.077, blue: 0.086),
            sidebarGlass: Color(red: 0.075, green: 0.082, blue: 0.092).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.070, green: 0.077, blue: 0.086).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.070, green: 0.077, blue: 0.086),
            inspectorBackground: Color(red: 0.070, green: 0.077, blue: 0.086).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.092, green: 0.101, blue: 0.113).opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.105, green: 0.114, blue: 0.128).opacity(opacity(0.88, contrast)),
            hoverSurface: Color(red: 0.120, green: 0.131, blue: 0.145).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.140, green: 0.152, blue: 0.168).opacity(opacity(0.96, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.10, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.06, contrast)),
            separatorOpacityBase: separatorOpacity(0.10, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.06, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.92, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.62, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.42, contrast))
        )
    }

    private static func slate(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.030, green: 0.035, blue: 0.043),
            workspaceBackground: Color(red: 0.054, green: 0.064, blue: 0.078),
            sidebarBackground: Color(red: 0.062, green: 0.074, blue: 0.090),
            sidebarGlass: Color(red: 0.066, green: 0.079, blue: 0.096).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.062, green: 0.074, blue: 0.090).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.062, green: 0.074, blue: 0.090),
            inspectorBackground: Color(red: 0.062, green: 0.074, blue: 0.090).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.082, green: 0.098, blue: 0.116).opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.095, green: 0.112, blue: 0.132).opacity(opacity(0.88, contrast)),
            hoverSurface: Color(red: 0.112, green: 0.132, blue: 0.154).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.130, green: 0.152, blue: 0.176).opacity(opacity(0.96, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.11, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.065, contrast)),
            separatorOpacityBase: separatorOpacity(0.11, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.065, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.92, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.62, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.42, contrast))
        )
    }

    private static func sand(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.086, green: 0.078, blue: 0.064),
            workspaceBackground: Color(red: 0.122, green: 0.110, blue: 0.092),
            sidebarBackground: Color(red: 0.128, green: 0.116, blue: 0.098),
            sidebarGlass: Color(red: 0.132, green: 0.120, blue: 0.102).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.128, green: 0.116, blue: 0.098).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.128, green: 0.116, blue: 0.098),
            inspectorBackground: Color(red: 0.128, green: 0.116, blue: 0.098).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.154, green: 0.140, blue: 0.118).opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.172, green: 0.156, blue: 0.132).opacity(opacity(0.88, contrast)),
            hoverSurface: Color(red: 0.190, green: 0.172, blue: 0.146).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.210, green: 0.190, blue: 0.162).opacity(opacity(0.96, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.12, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.07, contrast)),
            separatorOpacityBase: separatorOpacity(0.12, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.07, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.92, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.64, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.44, contrast))
        )
    }

    private static func blue(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.026, green: 0.034, blue: 0.048),
            workspaceBackground: Color(red: 0.048, green: 0.064, blue: 0.088),
            sidebarBackground: Color(red: 0.054, green: 0.072, blue: 0.098),
            sidebarGlass: Color(red: 0.058, green: 0.078, blue: 0.106).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.054, green: 0.072, blue: 0.098).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.054, green: 0.072, blue: 0.098),
            inspectorBackground: Color(red: 0.054, green: 0.072, blue: 0.098).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.074, green: 0.096, blue: 0.128).opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.088, green: 0.112, blue: 0.148).opacity(opacity(0.88, contrast)),
            hoverSurface: Color(red: 0.104, green: 0.132, blue: 0.172).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.124, green: 0.154, blue: 0.198).opacity(opacity(0.96, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.11, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.065, contrast)),
            separatorOpacityBase: separatorOpacity(0.11, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.065, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.92, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.62, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.42, contrast))
        )
    }

    private static func coral(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.150, green: 0.078, blue: 0.054),
            workspaceBackground: Color(red: 0.182, green: 0.094, blue: 0.062),
            sidebarBackground: Color(red: 0.205, green: 0.106, blue: 0.072),
            sidebarGlass: Color(red: 0.232, green: 0.122, blue: 0.084).opacity(opacity(0.96, contrast)),
            panelBackground: Color(red: 0.270, green: 0.142, blue: 0.094).opacity(opacity(0.94, contrast)),
            panelSurface: Color(red: 0.270, green: 0.142, blue: 0.094),
            inspectorBackground: Color(red: 0.225, green: 0.118, blue: 0.078).opacity(opacity(0.96, contrast)),
            elevatedSurface: Color(red: 0.332, green: 0.174, blue: 0.112).opacity(opacity(0.88, contrast)),
            floatingSurface: Color(red: 0.392, green: 0.208, blue: 0.132).opacity(opacity(0.86, contrast)),
            hoverSurface: Color(red: 0.470, green: 0.252, blue: 0.160).opacity(opacity(0.54, contrast)),
            pressedSurface: Color(red: 0.545, green: 0.292, blue: 0.186).opacity(opacity(0.62, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.18, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.10, contrast)),
            separatorOpacityBase: separatorOpacity(0.18, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.10, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.94, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.68, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.46, contrast))
        )
    }

    // MARK: - Light Palettes

    private static func light(_ palette: ICOSThemePalette, _ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        switch palette {
        case .company: return lightCompany(contrast)
        case .graphite: return lightGraphite(contrast)
        case .slate: return lightSlate(contrast)
        case .sand: return lightSand(contrast)
        case .blue: return lightBlue(contrast)
        case .coral: return lightCoral(contrast)
        }
    }

    private static func lightCompany(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.569, green: 0.486, blue: 0.435),
            workspaceBackground: Color(red: 0.620, green: 0.535, blue: 0.486),
            sidebarBackground: Color(red: 0.678, green: 0.590, blue: 0.540),
            sidebarGlass: Color.white.opacity(opacity(0.16, contrast)),
            panelBackground: Color(red: 0.720, green: 0.635, blue: 0.585).opacity(opacity(0.90, contrast)),
            panelSurface: Color(red: 0.720, green: 0.635, blue: 0.585),
            inspectorBackground: Color(red: 0.690, green: 0.600, blue: 0.550).opacity(opacity(0.94, contrast)),
            elevatedSurface: Color.white.opacity(opacity(0.18, contrast)),
            floatingSurface: Color.white.opacity(opacity(0.14, contrast)),
            hoverSurface: Color.white.opacity(opacity(0.22, contrast)),
            pressedSurface: Color.white.opacity(opacity(0.30, contrast)),
            separator: Color.white.opacity(separatorOpacity(0.28, contrast)),
            softSeparator: Color.white.opacity(separatorOpacity(0.16, contrast)),
            separatorOpacityBase: separatorOpacity(0.28, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.16, contrast),
            textPrimary: Color.white.opacity(textOpacity(0.95, contrast)),
            textSecondary: Color.white.opacity(textOpacity(0.74, contrast)),
            textTertiary: Color.white.opacity(textOpacity(0.54, contrast))
        )
    }

    private static func lightGraphite(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.955, green: 0.958, blue: 0.962),
            workspaceBackground: Color(red: 0.982, green: 0.984, blue: 0.988),
            sidebarBackground: Color(red: 0.935, green: 0.940, blue: 0.948),
            sidebarGlass: Color(red: 0.940, green: 0.945, blue: 0.952).opacity(opacity(0.98, contrast)),
            panelBackground: Color(red: 0.982, green: 0.984, blue: 0.988).opacity(opacity(0.98, contrast)),
            panelSurface: Color(red: 0.982, green: 0.984, blue: 0.988),
            inspectorBackground: Color(red: 0.952, green: 0.956, blue: 0.964).opacity(opacity(0.98, contrast)),
            elevatedSurface: Color.white.opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.972, green: 0.975, blue: 0.980).opacity(opacity(0.92, contrast)),
            hoverSurface: Color(red: 0.908, green: 0.916, blue: 0.928).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.874, green: 0.884, blue: 0.900).opacity(opacity(0.96, contrast)),
            separator: Color.black.opacity(separatorOpacity(0.10, contrast)),
            softSeparator: Color.black.opacity(separatorOpacity(0.06, contrast)),
            separatorOpacityBase: separatorOpacity(0.10, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.06, contrast),
            textPrimary: Color.black.opacity(textOpacity(0.88, contrast)),
            textSecondary: Color.black.opacity(textOpacity(0.58, contrast)),
            textTertiary: Color.black.opacity(textOpacity(0.38, contrast))
        )
    }

    private static func lightSlate(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.936, green: 0.948, blue: 0.962),
            workspaceBackground: Color(red: 0.972, green: 0.978, blue: 0.986),
            sidebarBackground: Color(red: 0.918, green: 0.932, blue: 0.950),
            sidebarGlass: Color(red: 0.924, green: 0.938, blue: 0.956).opacity(opacity(0.98, contrast)),
            panelBackground: Color(red: 0.972, green: 0.978, blue: 0.986).opacity(opacity(0.98, contrast)),
            panelSurface: Color(red: 0.972, green: 0.978, blue: 0.986),
            inspectorBackground: Color(red: 0.930, green: 0.944, blue: 0.962).opacity(opacity(0.98, contrast)),
            elevatedSurface: Color.white.opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.960, green: 0.968, blue: 0.978).opacity(opacity(0.92, contrast)),
            hoverSurface: Color(red: 0.884, green: 0.902, blue: 0.926).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.846, green: 0.870, blue: 0.900).opacity(opacity(0.96, contrast)),
            separator: Color.black.opacity(separatorOpacity(0.10, contrast)),
            softSeparator: Color.black.opacity(separatorOpacity(0.06, contrast)),
            separatorOpacityBase: separatorOpacity(0.10, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.06, contrast),
            textPrimary: Color.black.opacity(textOpacity(0.88, contrast)),
            textSecondary: Color.black.opacity(textOpacity(0.58, contrast)),
            textTertiary: Color.black.opacity(textOpacity(0.38, contrast))
        )
    }

    private static func lightSand(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.964, green: 0.952, blue: 0.932),
            workspaceBackground: Color(red: 0.990, green: 0.982, blue: 0.966),
            sidebarBackground: Color(red: 0.944, green: 0.928, blue: 0.904),
            sidebarGlass: Color(red: 0.950, green: 0.934, blue: 0.910).opacity(opacity(0.98, contrast)),
            panelBackground: Color(red: 0.990, green: 0.982, blue: 0.966).opacity(opacity(0.98, contrast)),
            panelSurface: Color(red: 0.990, green: 0.982, blue: 0.966),
            inspectorBackground: Color(red: 0.952, green: 0.936, blue: 0.912).opacity(opacity(0.98, contrast)),
            elevatedSurface: Color.white.opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.980, green: 0.968, blue: 0.946).opacity(opacity(0.92, contrast)),
            hoverSurface: Color(red: 0.914, green: 0.892, blue: 0.858).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.880, green: 0.850, blue: 0.810).opacity(opacity(0.96, contrast)),
            separator: Color.black.opacity(separatorOpacity(0.11, contrast)),
            softSeparator: Color.black.opacity(separatorOpacity(0.07, contrast)),
            separatorOpacityBase: separatorOpacity(0.11, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.07, contrast),
            textPrimary: Color.black.opacity(textOpacity(0.88, contrast)),
            textSecondary: Color.black.opacity(textOpacity(0.58, contrast)),
            textTertiary: Color.black.opacity(textOpacity(0.38, contrast))
        )
    }

    private static func lightBlue(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.932, green: 0.948, blue: 0.968),
            workspaceBackground: Color(red: 0.970, green: 0.980, blue: 0.992),
            sidebarBackground: Color(red: 0.908, green: 0.930, blue: 0.958),
            sidebarGlass: Color(red: 0.916, green: 0.938, blue: 0.966).opacity(opacity(0.98, contrast)),
            panelBackground: Color(red: 0.970, green: 0.980, blue: 0.992).opacity(opacity(0.98, contrast)),
            panelSurface: Color(red: 0.970, green: 0.980, blue: 0.992),
            inspectorBackground: Color(red: 0.920, green: 0.942, blue: 0.970).opacity(opacity(0.98, contrast)),
            elevatedSurface: Color.white.opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.958, green: 0.972, blue: 0.990).opacity(opacity(0.92, contrast)),
            hoverSurface: Color(red: 0.872, green: 0.904, blue: 0.946).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.828, green: 0.870, blue: 0.924).opacity(opacity(0.96, contrast)),
            separator: Color.black.opacity(separatorOpacity(0.10, contrast)),
            softSeparator: Color.black.opacity(separatorOpacity(0.06, contrast)),
            separatorOpacityBase: separatorOpacity(0.10, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.06, contrast),
            textPrimary: Color.black.opacity(textOpacity(0.88, contrast)),
            textSecondary: Color.black.opacity(textOpacity(0.58, contrast)),
            textTertiary: Color.black.opacity(textOpacity(0.38, contrast))
        )
    }

    private static func lightCoral(_ contrast: ICOSThemeContrast) -> ICOSMaterialTheme {
        ICOSMaterialTheme(
            windowBackground: Color(red: 0.980, green: 0.905, blue: 0.866),
            workspaceBackground: Color(red: 0.992, green: 0.945, blue: 0.920),
            sidebarBackground: Color(red: 0.972, green: 0.878, blue: 0.830),
            sidebarGlass: Color(red: 0.976, green: 0.888, blue: 0.842).opacity(opacity(0.98, contrast)),
            panelBackground: Color(red: 0.992, green: 0.945, blue: 0.920).opacity(opacity(0.98, contrast)),
            panelSurface: Color(red: 0.992, green: 0.945, blue: 0.920),
            inspectorBackground: Color(red: 0.980, green: 0.900, blue: 0.854).opacity(opacity(0.98, contrast)),
            elevatedSurface: Color(red: 0.960, green: 0.840, blue: 0.790).opacity(opacity(0.86, contrast)),
            floatingSurface: Color(red: 0.940, green: 0.812, blue: 0.750).opacity(opacity(0.92, contrast)),
            hoverSurface: Color(red: 0.900, green: 0.760, blue: 0.690).opacity(opacity(0.92, contrast)),
            pressedSurface: Color(red: 0.858, green: 0.706, blue: 0.628).opacity(opacity(0.96, contrast)),
            separator: Color.black.opacity(separatorOpacity(0.11, contrast)),
            softSeparator: Color.black.opacity(separatorOpacity(0.07, contrast)),
            separatorOpacityBase: separatorOpacity(0.11, contrast),
            softSeparatorOpacityBase: separatorOpacity(0.07, contrast),
            textPrimary: Color.black.opacity(textOpacity(0.88, contrast)),
            textSecondary: Color.black.opacity(textOpacity(0.58, contrast)),
            textTertiary: Color.black.opacity(textOpacity(0.38, contrast))
        )
    }


    // MARK: - Contrast Helpers

    private static func opacity(_ value: Double, _ contrast: ICOSThemeContrast) -> Double {
        switch contrast {
        case .standard: return value
        case .elevated: return min(value + 0.04, 1.0)
        case .high: return 1.0
        }
    }

    private static func separatorOpacity(_ value: Double, _ contrast: ICOSThemeContrast) -> Double {
        switch contrast {
        case .standard: return value
        case .elevated: return value + 0.05
        case .high: return value + 0.12
        }
    }

    private static func textOpacity(_ value: Double, _ contrast: ICOSThemeContrast) -> Double {
        switch contrast {
        case .standard: return value
        case .elevated: return min(value + 0.06, 1.0)
        case .high: return min(value + 0.12, 1.0)
        }
    }
}

// MARK: - Shell Tokens
// Shared shell-level structural constants.

enum ICOSShellTokens {

    // Window
    static let shellPadding: CGFloat = 0
    static let shellOuterPadding: CGFloat = 12
    static let shellSectionSpacing: CGFloat = 8
    static let workspaceRadius: CGFloat = 18
    static let shellRadius: CGFloat = 18

    // Sidebar
    static var sidebarSeparatorWidth: CGFloat { ICOSMaterials.softStrokeWidth }

    // Secondary Sidebar
    static let secondarySidebarWidth: CGFloat = 300
    static let secondarySidebarHorizontalPadding: CGFloat = ICOSSidebarTokens.contentHorizontalPadding
    static let secondarySidebarVerticalPadding: CGFloat = ICOSSpacing.md
    static let secondarySidebarHeaderVerticalPadding: CGFloat = ICOSSpacing.lg
    static let secondarySidebarCardPadding: CGFloat = ICOSSidebarTokens.contentHorizontalPadding
    static let secondarySidebarCardSpacing: CGFloat = ICOSSpacing.md
    static let secondarySidebarToggleTopPadding: CGFloat = ICOSSidebarTokens.inspectorToggleTopPadding
    static let secondarySidebarToggleTrailingPadding: CGFloat = ICOSSidebarTokens.inspectorToggleTrailingPadding
    static let secondarySidebarToggleButtonSize: CGFloat = ICOSSidebarTokens.inspectorToggleButtonSize
    static let secondarySidebarToggleIconSize: CGFloat = ICOSSidebarTokens.inspectorToggleIconSize
    static let secondarySidebarToggleCornerRadius: CGFloat = ICOSSidebarTokens.inspectorToggleCornerRadius

    // Legacy aliases reserved for developer/runtime inspector surfaces.
    static let inspectorWidth: CGFloat = secondarySidebarWidth
    static let inspectorToggleTopPadding: CGFloat = secondarySidebarToggleTopPadding
    static let inspectorToggleTrailingPadding: CGFloat = secondarySidebarToggleTrailingPadding
    static let inspectorToggleButtonSize: CGFloat = secondarySidebarToggleButtonSize
    static let inspectorToggleIconSize: CGFloat = secondarySidebarToggleIconSize
    static let inspectorToggleCornerRadius: CGFloat = secondarySidebarToggleCornerRadius

    // Bottom Panel
    static let bottomPanelHeight: CGFloat = 260
    static let bottomPanelHeaderHeight: CGFloat = 42
    static let bottomPanelHorizontalPadding: CGFloat = ICOSSpacing.lg
    static let bottomPanelVerticalPadding: CGFloat = ICOSSpacing.md
    static let bottomPanelTabSpacing: CGFloat = ICOSSpacing.sm
    static let bottomPanelTabIconSize: CGFloat = ICOSSidebarTokens.iconSM
    static let bottomPanelTransitionDuration: Double = shellVisibilityAnimationDuration

    // Shell Motion
    static let shellVisibilityAnimationDuration: Double = 0.18
}

// MARK: - Window Tokens
// Native macOS titlebar and window-chrome constants.

enum ICOSWindowTokens {
    static let titlebarAccessoryWidth: CGFloat = 128
    static let titlebarAccessoryHeight: CGFloat = 30
    static let titlebarButtonSize: CGFloat = 26
    static let titlebarButtonIconSize: CGFloat = 18
    static let titlebarAccessorySpacing: CGFloat = ICOSSpacing.sm
    static let titlebarAccessoryTrailingPadding: CGFloat = ICOSSpacing.sm
    static let titlebarAccessoryLeadingOffset: CGFloat = 78
    static let titlebarAccessoryTopOffset: CGFloat = 0

    static let titlebarNavigationToolbarWidth: CGFloat = 220
    static let titlebarNavigationAccessoryHeight: CGFloat = 30
    static let titlebarNavigationClusterSpacing: CGFloat = ICOSSpacing.md
    static let titlebarNavigationButtonSpacing: CGFloat = ICOSSpacing.xs
    static let titlebarNavigationButtonClusterWidth: CGFloat = (titlebarNavigationButtonSize * 2) + titlebarNavigationButtonSpacing
    static let titlebarNavigationTitleFontSize: CGFloat = 15
    static let titlebarNavigationIconSize: CGFloat = titlebarButtonIconSize
    static let titlebarNavigationButtonSize: CGFloat = 24
}
