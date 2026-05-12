import SwiftUI

// MARK: - ICOS Slider Row

struct ICOSSliderRow: View {
    let title: String
    let subtitle: String?
    @Binding var value: Double
    let range: ClosedRange<Double>

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(
        _ title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        in range: ClosedRange<Double>
    ) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.range = range
    }

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            HStack(alignment: .firstTextBaseline, spacing: scaled(ICOSSpacing.md)) {
                VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.rowLabelVerticalSpacing)) {
                    Text(title)
                        .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .medium))
                        .foregroundStyle(ICOSColors.textPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
                    }
                }

                Spacer(minLength: scaled(ICOSSpacing.md))

                Text(String(format: "%.2f", value))
                    .font(.system(size: scaledFont(ICOSControlTokens.rowValueFontSize), weight: .medium, design: .monospaced))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            Slider(value: $value, in: range)
                .tint(ICOSColors.textPrimary)
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}