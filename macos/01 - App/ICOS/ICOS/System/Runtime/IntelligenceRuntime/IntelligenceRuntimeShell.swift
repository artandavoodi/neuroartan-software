import SwiftUI

// MARK: - Intelligence Runtime Shell

struct IntelligenceRuntimeShell: View {
    @Environment(\.icosTypographyScale) private var typographyScale

    init(appState: Any? = nil) {}

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    var body: some View {
        HStack(spacing: ICOSShellTokens.shellSectionSpacing) {
            intelligenceSidebar

            intelligenceCanvas
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ICOSMaterials.windowBackground)
    }

    // MARK: - Sidebar

    private var intelligenceSidebar: some View {
        VStack(spacing: 0) {
            header

            Divider()
                .background(ICOSMaterials.separator)

            sections

            Spacer()
        }
        .frame(width: scaled(ICOSRuntimeShellTokens.sidebarWidth))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: .thought)
                .frame(
                    width: scaled(ICOSRuntimeShellTokens.headerIconSize),
                    height: scaled(ICOSRuntimeShellTokens.headerIconSize)
                )
                .foregroundStyle(ICOSColors.textSecondary)

            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                Text("Intelligence")
                    .font(.system(size: scaled(ICOSRuntimeShellTokens.headerTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)

                Text("Cognitive Runtime")
                    .font(.system(size: scaled(ICOSRuntimeShellTokens.headerSubtitleFontSize), weight: .medium))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, scaled(ICOSShellTokens.shellSectionSpacing))
        .padding(.vertical, scaled(ICOSSpacing.md))
    }

    // MARK: - Sections

    private var sections: some View {
        ICOSScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                section(
                    title: "Cognition",
                    items: [
                        "Agent Graph",
                        "Memory Engine",
                        "Context Engine",
                        "Reasoning"
                    ]
                )

                section(
                    title: "Systems",
                    items: [
                        "Embeddings",
                        "Retrieval",
                        "Sessions",
                        "Continuity"
                    ]
                )

                section(
                    title: "Workspace",
                    items: [
                        "Thought Stream",
                        "History",
                        "Relations",
                        "Activity"
                    ]
                )
            }
            .padding(scaled(ICOSShellTokens.shellSectionSpacing))
        }
    }

    // MARK: - Canvas

    private var intelligenceCanvas: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: scaled(ICOSRuntimeShellTokens.canvasTopSpacerHeight))

            ZStack {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(cornerRadius: ICOSPanelTokens.cornerRadius, style: .continuous)
                        .fill(ICOSMaterials.elevatedSurface)
                        .overlay {
                            if ICOSMaterials.showsSurfaceBorders {
                                RoundedRectangle(cornerRadius: ICOSPanelTokens.cornerRadius, style: .continuous)
                                    .strokeBorder(
                                        ICOSMaterials.stroke,
                                        lineWidth: ICOSMaterials.strokeWidth
                                    )
                            }
                        }
                }

                VStack(spacing: ICOSSpacing.sm) {
                    SVGImageView(icon: .thought)
                        .frame(
                            width: scaled(ICOSRuntimeShellTokens.heroIconSize),
                            height: scaled(ICOSRuntimeShellTokens.heroIconSize)
                        )
                        .foregroundStyle(ICOSColors.textSecondary)
                        .opacity(ICOSRuntimeShellTokens.heroIconOpacity)

                    Text("Intelligence Runtime")
                        .font(.system(size: scaled(ICOSRuntimeShellTokens.heroTitleFontSize), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Text("Cognitive systems are now modularized.")
                        .font(.system(size: scaled(ICOSRuntimeShellTokens.heroSubtitleFontSize), weight: .regular))
                        .foregroundStyle(ICOSColors.textSecondary)
                }
            }
            .padding(ICOSShellTokens.shellSectionSpacing)
        }
    }

    // MARK: - Utilities

    private func section(
        title: String,
        items: [String]
    ) -> some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
            Text(title.uppercased())
                .font(.system(size: scaled(ICOSRuntimeShellTokens.sectionTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textSecondary)
                .tracking(ICOSRuntimeShellTokens.sectionTitleTracking)

            VStack(spacing: ICOSSpacing.xs) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(.system(size: scaled(ICOSRuntimeShellTokens.sectionItemFontSize), weight: .medium))
                            .foregroundStyle(ICOSColors.textPrimary)

                        Spacer()
                    }
                    .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
                    .padding(.vertical, scaled(ICOSSpacing.xs))
                    .background {
                        if ICOSMaterials.showsLayeredSurfaces {
                            RoundedRectangle(
                                cornerRadius: ICOSControlTokens.fieldCornerRadius,
                                style: .continuous
                            )
                            .fill(ICOSMaterials.floatingSurface)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    IntelligenceRuntimeShell()
        .frame(
            width: ICOSRuntimeShellTokens.previewWidth,
            height: ICOSRuntimeShellTokens.previewHeight
        )
}
