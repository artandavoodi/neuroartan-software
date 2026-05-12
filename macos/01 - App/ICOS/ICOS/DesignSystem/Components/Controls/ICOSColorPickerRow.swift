import SwiftUI
import Combine
#if os(macOS)
import AppKit
#endif

// MARK: - ICOS Color Picker Row

struct ICOSColorPickerRow: View {
    let title: String
    @Binding var text: String
    let fallback: Color

    @Environment(\.icosThemeDensity) private var density

    init(
        _ title: String,
        text: Binding<String>,
        fallback: Color
    ) {
        self.title = title
        self._text = text
        self.fallback = fallback
    }

    var body: some View {
        HStack(alignment: .center, spacing: scaled(ICOSControlTokens.colorControlSpacing)) {
            Text(title)
                .font(.system(size: scaled(ICOSControlTokens.rowTitleFontSize), weight: .medium))
                .foregroundStyle(ICOSColors.textPrimary)

            Spacer(minLength: scaled(ICOSSpacing.md))

            ICOSCircularColorPickerButton(
                selection: Binding(
                    get: { normalizedColor(from: text) ?? fallback },
                    set: { color in
                        text = hexString(from: color)
                    }
                )
            )
            .frame(
                width: scaled(ICOSControlTokens.colorPickerSize),
                height: scaled(ICOSControlTokens.colorPickerSize),
                alignment: .center
            )
        }
        .padding(.vertical, scaled(ICOSSpacing.md))
    }

    private func normalizedColor(from value: String) -> Color? {
        ICOSThemeColorSeed(hex: value)?.color
    }

    private func hexString(from color: Color) -> String {
        guard
            let cgColor = color.cgColor,
            let nsColor = NSColor(cgColor: cgColor)?.usingColorSpace(.sRGB)
        else {
            return ICOSThemeColorSeed.coral.hexString
        }

        return ICOSThemeColorSeed(
            red: Double(nsColor.redComponent),
            green: Double(nsColor.greenComponent),
            blue: Double(nsColor.blueComponent)
        ).hexString
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }
}

// MARK: - ICOS Circular Color Picker Button

#if os(macOS)
private struct ICOSCircularColorPickerButton: View {
    @Binding var selection: Color
    @StateObject private var panelBridge = ICOSColorPanelBridge()

    var body: some View {
        Button {
            panelBridge.present(selection: selection) { color in
                selection = color
            }
        } label: {
            Circle()
                .fill(selection)
                .overlay {
                    Circle()
                        .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Choose color")
    }
}

private final class ICOSColorPanelBridge: NSObject, ObservableObject {
    private var onColorChange: ((Color) -> Void)?

    func present(selection: Color, onColorChange: @escaping (Color) -> Void) {
        self.onColorChange = onColorChange

        let panel = NSColorPanel.shared
        panel.setTarget(self)
        panel.setAction(#selector(colorDidChange(_:)))
        panel.isContinuous = true
        panel.color = NSColor(selection)
        panel.makeKeyAndOrderFront(nil)
    }

    @objc private func colorDidChange(_ sender: NSColorPanel) {
        onColorChange?(Color(sender.color))
    }
}
#endif