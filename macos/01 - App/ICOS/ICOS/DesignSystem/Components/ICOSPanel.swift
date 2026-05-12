import SwiftUI

// MARK: - ICOS Panel

struct ICOSPanel<Content: View>: View {
    let title: String?
    let subtitle: String?
    let padding: CGFloat
    let content: Content

    init(
        title: String? = nil,
        subtitle: String? = nil,
        padding: CGFloat = ICOSSpacing.lg,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.md) {
            if title != nil || subtitle != nil {
                VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                    if let title {
                        Text(title)
                            .font(ICOSTypography.panelTitle)
                            .foregroundStyle(ICOSColors.textPrimary)
                    }

                    if let subtitle {
                        Text(subtitle)
                            .font(ICOSTypography.body)
                            .foregroundStyle(ICOSColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            content
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(
                cornerRadius: ICOSPanelTokens.cornerRadius,
                style: .continuous
            )
        )
    }
}

// MARK: - ICOS Inset Surface

struct ICOSInsetSurface<Content: View>: View {
    let padding: CGFloat
    let content: Content

    init(
        padding: CGFloat = ICOSSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(
                    cornerRadius: ICOSPanelTokens.insetCornerRadius,
                    style: .continuous
                )
            )
    }
}

// MARK: - ICOS Loading State

struct ICOSLoadingState: View {
    let label: String
    var minHeight: CGFloat = 300

    var body: some View {
        VStack(spacing: ICOSSpacing.md) {
            ProgressView()
                .controlSize(.regular)
                .tint(ICOSColors.textPrimary)

            Text(label)
                .font(ICOSTypography.labelSmall)
                .foregroundStyle(ICOSColors.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
    }
}

// MARK: - ICOS Loading Overlay

struct ICOSLoadingOverlay: View {
    var body: some View {
        ProgressView()
            .controlSize(.small)
            .tint(ICOSColors.textPrimary)
            .padding(ICOSSpacing.sm)
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(
                    cornerRadius: ICOSPanelTokens.insetCornerRadius,
                    style: .continuous
                )
            )
    }
}

// MARK: - ICOS Validation Message

struct ICOSValidationMessage: View {
    let text: String
    var icon: ICOSIcon = .warning

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: ICOSSpacing.xs) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSPanelComponentTokens.validationIconSize,
                    height: ICOSPanelComponentTokens.validationIconSize
                )
                .foregroundStyle(ICOSColors.warning)

            Text(text)
                .font(ICOSTypography.body)
                .foregroundStyle(ICOSColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: ICOSSpacing.lg) {
        ICOSPanel(
            title: "Runtime",
            subtitle: "Token-backed ICOS surface panel."
        ) {
            ICOSInsetSurface {
                Text("Operational surface")
                    .foregroundStyle(ICOSColors.textPrimary)
            }
        }

        ICOSLoadingState(label: "Indexing workspace", minHeight: 120)
        ICOSValidationMessage(text: "Connector credentials are not configured.")
    }
    .padding(ICOSSpacing.xl)
    .frame(width: ICOSPanelComponentTokens.previewWidth)
    .background(ICOSMaterials.workspaceBackground)
}
