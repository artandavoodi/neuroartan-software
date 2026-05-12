import SwiftUI
import AppKit

// MARK: - Intelligence Module View

struct IntelligenceModuleView: View {
    @ObservedObject var router: AppRouter
    let route: AppRouter.Route

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xl)) {
                if route == .intelligenceDashboard {
                    dashboard
                } else if let module = IntelligenceModuleCatalog.module(for: route) {
                    moduleDetail(module)
                } else {
                    missingModule
                }
            }
            .padding(scaled(ICOSSpacing.xxl))
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.panelBackground
            }
        }
    }

    // MARK: - Dashboard

    private var dashboard: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xl)) {
            header(
                title: "Intelligence",
                subtitle: "Native ICOS runtime modules absorbed into one navigable category."
            )

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: scaled(260)), spacing: scaled(ICOSSpacing.lg), alignment: .top)
                ],
                alignment: .leading,
                spacing: scaled(ICOSSpacing.lg)
            ) {
                ForEach(IntelligenceModuleCatalog.modules) { module in
                    moduleCard(module)
                }
            }
        }
    }

    // MARK: - Detail

    private func moduleDetail(_ module: IntelligenceModule) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xl)) {
            header(title: module.title, subtitle: module.summary)

            ICOSPanel(title: "Capability Surface", subtitle: "This ICOS module is now visible in the native Intelligence category.") {
                VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
                    moduleVisual(module)
                        .frame(height: scaled(ICOSIntelligenceModuleTokens.detailVisualHeight))

                    ICOSWrappingFlowLayout(module.capabilities.map(IntelligenceCapability.init(title:))) { capability in
                        Text(capability.title)
                            .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.capabilityFontSize), weight: .semibold))
                            .foregroundStyle(ICOSColors.textPrimary)
                            .padding(.horizontal, scaled(ICOSSpacing.md))
                            .padding(.vertical, scaled(ICOSSpacing.sm))
                            .background(
                                Capsule(style: .continuous)
                                    .fill(ICOSMaterials.hoverSurface)
                            )
                    }
                }
            }

            ICOSPanel(title: "Runtime Status") {
                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    Circle()
                        .fill(module.status.tint)
                        .frame(
                            width: scaled(ICOSIntelligenceModuleTokens.statusDotSize),
                            height: scaled(ICOSIntelligenceModuleTokens.statusDotSize)
                        )

                    Text(module.status.rawValue)
                        .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.statusFontSize), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Spacer()

                    ICOSButton("All Intelligence", icon: .grid, role: .secondary) {
                        router.navigate(to: .intelligenceDashboard)
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func header(title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: scaled(ICOSSpacing.lg)) {
            ICOSBrandLockup(
                title: title,
                subtitle: "Neuroartan Intelligence Runtime",
                markSize: scaled(ICOSIntelligenceModuleTokens.headerMarkSize)
            )

            Spacer()

            Text(subtitle)
                .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.headerSubtitleFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: scaled(ICOSIntelligenceModuleTokens.headerSubtitleMaxWidth), alignment: .trailing)
        }
    }

    private func moduleCard(_ module: IntelligenceModule) -> some View {
        Button {
            router.navigate(to: module.route)
        } label: {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                moduleVisual(module)
                    .frame(height: scaled(ICOSIntelligenceModuleTokens.cardVisualHeight))

                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    SVGImageView(icon: module.icon)
                        .frame(
                            width: scaled(ICOSIntelligenceModuleTokens.cardIconSize),
                            height: scaled(ICOSIntelligenceModuleTokens.cardIconSize)
                        )

                    Text(module.title)
                        .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.cardTitleFontSize), weight: .semibold))
                        .foregroundStyle(ICOSColors.textPrimary)

                    Spacer()

                    Text(module.status.rawValue)
                        .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.cardStatusFontSize), weight: .semibold))
                        .foregroundStyle(module.status.tint)
                }

                Text(module.summary)
                    .font(.system(size: scaledFont(ICOSIntelligenceModuleTokens.cardSummaryFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
                    .lineLimit(ICOSIntelligenceModuleTokens.cardSummaryLineLimit)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(scaled(ICOSSpacing.lg))
            .frame(maxWidth: .infinity, minHeight: scaled(ICOSIntelligenceModuleTokens.cardMinHeight), alignment: .topLeading)
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(cornerRadius: scaled(ICOSRadius.panel), style: .continuous)
                        .fill(ICOSColors.glassFill)
                }
            }
            .overlay {
                if ICOSMaterials.showsSurfaceBorders {
                    RoundedRectangle(cornerRadius: scaled(ICOSRadius.panel), style: .continuous)
                        .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var missingModule: some View {
        ICOSEmptyState(
            title: "Module Not Registered",
            detail: "This route is not registered in the Intelligence module catalog.",
            icon: .warning
        )
    }

    @ViewBuilder
    private func moduleVisual(_ module: IntelligenceModule) -> some View {
        if let assetName = module.assetName,
           let image = intelligenceAsset(named: assetName) {
            Image(nsImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: scaled(ICOSRadius.surface), style: .continuous))
                .overlay {
                    if ICOSMaterials.showsSurfaceBorders {
                        RoundedRectangle(cornerRadius: scaled(ICOSRadius.surface), style: .continuous)
                            .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)
                    }
                }
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: scaled(ICOSRadius.surface), style: .continuous)
                    .fill(ICOSMaterials.hoverSurface)

                SVGImageView(icon: module.icon)
                    .frame(
                        width: scaled(ICOSIntelligenceModuleTokens.fallbackIconSize),
                        height: scaled(ICOSIntelligenceModuleTokens.fallbackIconSize)
                    )
                    .opacity(ICOSIntelligenceModuleTokens.fallbackIconOpacity)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func intelligenceAsset(named name: String) -> NSImage? {
        if let url = Bundle.main.url(
            forResource: name,
            withExtension: "png",
            subdirectory: "Resources/Assets/Intelligence"
        ) {
            return NSImage(contentsOf: url)
        }

        return Bundle.main.image(forResource: name)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

private struct IntelligenceCapability: Identifiable {
    let id = UUID()
    let title: String
}

// MARK: - Preview

#Preview {
    IntelligenceModuleView(router: AppRouter(), route: .intelligenceDashboard)
        .frame(
            width: ICOSIntelligenceModuleTokens.previewWidth,
            height: ICOSIntelligenceModuleTokens.previewHeight
        )
}
