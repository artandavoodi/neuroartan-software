import SwiftUI

// MARK: - Developer Review View

struct DeveloperReviewView: View {
    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    private var developer: DeveloperWorkspaceService {
        services.developerWorkspaceService
    }

    var body: some View {
        ICOSScrollView {
            VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.cardSpacing)) {
                SettingsSectionCard(title: "Local Search", icon: .search) {
                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSTextInput(
                            "Search",
                            placeholder: "Search imported workspace",
                            text: Binding(
                                get: { developer.searchQuery },
                                set: { developer.searchQuery = $0 }
                            )
                        )
                        .onSubmit { developer.runSearch() }

                        ICOSButton(
                            developer.isWorking ? "Searching" : "Search",
                            icon: .search
                        ) {
                            developer.runSearch()
                        }
                        .disabled(developer.isWorking)
                    }

                    if developer.searchResults.isEmpty {
                        Text("Search uses the imported local workspace before any external lookup.")
                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMetaFontSize), weight: .regular))
                            .foregroundStyle(ICOSColors.textSecondary)
                    } else {
                        VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.gapSM)) {
                            ForEach(developer.searchResults) { result in
                                VStack(alignment: .leading, spacing: scaled(ICOSDeveloperPanelTokens.reviewResultTextSpacing)) {
                                    Text(result.path)
                                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.reviewPathFontSize), weight: .regular, design: .monospaced))
                                        .foregroundStyle(ICOSColors.textSecondary)
                                        .lineLimit(ICOSControlTokens.rowValueLineLimit)

                                    Text(result.line.map { "Line \($0): \(result.preview)" } ?? result.preview)
                                        .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.reviewPreviewFontSize), weight: .regular))
                                        .foregroundStyle(ICOSColors.textPrimary)
                                        .textSelection(.enabled)
                                }
                                .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    ICOSMaterials.floatingSurface,
                                    in: RoundedRectangle(
                                        cornerRadius: scaled(ICOSRadius.field),
                                        style: .continuous
                                    )
                                )
                                .overlay {
                                    RoundedRectangle(
                                        cornerRadius: scaled(ICOSRadius.field),
                                        style: .continuous
                                    )
                                    .strokeBorder(
                                        ICOSMaterials.softStroke,
                                        lineWidth: ICOSMaterials.softStrokeWidth
                                    )
                                }
                            }
                        }
                    }
                }

                SettingsSectionCard(title: "Repository Review", icon: .branch) {
                    HStack(spacing: scaled(ICOSControlTokens.gapSM)) {
                        ICOSButton("Run Git Status", icon: .branch) {
                            developer.runGitStatus()
                        }

                        Spacer()
                    }

                    if !developer.reviewOutput.isEmpty {
                        Text(developer.reviewOutput)
                            .font(.system(size: scaledFont(ICOSDeveloperPanelTokens.runtimeMonoFontSize), weight: .regular, design: .monospaced))
                            .foregroundStyle(ICOSColors.textSecondary)
                            .textSelection(.enabled)
                            .padding(scaled(ICOSControlTokens.fieldVerticalPadding))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                ICOSMaterials.floatingSurface,
                                in: RoundedRectangle(
                                    cornerRadius: scaled(ICOSRadius.field),
                                    style: .continuous
                                )
                            )
                    }
                }
            }
            .padding(scaled(ICOSDeveloperPanelTokens.reviewPanelPadding))
        }
        .background(ICOSMaterials.workspaceBackground)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
