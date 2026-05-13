import SwiftUI

// MARK: - Settings Section Card

struct SettingsSectionCard<Content: View>: View {
    private let title: String
    private let subtitle: String?
    private let icon: ICOSIcon?
    private let content: Content

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(title: String, icon: ICOSIcon, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = nil
        self.icon = icon
        self.content = content()
    }

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.icon = nil
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            header

            content
        }
        .padding(.horizontal, scaled(ICOSSpacing.lg))
        .padding(.vertical, scaled(ICOSSpacing.lg))
        .background {
            RoundedRectangle(cornerRadius: scaled(ICOSRadius.lg), style: .continuous)
                .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.sidebarGlass : ICOSMaterials.windowBackground)
        }
        .overlay {
            RoundedRectangle(cornerRadius: scaled(ICOSRadius.lg), style: .continuous)
                .strokeBorder(ICOSMaterials.separator.opacity(ICOSMaterials.showsPlainSeparators ? 1 : 0), lineWidth: ICOSMaterials.strokeWidth)
        }
    }

    @ViewBuilder
    private var header: some View {
        HStack(alignment: .top, spacing: scaled(ICOSSpacing.sm)) {
            if let icon {
                SVGImageView(icon: icon)
                    .frame(width: scaled(ICOSSpacing.lg), height: scaled(ICOSSpacing.lg))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .padding(.top, scaled(1))
            }

            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.profileNameFontSize), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: scaledFont(ICOSControlTokens.profileMetaFontSize), weight: .medium))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)
        }
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
