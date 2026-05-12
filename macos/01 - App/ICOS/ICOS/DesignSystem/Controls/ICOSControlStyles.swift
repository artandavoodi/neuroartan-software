import SwiftUI

// MARK: - ICOS Primary Button Style

struct ICOSPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(ICOSTypography.labelSmall)
            .foregroundStyle(ICOSColors.textPrimary)
            .padding(.horizontal, ICOSControlTokens.buttonHorizontalPaddingLG)
            .padding(.vertical, ICOSSpacing.sm)
            .scaleEffect(configuration.isPressed ? ICOSControlStyleTokens.pressedScale : ICOSControlStyleTokens.restingScale)
            .opacity(isEnabled ? ICOSControlStyleTokens.enabledOpacity : ICOSControlStyleTokens.primaryDisabledOpacity)
            .animation(ICOSMotion.quick, value: configuration.isPressed)
    }
}

// MARK: - ICOS Secondary Button Style

struct ICOSSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(ICOSTypography.labelSmall)
            .foregroundStyle(configuration.isPressed ? ICOSColors.textPrimary : ICOSColors.textSecondary)
            .padding(.horizontal, ICOSControlTokens.buttonHorizontalPaddingMD)
            .padding(.vertical, ICOSSpacing.sm)
            .scaleEffect(configuration.isPressed ? ICOSControlStyleTokens.pressedScale : ICOSControlStyleTokens.restingScale)
            .opacity(isEnabled ? ICOSControlStyleTokens.enabledOpacity : ICOSControlStyleTokens.secondaryDisabledOpacity)
            .animation(ICOSMotion.quick, value: configuration.isPressed)
    }
}

// MARK: - ICOS Icon Button Style

struct ICOSIconButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? ICOSColors.textPrimary : ICOSColors.textSecondary)
            .padding(ICOSControlStyleTokens.iconButtonPadding)
            .opacity(isEnabled ? ICOSControlStyleTokens.enabledOpacity : ICOSControlStyleTokens.secondaryDisabledOpacity)
            .animation(ICOSMotion.quick, value: configuration.isPressed)
    }
}

// MARK: - Button Style Aliases

extension ButtonStyle where Self == ICOSPrimaryButtonStyle {
    static var icosPrimary: ICOSPrimaryButtonStyle { ICOSPrimaryButtonStyle() }
}

extension ButtonStyle where Self == ICOSSecondaryButtonStyle {
    static var icosSecondary: ICOSSecondaryButtonStyle { ICOSSecondaryButtonStyle() }
}

extension ButtonStyle where Self == ICOSIconButtonStyle {
    static var icosIcon: ICOSIconButtonStyle { ICOSIconButtonStyle() }
}

// MARK: - Surface Modifier

extension View {
    func icosGlassSurface(cornerRadius: CGFloat = ICOSRadius.surface, hover: Bool = false) -> some View {
        modifier(ICOSGlassSurfaceModifier(cornerRadius: cornerRadius, hover: hover))
    }
}

private struct ICOSGlassSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat
    let hover: Bool

    func body(content: Content) -> some View {
        content
            .background(hover ? ICOSMaterials.hoverSurface : Color.clear)
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: ICOSSpacing.md) {
        Button("Save") {}
            .buttonStyle(.icosPrimary)

        Button("Cancel") {}
            .buttonStyle(.icosSecondary)

        Button {
        } label: {
            SVGImageView(icon: .loading)
                .frame(
                    width: ICOSControlStyleTokens.previewIconSize,
                    height: ICOSControlStyleTokens.previewIconSize
                )
        }
        .buttonStyle(.icosIcon)
    }
    .padding(ICOSSpacing.xl)
    .background(ICOSMaterials.workspaceBackground)
}
