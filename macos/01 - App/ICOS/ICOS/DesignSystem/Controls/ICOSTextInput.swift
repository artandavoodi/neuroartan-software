import SwiftUI

// MARK: - ICOS Text Input

struct ICOSTextInput: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var validationMessage: String?
    var showBorder: Bool = true
    var compact: Bool = false

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(
        _ title: String,
        placeholder: String = "",
        text: Binding<String>,
        validationMessage: String? = nil,
        showBorder: Bool = true,
        compact: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.validationMessage = validationMessage
        self.showBorder = showBorder
        self.compact = compact
    }

    var body: some View {
        if compact {
            compactBody
        } else {
            standardBody
        }
    }

    private var standardBody: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
            Text(title)
                .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .medium))
                .foregroundStyle(ICOSColors.textPrimary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: scaledFont(ICOSControlTokens.textInputFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                .frame(height: scaled(ICOSControlTokens.fieldHeight))
                .overlay(alignment: .bottom) {
                    if showBorder {
                        Rectangle()
                            .fill(validationMessage == nil ? ICOSMaterials.softStroke : ICOSColors.warning)
                            .frame(height: validationMessage == nil ? ICOSMaterials.softStrokeWidth : ICOSMaterials.strokeWidth)
                    }
                }

            if let validationMessage {
                Text(validationMessage)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.warning)
            }
        }
    }

    private var compactBody: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .font(.system(size: scaledFont(ICOSControlTokens.textInputFontSize), weight: .regular))
            .foregroundStyle(ICOSColors.textPrimary)
            .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
            .frame(height: scaled(ICOSControlTokens.fieldHeight))
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - Preview

#Preview {
    ICOSTextInput(
        "Accent Hex",
        placeholder: "#C65A43",
        text: .constant("#C65A43")
    )
    .padding(ICOSControlTokens.previewPadding)
    .background(ICOSMaterials.workspaceBackground)
}
