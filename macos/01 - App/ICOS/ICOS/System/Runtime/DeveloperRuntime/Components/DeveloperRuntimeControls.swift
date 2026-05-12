import SwiftUI

// MARK: - Developer Runtime Icon Button

struct DeveloperRuntimeIconButton: View {
    let icon: ICOSIcon
    let label: String
    let action: () -> Void

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(
                    width: scaled(ICOSSidebarTokens.iconMD),
                    height: scaled(ICOSSidebarTokens.iconMD)
                )
                .frame(
                    width: scaled(ICOSWindowTokens.titlebarButtonSize),
                    height: scaled(ICOSWindowTokens.titlebarButtonSize)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(ICOSColors.textSecondary)
        .help(label)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Developer Runtime Composer Pill

struct DeveloperRuntimeComposerPill: View {
    let title: String
    let icon: ICOSIcon

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        HStack(spacing: scaled(ICOSControlTokens.gapXS)) {
            SVGImageView(icon: icon)
                .frame(
                    width: scaled(ICOSControlTokens.buttonIconSize),
                    height: scaled(ICOSControlTokens.buttonIconSize)
                )

            Text(title)
                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.composerPillFontSize), weight: .medium))
        }
        .foregroundStyle(ICOSColors.textSecondary)
        .padding(.horizontal, scaled(ICOSControlTokens.buttonHorizontalPaddingSM))
        .frame(height: scaled(ICOSControlTokens.buttonHeightSM))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                Capsule()
                    .fill(ICOSMaterials.elevatedSurface)
            }
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

// MARK: - Developer Runtime Inspector Card

struct DeveloperRuntimeInspectorCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            Text(title)
                .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.inspectorCardTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            content()
        }
        .padding(scaled(ICOSControlTokens.cardPadding))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: scaled(ICOSRadius.card),
                    style: .continuous
                )
                .fill(ICOSMaterials.elevatedSurface)
            }
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

// MARK: - Developer Runtime Inspector Metric

struct DeveloperRuntimeInspectorMetric: View {
    let key: String
    let value: String

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key)
                .foregroundStyle(ICOSColors.textSecondary)

            Spacer(minLength: scaled(ICOSSpacing.md))

            Text(value)
                .foregroundStyle(ICOSColors.textPrimary)
        }
        .font(.system(size: scaledFont(ICOSRuntimeDeveloperTokens.inspectorMetricFontSize), weight: .regular))
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}