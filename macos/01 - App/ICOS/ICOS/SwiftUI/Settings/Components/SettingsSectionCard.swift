import SwiftUI

// MARK: - Settings Section Card

struct SettingsSectionCard<Content: View>: View {
    let title: String
    let icon: ICOSIcon
    @ViewBuilder let content: () -> Content

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                SVGImageView(icon: icon)
                    .frame(
                        width: scaled(ICOSControlTokens.buttonIconSize),
                        height: scaled(ICOSControlTokens.buttonIconSize)
                    )

                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)
            }
            .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))

            VStack(alignment: .leading, spacing: .zero) {
                content()
            }
            .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))
            .padding(.vertical, scaled(ICOSSpacing.md))
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(
                        cornerRadius: scaled(ICOSPanelTokens.cornerRadius),
                        style: .continuous
                    )
                    .fill(ICOSMaterials.sidebarGlass)
                }
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
