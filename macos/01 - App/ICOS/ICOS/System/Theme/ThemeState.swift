import Foundation
import SwiftUI
import Combine

// MARK: - Theme State

@MainActor
final class ThemeState: ObservableObject {

    @Published var mode: ThemeMode = .default {
        didSet {
            if oldValue == .custom, mode != .custom {
                clearCustomColorOverrides()
            }
            saveAndApplyRuntimeTheme()
        }
    }

    @Published var palette: ICOSThemePalette = .graphite {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var customHexColor: String = ICOSThemeColorSeed.coral.hexString {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var contrast: ICOSThemeContrast = .standard {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var surfaceLayerMode: ICOSSurfaceLayerMode = .layered {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var strokeContrastMode: ICOSStrokeContrastMode = .standard {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var backgroundHexColor: String = "" {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var surfaceHexColor: String = "" {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var density: ICOSLayoutDensity = .comfortable {
        didSet { saveAndApplyRuntimeTheme() }
    }

    @Published var typographyScale: Double = 1.0 {
        didSet { saveAndApplyRuntimeTheme() }
    }

    private var isRestoringTheme = false
    private var systemColorScheme: ColorScheme = .dark

    private enum StorageKey {
        static let mode = "ICOS.Theme.Mode"
        static let palette = "ICOS.Theme.Palette"
        static let customHexColor = "ICOS.Theme.CustomHexColor"
        static let backgroundHexColor = "ICOS.Theme.BackgroundHexColor"
        static let surfaceHexColor = "ICOS.Theme.SurfaceHexColor"
        static let contrast = "ICOS.Theme.Contrast"
        static let surfaceLayerMode = "ICOS.Theme.SurfaceLayerMode"
        static let strokeContrastMode = "ICOS.Theme.StrokeContrastMode"
        static let density = "ICOS.Theme.Density"
        static let typographyScale = "ICOS.Theme.TypographyScale"
    }

    init() {
        load()
        applyRuntimeTheme()
    }

    var colorScheme: ColorScheme? {
        switch mode {
        case .default, .system:
            return systemColorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        case .custom:
            return nil
        }
    }

    var runtimeSignature: String {
        [
            resolvedRuntimeMode.runtimeID,
            (mode == .default ? ICOSThemePalette.company.rawValue : palette.rawValue),
            customHexColor,
            backgroundHexColor,
            surfaceHexColor,
            contrast.rawValue,
            surfaceLayerMode.rawValue,
            strokeContrastMode.rawValue,
            density.rawValue,
            String(format: "%.2f", typographyScale)
        ].joined(separator: "-")
    }

    private var resolvedRuntimeMode: ThemeMode {
        switch mode {
        case .default, .system:
            return systemColorScheme == .light ? .light : .dark
        case .light:
            return .light
        case .dark:
            return .dark
        case .custom:
            return systemColorScheme == .light ? .light : .dark
        }
    }

    func updateSystemColorScheme(_ colorScheme: ColorScheme) {
        systemColorScheme = colorScheme
        guard mode == .system || mode == .default else { return }
        applyRuntimeTheme()
        objectWillChange.send()
    }

    private func clearCustomColorOverrides() {
        backgroundHexColor = ""
        surfaceHexColor = ""
    }

    // MARK: - Runtime Application

    func applyRuntimeTheme() {
        ICOSMaterials.mode = resolvedRuntimeMode
        ICOSMaterials.palette = mode == .default ? .company : palette
        ICOSMaterials.customSeed = mode == .custom ? customThemeSeed : .coral
        ICOSMaterials.backgroundSeed = mode == .custom ? backgroundThemeSeed : nil
        ICOSMaterials.surfaceSeed = mode == .custom ? surfaceThemeSeed : nil
        ICOSMaterials.contrast = contrast
        ICOSMaterials.surfaceLayerMode = surfaceLayerMode
        ICOSMaterials.strokeContrastMode = strokeContrastMode
        ThemeEngine.shared.syncFromICOSMaterials()
        if !isRestoringTheme {
            NotificationCenter.default.post(
                name: .icosMaterialAppearanceDidApply,
                object: runtimeSignature
            )
        }
    }

    func saveAndApplyRuntimeTheme() {
        if isRestoringTheme {
            applyRuntimeTheme()
            return
        }

        save()
        applyRuntimeTheme()
        objectWillChange.send()
    }

    var customThemeSeed: ICOSThemeColorSeed {
        ICOSThemeColorSeed(hex: customHexColor) ?? .coral
    }

    var isCustomHexValid: Bool {
        ICOSThemeColorSeed(hex: customHexColor) != nil
    }

    var backgroundThemeSeed: ICOSThemeColorSeed? {
        ICOSThemeColorSeed(hex: backgroundHexColor)
    }

    var surfaceThemeSeed: ICOSThemeColorSeed? {
        ICOSThemeColorSeed(hex: surfaceHexColor)
    }

    var isBackgroundHexValid: Bool {
        backgroundHexColor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || backgroundThemeSeed != nil
    }

    var isSurfaceHexValid: Bool {
        surfaceHexColor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || surfaceThemeSeed != nil
    }

    private func load() {
        isRestoringTheme = true
        defer { isRestoringTheme = false }

        let defaults = UserDefaults.standard
        if let raw = defaults.string(forKey: StorageKey.mode),
           let value = ThemeMode(rawValue: raw) {
            mode = value
        }
        if let raw = defaults.string(forKey: StorageKey.palette),
           let value = ICOSThemePalette(rawValue: raw) {
            palette = value == .company ? .graphite : value
        }
        if let raw = defaults.string(forKey: StorageKey.contrast),
           let value = ICOSThemeContrast(rawValue: raw) {
            contrast = value
        }
        if let raw = defaults.string(forKey: StorageKey.surfaceLayerMode),
           let value = ICOSSurfaceLayerMode(rawValue: raw) {
            surfaceLayerMode = value
        }
        if let raw = defaults.string(forKey: StorageKey.strokeContrastMode),
           let value = ICOSStrokeContrastMode(rawValue: raw) {
            strokeContrastMode = value
        }
        if let raw = defaults.string(forKey: StorageKey.density),
           let value = ICOSLayoutDensity(rawValue: raw) {
            density = value
        }
        customHexColor = defaults.string(forKey: StorageKey.customHexColor) ?? ICOSThemeColorSeed.coral.hexString
        backgroundHexColor = defaults.string(forKey: StorageKey.backgroundHexColor) ?? ""
        surfaceHexColor = defaults.string(forKey: StorageKey.surfaceHexColor) ?? ""
        let storedTypographyScale = defaults.double(forKey: StorageKey.typographyScale)
        if storedTypographyScale > 0 {
            typographyScale = storedTypographyScale
        }
    }

    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(mode.rawValue, forKey: StorageKey.mode)
        defaults.set(palette.rawValue, forKey: StorageKey.palette)
        defaults.set(customHexColor, forKey: StorageKey.customHexColor)
        defaults.set(backgroundHexColor, forKey: StorageKey.backgroundHexColor)
        defaults.set(surfaceHexColor, forKey: StorageKey.surfaceHexColor)
        defaults.set(contrast.rawValue, forKey: StorageKey.contrast)
        defaults.set(surfaceLayerMode.rawValue, forKey: StorageKey.surfaceLayerMode)
        defaults.set(strokeContrastMode.rawValue, forKey: StorageKey.strokeContrastMode)
        defaults.set(density.rawValue, forKey: StorageKey.density)
        defaults.set(typographyScale, forKey: StorageKey.typographyScale)
        defaults.synchronize()
    }
}

// MARK: - Theme Environment Keys

private struct ICOSThemeDensityKey: EnvironmentKey {
    static let defaultValue: ICOSLayoutDensity = .comfortable
}

private struct ICOSTypographyScaleKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

extension EnvironmentValues {
    var icosThemeDensity: ICOSLayoutDensity {
        get { self[ICOSThemeDensityKey.self] }
        set { self[ICOSThemeDensityKey.self] = newValue }
    }

    var icosTypographyScale: Double {
        get { self[ICOSTypographyScaleKey.self] }
        set { self[ICOSTypographyScaleKey.self] = newValue }
    }
}

// MARK: - Theme Mode Cases

extension ThemeMode: CaseIterable {
    static var allCases: [ThemeMode] {
        [.default, .system, .light, .dark, .custom]
    }
}

extension ThemeMode: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "default": self = .default
        case "system": self = .system
        case "light": self = .light
        case "dark": self = .dark
        case "custom": self = .custom
        default: return nil
        }
    }

    var rawValue: String {
        runtimeID
    }
}

// MARK: - Theme Mode Runtime ID

extension ThemeMode {
    var runtimeID: String {
        switch self {
        case .default:
            return "default"
        case .system:
            return "system"
        case .light:
            return "light"
        case .dark:
            return "dark"
        case .custom:
            return "custom"
        }
    }
}

// MARK: - Theme Palette

enum ICOSThemePalette: String, Identifiable {
    case company
    case graphite
    case slate
    case sand
    case blue
    case coral

    var id: String { rawValue }

    var title: String {
        switch self {
        case .company:
            return "Default"
        case .graphite:
            return "Graphite"
        case .slate:
            return "Slate"
        case .sand:
            return "Sand"
        case .blue:
            return "Blue"
        case .coral:
            return "Coral"
        }
    }
}

extension ICOSThemePalette: CaseIterable {
    static var allCases: [ICOSThemePalette] {
        [.graphite, .slate, .sand, .blue, .coral]
    }
}

// MARK: - Theme Contrast

enum ICOSThemeContrast: String, CaseIterable, Identifiable {
    case standard
    case elevated
    case high

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard:
            return "Standard"
        case .elevated:
            return "Elevated"
        case .high:
            return "High Contrast"
        }
    }
}

// MARK: - Layout Density

enum ICOSLayoutDensity: String, CaseIterable, Identifiable {
    case compact
    case comfortable
    case expanded

    var id: String { rawValue }

    var title: String {
        switch self {
        case .compact:
            return "Compact"
        case .comfortable:
            return "Comfortable"
        case .expanded:
            return "Expanded"
        }
    }

    var spacingScale: CGFloat {
        switch self {
        case .compact:
            return 0.86
        case .comfortable:
            return 1.0
        case .expanded:
            return 1.16
        }
    }
}
