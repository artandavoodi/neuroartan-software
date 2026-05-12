import SwiftUI

// MARK: - ICOS Toggle Row

struct ICOSToggleRow: View {
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(
        _ title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }

    var body: some View {
        HStack(alignment: .center, spacing: scaled(ICOSSpacing.md)) {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.toggleTextSpacing)) {
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

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)
                .tint(ICOSColors.textPrimary)
        }
        .padding(.vertical, scaled(ICOSSpacing.md))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
