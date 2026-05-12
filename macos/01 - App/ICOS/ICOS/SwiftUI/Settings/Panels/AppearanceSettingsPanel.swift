import SwiftUI

// MARK: - Appearance Settings Panel

struct AppearanceSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @EnvironmentObject var themeEngine: ThemeEngine
    @EnvironmentObject var behaviorEngine: BehaviorEngine
    @EnvironmentObject var themeState: ThemeState

    @AppStorage("ICOS.Developer.Transcript.FontSize") private var transcriptFontSize = 15.5
    @AppStorage("ICOS.Developer.Transcript.LineSpacing") private var transcriptLineSpacing = 6.0
    @AppStorage("ICOS.Developer.Transcript.HorizontalPadding") private var transcriptHorizontalPadding = 3.0
    @AppStorage("ICOS.Developer.Transcript.VerticalPadding") private var transcriptVerticalPadding = 8.0
    @AppStorage("ICOS.Developer.Transcript.InputFontSize") private var transcriptInputFontSize = 15.0
    @AppStorage("ICOS.Developer.Transcript.InputLineSpacing") private var transcriptInputLineSpacing = 5.0

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.xl) {
            themeSection
            displaySection
            sessionTextSection
            shellSection
        }
        .onChange(of: themeState.mode) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.palette) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.customHexColor) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.backgroundHexColor) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.surfaceHexColor) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.contrast) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.surfaceLayerMode) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.strokeContrastMode) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.density) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onChange(of: themeState.typographyScale) { _, _ in
            themeState.saveAndApplyRuntimeTheme()
        }
        .onAppear {
            themeState.applyRuntimeTheme()
        }
    }

    private var themeSection: some View {
        appearanceSectionGroup(title: "Theme") {
            interfacePaletteCard
            colorsPaletteCard
            readabilityPaletteCard
            motionPaletteCard
        }
    }

    private var interfacePaletteCard: some View {
        appearancePaletteCard(title: "Interface") {
            ICOSPickerRow(
                "Mode",
                selection: $themeState.mode,
                options: [
                    ICOSPickerOption(value: ThemeMode.default, title: "Default"),
                    ICOSPickerOption(value: ThemeMode.system, title: "System"),
                    ICOSPickerOption(value: ThemeMode.light, title: "Light"),
                    ICOSPickerOption(value: ThemeMode.dark, title: "Dark"),
                    ICOSPickerOption(value: ThemeMode.custom, title: "Custom")
                ]
            )

            appearanceRowDivider

            if themeState.mode != .default {
                ICOSPickerRow(
                    "Palette",
                    selection: $themeState.palette,
                    options: ICOSThemePalette.allCases.map { palette in
                        ICOSPickerOption(value: palette, title: palette.title)
                    }
                )

                appearanceRowDivider
            }

            ICOSPickerRow(
                "Surface mode",
                selection: $themeState.surfaceLayerMode,
                options: ICOSSurfaceLayerMode.allCases.map { mode in
                    ICOSPickerOption(value: mode, title: mode.title)
                }
            )
        }
    }

    private var colorsPaletteCard: some View {
        appearancePaletteCard(title: "Colors") {
            if themeState.mode == .custom {
                ICOSColorPickerRow(
                    "Background",
                    text: $themeState.backgroundHexColor,
                    fallback: themeState.backgroundThemeSeed?.color ?? ICOSMaterials.windowBackground
                )

                if themeState.surfaceLayerMode == .layered {
                    appearanceRowDivider

                    ICOSColorPickerRow(
                        "Surface",
                        text: $themeState.surfaceHexColor,
                        fallback: themeState.surfaceThemeSeed?.color ?? ICOSMaterials.panelBackground
                    )
                }
            } else {
                Text("Background and surface colors are controlled by the selected theme mode. Choose Custom to edit them.")
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .padding(.vertical, ICOSSpacing.sm)
            }
        }
    }

    private var readabilityPaletteCard: some View {
        appearancePaletteCard(title: "Readability") {
            ICOSPickerRow(
                "Contrast",
                selection: $themeState.contrast,
                options: ICOSThemeContrast.allCases.map { contrast in
                    ICOSPickerOption(value: contrast, title: contrast.title)
                }
            )

            appearanceRowDivider

            ICOSPickerRow(
                "Stroke contrast",
                selection: $themeState.strokeContrastMode,
                options: ICOSStrokeContrastMode.allCases.map { mode in
                    ICOSPickerOption(value: mode, title: mode.title)
                }
            )
        }
    }

    private var motionPaletteCard: some View {
        appearancePaletteCard(title: "Motion") {
            ICOSToggleRow(
                "Motion and animation",
                subtitle: "Enable refined interface motion across the runtime shell.",
                isOn: $behaviorEngine.motionEnabled
            )
        }
    }

    private var displaySection: some View {
        appearanceSectionGroup(title: "Display") {
            appearancePaletteCard {
                ICOSPickerRow(
                    "Layout density",
                    selection: $themeState.density,
                    options: ICOSLayoutDensity.allCases.map { density in
                        ICOSPickerOption(value: density, title: density.title)
                    }
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Typography scale",
                    subtitle: "Scale interface text without breaking layout rhythm.",
                    value: $themeState.typographyScale,
                    in: 0.85...1.25
                )
            }
        }
    }

    private var sessionTextSection: some View {
        appearanceSectionGroup(title: "Session text") {
            appearancePaletteCard {
                sessionTextPreview

                appearanceRowDivider

                ICOSSliderRow(
                    "Transcript size",
                    subtitle: "Adjust the session output text size in Developer.",
                    value: $transcriptFontSize,
                    in: 13.0...20.0
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Transcript line spacing",
                    subtitle: "Control breathing room between output lines.",
                    value: $transcriptLineSpacing,
                    in: 2.0...12.0
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Transcript horizontal margin",
                    subtitle: "Adjust the left and right text padding inside each session message.",
                    value: $transcriptHorizontalPadding,
                    in: 3.0...28.0
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Transcript vertical margin",
                    subtitle: "Adjust the top and bottom text padding inside each session message.",
                    value: $transcriptVerticalPadding,
                    in: 0.0...20.0
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Input size",
                    subtitle: "Adjust the interactive panel input text size.",
                    value: $transcriptInputFontSize,
                    in: 13.0...20.0
                )

                appearanceRowDivider

                ICOSSliderRow(
                    "Input line spacing",
                    subtitle: "Control breathing room while writing longer session input.",
                    value: $transcriptInputLineSpacing,
                    in: 2.0...12.0
                )
            }
        }
    }

    private var shellSection: some View {
        appearanceSectionGroup(title: "Shell") {
            appearancePaletteCard {
                ICOSToggleRow(
                    "Show secondary sidebar",
                    subtitle: "Control the global right contextual sidebar.",
                    isOn: $shellState.isSecondarySidebarVisible
                )

                appearanceRowDivider

                ICOSToggleRow(
                    "Collapse global sidebar",
                    subtitle: "Switch the left navigation rail between compact and expanded states.",
                    isOn: $shellState.isSidebarCollapsed
                )
            }
        }
    }

    private func appearanceSectionGroup<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.md) {
            Text(title)
                .font(.system(size: ICOSAppearanceSettingsTokens.sectionTitleFontSize, weight: .medium))
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .padding(.horizontal, ICOSSidebarTokens.contentHorizontalPadding)

            content()
        }
    }

    private func appearancePaletteCard<Content: View>(
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let title {
                Text(title)
                    .font(.system(size: ICOSAppearanceSettingsTokens.paletteTitleFontSize, weight: .medium))
                    .foregroundStyle(ICOSColors.textPrimary)
                    .padding(.horizontal, ICOSSidebarTokens.contentHorizontalPadding)
                    .padding(.top, ICOSAppearanceSettingsTokens.paletteVerticalPadding)
                    .padding(.bottom, ICOSAppearanceSettingsTokens.paletteTitleBottomPadding)
            }

            VStack(alignment: .leading, spacing: .zero) {
                content()
            }
            .padding(.horizontal, ICOSSidebarTokens.contentHorizontalPadding)
            .padding(.top, title == nil ? ICOSAppearanceSettingsTokens.paletteVerticalPadding : .zero)
            .padding(.bottom, ICOSAppearanceSettingsTokens.paletteVerticalPadding)
        }
        .background {
            if ICOSMaterials.showsSettingsPaletteSurfaces {
                RoundedRectangle(
                    cornerRadius: ICOSPanelTokens.cornerRadius,
                    style: .continuous
                )
                .fill(ICOSMaterials.floatingSurface)
            }
        }
    }

    @ViewBuilder
    private var appearanceRowDivider: some View {
        if ICOSMaterials.showsSettingsRowSeparators {
            Divider()
                .frame(height: ICOSAppearanceSettingsTokens.rowDividerHeight)
                .overlay(ICOSMaterials.separator)
        }
    }

    private var sessionTextPreview: some View {
        VStack(alignment: .leading, spacing: ICOSAppearanceSettingsTokens.sessionPreviewOuterSpacing) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: ICOSAppearanceSettingsTokens.sessionPreviewHeaderSpacing) {
                    Text("Live preview")
                        .font(ICOSTypography.caption)
                        .foregroundStyle(ICOSSidebarColors.textPrimary)

                    Text("Preview the shared session transcript and input rhythm before applying it across ICOS surfaces.")
                        .font(ICOSTypography.caption)
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                }

                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: ICOSAppearanceSettingsTokens.sessionPreviewInnerSpacing) {
                Text("ICOS keeps the session readable, calm, and spatially precise across long-form thinking.\nIt gives every thought enough room to unfold without losing structure, continuity, or focus.")
                    .font(.system(size: CGFloat(transcriptFontSize), weight: .regular))
                    .lineSpacing(CGFloat(transcriptLineSpacing))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .padding(.horizontal, CGFloat(transcriptHorizontalPadding))
                    .padding(.vertical, CGFloat(transcriptVerticalPadding))
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .center, spacing: ICOSAppearanceSettingsTokens.inputPreviewSpacing) {
                    Text("Ask ICOS")
                        .font(.system(size: CGFloat(transcriptInputFontSize), weight: .regular))
                        .lineSpacing(CGFloat(transcriptInputLineSpacing))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    SVGImageView(icon: .send)
                        .frame(width: ICOSMessageTokens.actionIconSize, height: ICOSMessageTokens.actionIconSize)
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                }
                .padding(.horizontal, ICOSSpacing.md)
                .padding(.vertical, ICOSSpacing.sm)
                .background {
                    if ICOSMaterials.showsLayeredSurfaces {
                        RoundedRectangle(cornerRadius: ICOSAppearanceSettingsTokens.inputPreviewCornerRadius, style: .continuous)
                            .fill(ICOSMaterials.solidPanelBackground)
                    }
                }
                .overlay {
                    if ICOSMaterials.showsSurfaceBorders {
                        RoundedRectangle(cornerRadius: ICOSAppearanceSettingsTokens.inputPreviewCornerRadius, style: .continuous)
                            .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)
                    }
                }
            }
            .padding(ICOSSpacing.md)
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(cornerRadius: ICOSAppearanceSettingsTokens.sessionPreviewCornerRadius, style: .continuous)
                        .fill(ICOSMaterials.floatingSurface)
                }
            }
        }
    }
}

private enum ICOSAppearanceSettingsTokens {
    static let sectionTitleFontSize: CGFloat = 12
    static let paletteTitleFontSize: CGFloat = 13
    static let paletteVerticalPadding: CGFloat = ICOSSpacing.md
    static let paletteTitleBottomPadding: CGFloat = ICOSSpacing.sm
    static let rowDividerHeight: CGFloat = 1

    static let sessionPreviewOuterSpacing: CGFloat = ICOSSpacing.md
    static let sessionPreviewHeaderSpacing: CGFloat = ICOSSpacing.xs
    static let sessionPreviewInnerSpacing: CGFloat = ICOSSpacing.md
    static let inputPreviewSpacing: CGFloat = ICOSSpacing.sm
    static let inputPreviewCornerRadius: CGFloat = ICOSRadius.lg
    static let sessionPreviewCornerRadius: CGFloat = ICOSRadius.xl
}
