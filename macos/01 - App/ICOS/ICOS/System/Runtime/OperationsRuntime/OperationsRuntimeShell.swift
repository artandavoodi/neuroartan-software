import SwiftUI

// MARK: - Operations Runtime Shell

struct OperationsRuntimeShell: View {
    @Environment(\.icosTypographyScale) private var typographyScale

    init(appState: Any? = nil) {}

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    var body: some View {
        HStack(spacing: ICOSShellTokens.shellSectionSpacing) {
            operationsSidebar

            operationsCanvas
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ICOSMaterials.windowBackground)
    }

    // MARK: - Sidebar

    private var operationsSidebar: some View {
        VStack(spacing: 0) {
            header

            Divider()
                .background(ICOSMaterials.separator)

            sections

            Spacer()
        }
        .frame(width: ICOSSidebarTokens.runtimeSidebarWidth)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: .branch)
                .frame(width: ICOSSidebarTokens.headerSymbolSize, height: ICOSSidebarTokens.headerSymbolSize)
                .foregroundStyle(ICOSColors.textSecondary)

            VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
                Text("Operations")
                    .font(.system(size: scaled(ICOSRuntimeShellTokens.headerTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)

                Text("Execution Runtime")
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
                    title: "Execution",
                    items: [
                        "Tasks",
                        "Monitoring",
                        "Logs",
                        "Deployment"
                    ]
                )

                section(
                    title: "Infrastructure",
                    items: [
                        "Runtime",
                        "Pipelines",
                        "Agents",
                        "Activity"
                    ]
                )

                section(
                    title: "System",
                    items: [
                        "Health",
                        "Metrics",
                        "Continuity",
                        "Sessions"
                    ]
                )
            }
            .padding(scaled(ICOSShellTokens.shellSectionSpacing))
        }
    }

    // MARK: - Canvas

    private var operationsCanvas: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: scaled(ICOSRuntimeShellTokens.canvasTopSpacerHeight))

            ZStack {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(cornerRadius: ICOSRadius.xl, style: .continuous)
                        .fill(ICOSMaterials.elevatedSurface)
                        .overlay {
                            if ICOSMaterials.showsSurfaceBorders {
                                RoundedRectangle(cornerRadius: ICOSRadius.xl, style: .continuous)
                                    .strokeBorder(
                                        ICOSMaterials.stroke,
                                        lineWidth: ICOSMaterials.strokeWidth
                                    )
                            }
                        }
                }

                VStack(spacing: ICOSSpacing.sm) {
                    SVGImageView(icon: .branch)
                        .frame(width: ICOSSidebarTokens.runtimeHeroIconSize, height: ICOSSidebarTokens.runtimeHeroIconSize)
                        .foregroundStyle(ICOSColors.textSecondary)
                        .opacity(ICOSRuntimeShellTokens.heroIconOpacity)

                    Text("Operations Runtime")
                        .font(.system(size: scaled(ICOSRuntimeShellTokens.heroTitleFontSize), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Text("Operational systems are now modularized.")
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
                                cornerRadius: ICOSRadius.surface,
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
    OperationsRuntimeShell()
        .frame(
            width: ICOSRuntimeShellTokens.previewWidth,
            height: ICOSRuntimeShellTokens.previewHeight
        )
}
