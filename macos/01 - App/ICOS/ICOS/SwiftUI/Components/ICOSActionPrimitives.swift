import SwiftUI

// MARK: - ICOS Action Primitives
// Company-native shared action and status primitives for ICOS interface surfaces.

struct ICOSActionPill: View {
    let title: String
    let icon: ICOSIcon?
    let isProminent: Bool
    let action: () -> Void

    init(
        _ title: String,
        icon: ICOSIcon? = nil,
        isProminent: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isProminent = isProminent
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: ICOSSpacing.xs) {
                if let icon {
                    SVGImageView(icon: icon)
                        .frame(width: ICOSControlTokens.buttonIconSize, height: ICOSControlTokens.buttonIconSize)
                }

                Text(title)
                    .font(.system(size: ICOSActionPrimitiveTokens.actionPillFontSize, weight: .semibold))
            }
            .foregroundStyle(isProminent ? ICOSColors.textPrimary : ICOSColors.textPrimary)
            .padding(.horizontal, ICOSSpacing.md)
            .padding(.vertical, ICOSSpacing.xs)
            .background(
                Capsule(style: .continuous)
                    .fill(isProminent ? ICOSColors.activeFill : ICOSMaterials.floatingSurface)
            )
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(
                        isProminent ? Color.clear : ICOSMaterials.stroke,
                        lineWidth: isProminent ? 0 : ICOSMaterials.strokeWidth
                    )
            }
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ICOS Status Badge

struct ICOSStatusBadge: View {
    let title: String
    let icon: ICOSIcon?
    let tint: Color

    init(
        _ title: String,
        icon: ICOSIcon? = nil,
        tint: Color = .secondary
    ) {
        self.title = title
        self.icon = icon
        self.tint = tint
    }

    var body: some View {
        HStack(spacing: ICOSSpacing.xs) {
            if let icon {
                SVGImageView(icon: icon)
                    .frame(width: ICOSControlTokens.buttonIconSize, height: ICOSControlTokens.buttonIconSize)
            }

            Text(title)
                .font(.system(size: ICOSActionPrimitiveTokens.statusBadgeFontSize, weight: .semibold))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, ICOSSpacing.sm)
        .padding(.vertical, ICOSSpacing.xs)
        .background(
            Capsule(style: .continuous)
                .fill(tint.opacity(ICOSActionPrimitiveTokens.statusBadgeFillOpacity))
        )
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(tint.opacity(ICOSActionPrimitiveTokens.statusBadgeStrokeOpacity), lineWidth: ICOSMaterials.softStrokeWidth)
        }
    }
}

// MARK: - ICOS Inline Search Field

struct ICOSInlineSearchField: View {
    let placeholder: String
    @Binding var text: String
    let onSubmit: () -> Void

    init(
        _ placeholder: String = "Search",
        text: Binding<String>,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSubmit = onSubmit
    }

    var body: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: .search)
                .frame(width: ICOSControlTokens.buttonIconSize, height: ICOSControlTokens.buttonIconSize)
                .foregroundStyle(ICOSColors.textSecondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: ICOSActionPrimitiveTokens.inlineSearchFontSize, weight: .regular))
                .foregroundStyle(ICOSColors.textPrimary)
                .onSubmit(onSubmit)
        }
        .padding(.horizontal, ICOSControlTokens.fieldHorizontalPadding)
        .frame(height: ICOSControlTokens.fieldHeight)
        .background(
            RoundedRectangle(cornerRadius: ICOSControlTokens.fieldCornerRadius, style: .continuous)
                .fill(ICOSMaterials.floatingSurface)
        )
        .overlay {
            RoundedRectangle(cornerRadius: ICOSControlTokens.fieldCornerRadius, style: .continuous)
                .strokeBorder(ICOSMaterials.stroke, lineWidth: ICOSMaterials.strokeWidth)
        }
    }
}

// MARK: - ICOS Empty State

struct ICOSEmptyState: View {
    let title: String
    let detail: String
    let icon: ICOSIcon

    init(
        title: String,
        detail: String,
        icon: ICOSIcon = .file
    ) {
        self.title = title
        self.detail = detail
        self.icon = icon
    }

    var body: some View {
        VStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: icon)
                .frame(width: ICOSControlTokens.emptyStateIconSize, height: ICOSControlTokens.emptyStateIconSize)
                .foregroundStyle(ICOSColors.textSecondary)

            Text(title)
                .font(.system(size: ICOSActionPrimitiveTokens.emptyStateTitleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            Text(detail)
                .font(.system(size: ICOSActionPrimitiveTokens.emptyStateDetailFontSize, weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(ICOSSpacing.xl)
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: ICOSSpacing.lg) {
        HStack {
            ICOSActionPill("Run", icon: .success, isProminent: true) {}
            ICOSActionPill("Review", icon: .file) {}
            ICOSStatusBadge("Online", icon: .success, tint: .green)
        }

        ICOSInlineSearchField(text: .constant(""))

        ICOSEmptyState(
            title: "No Active Session",
            detail: "Create or select a session to continue.",
            icon: .branch
        )
    }
    .padding(ICOSSpacing.xl)
    .frame(width: ICOSActionPrimitiveTokens.previewWidth)
}
