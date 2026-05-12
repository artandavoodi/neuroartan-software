import SwiftUI

// MARK: - ICOS Button

struct ICOSButton: View {
    let title: String
    let icon: ICOSIcon?
    let role: ICOSButtonRole
    let action: () -> Void

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(
        _ title: String,
        icon: ICOSIcon? = nil,
        role: ICOSButtonRole = .secondary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.role = role
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                if let icon {
                    SVGImageView(icon: icon)
                        .frame(
                            width: scaled(ICOSControlTokens.buttonIconSize),
                            height: scaled(ICOSControlTokens.buttonIconSize)
                        )
                }

                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.buttonTitleFontSize), weight: .semibold))
                    .lineLimit(ICOSControlTokens.buttonTitleLineLimit)
            }
            .foregroundStyle(role.foregroundColor)
            .padding(.horizontal, scaled(ICOSControlTokens.buttonHorizontalPadding))
            .frame(height: scaled(ICOSControlTokens.buttonHeight))
        }
        .buttonStyle(.borderless)
        .controlSize(.small)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - ICOS Button Role

enum ICOSButtonRole {
    case primary
    case secondary
    case ghost
    case destructive

    var foregroundColor: Color {
        switch self {
        case .primary:
            return ICOSColors.textPrimary
        case .secondary:
            return ICOSColors.textPrimary
        case .ghost:
            return ICOSColors.textSecondary
        case .destructive:
            return ICOSColors.destructive
        }
    }

}
