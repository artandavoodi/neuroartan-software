import SwiftUI

// MARK: - ICOS Theme Color Seed

struct ICOSThemeColorSeed: Equatable, Sendable {
    let red: Double
    let green: Double
    let blue: Double

    static let coral = ICOSThemeColorSeed(red: 0.776, green: 0.353, blue: 0.263)

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }

    init(red: Double, green: Double, blue: Double) {
        self.red = Self.clamp(red)
        self.green = Self.clamp(green)
        self.blue = Self.clamp(blue)
    }

    init?(hex: String) {
        let normalized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        guard normalized.count == 6,
              let value = UInt64(normalized, radix: 16)
        else {
            return nil
        }

        self.red = Double((value & 0xFF0000) >> 16) / 255.0
        self.green = Double((value & 0x00FF00) >> 8) / 255.0
        self.blue = Double(value & 0x0000FF) / 255.0
    }

    var hexString: String {
        let r = Int(Self.clamp(red) * 255.0)
        let g = Int(Self.clamp(green) * 255.0)
        let b = Int(Self.clamp(blue) * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    func adjusted(saturation targetSaturation: Double, brightness targetBrightness: Double) -> ICOSThemeColorSeed {
        let maxComponent = max(red, green, blue)
        let minComponent = min(red, green, blue)
        let delta = maxComponent - minComponent
        let saturation = maxComponent == 0 ? 0 : delta / maxComponent
        let brightness = maxComponent
        let saturationScale = saturation == 0 ? 0 : targetSaturation / saturation
        let brightnessScale = brightness == 0 ? 0 : targetBrightness / brightness

        let adjustedRed = ((red - maxComponent) * saturationScale + maxComponent) * brightnessScale
        let adjustedGreen = ((green - maxComponent) * saturationScale + maxComponent) * brightnessScale
        let adjustedBlue = ((blue - maxComponent) * saturationScale + maxComponent) * brightnessScale

        return ICOSThemeColorSeed(
            red: adjustedRed,
            green: adjustedGreen,
            blue: adjustedBlue
        )
    }

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0.0), 1.0)
    }
}
