import SwiftUI

// MARK: - Spacing Tokens

enum ICOSSpacing {
    static let unit: CGFloat = 4

    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Scroll Tokens

enum ICOSScrollTokens {
    static let verticalContentTopPadding: CGFloat = 0
    static let verticalContentBottomPadding: CGFloat = 0
    static let horizontalContentLeadingPadding: CGFloat = 0
    static let horizontalContentTrailingPadding: CGFloat = 0
    static let indicatorInsetTop: CGFloat = ICOSSpacing.xxl + ICOSSpacing.xl
    static let indicatorInsetBottom: CGFloat = ICOSSpacing.xxl + ICOSSpacing.xl
    static let indicatorInsetLeading: CGFloat = 0
    static let indicatorInsetTrailing: CGFloat = 0
}

// MARK: - Overlay Tokens

enum ICOSOverlayTokens {
    static let scrimOpacity: Double = 0.35
    static let contentPadding: CGFloat = ICOSSpacing.xl
    static let cornerRadius: CGFloat = ICOSPanelTokens.cornerRadius
    static let modalSpacing: CGFloat = ICOSSpacing.md
}

// MARK: - File Manager Tokens

enum ICOSFileManagerTokens {
    static let emptyIconSize: CGFloat = 32
    static let emptyTitleFontSize: CGFloat = 13
    static let emptySubtitleFontSize: CGFloat = 11
    static let secondaryTextOpacity: Double = 0.72
    static let detailIconSize: CGFloat = 18
    static let detailTitleFontSize: CGFloat = 17
    static let pathFontSize: CGFloat = 12
    static let statusFontSize: CGFloat = 12
    static let sectionTitleFontSize: CGFloat = 12
    static let previewFontSize: CGFloat = 11
    static let previewMinHeight: CGFloat = 260
}

// MARK: - Browser Use Tokens

enum ICOSBrowserUseTokens {
    static let sectionTitleFontSize: CGFloat = 13
    static let statusFontSize: CGFloat = 12
    static let resultTitleFontSize: CGFloat = 13
    static let resultSnippetFontSize: CGFloat = 12
    static let resultURLFontSize: CGFloat = 11
    static let resultURLTextOpacity: Double = 0.72
    static let resultURLLineLimit: Int = 1
}

// MARK: - Panel Tokens

enum ICOSPanelTokens {
    static let cornerRadius: CGFloat = ICOSRadius.md
    static let insetCornerRadius: CGFloat = ICOSRadius.sm
}

// MARK: - Panel Component Tokens

enum ICOSPanelComponentTokens {
    static let validationIconSize: CGFloat = 14
    static let previewWidth: CGFloat = 520
}

// MARK: - Developer Canvas Tokens

enum ICOSDeveloperCanvasTokens {
    static let composerHorizontalPadding: CGFloat = 22
    static let composerBottomPadding: CGFloat = 22
    static let messageSpacing: CGFloat = 12
    static let messageHorizontalPadding: CGFloat = 56
    static let messageTopPadding: CGFloat = 40
    static let messageBottomPadding: CGFloat = 180

    // Thinking Indicator
    static let thinkingDotSpacing: CGFloat = 6
    static let thinkingDotSize: CGFloat = 6
    static let thinkingDotOpacity: Double = 0.6
    static let thinkingDotVisibleOpacity: Double = 1.0
    static let thinkingDotDimOpacity: Double = 0.4
    static let thinkingDotFaintOpacity: Double = 0.3
    static let thinkingDotScaleTiny: CGFloat = 0.6
    static let thinkingDotScaleSmall: CGFloat = 0.7
    static let thinkingDotScaleMedium: CGFloat = 0.8
    static let thinkingDotScaleActive: CGFloat = 1.1
    static let thinkingDotScaleLarge: CGFloat = 1.2
    static let thinkingAnimationDuration: Double = 0.8
    static let thinkingAnimationDelayShort: Double = 0.2
    static let thinkingAnimationDelayLong: Double = 0.4

    // Typing Indicator
    static let typingIndicatorPadding: CGFloat = 10
    static let typingIndicatorHorizontalPadding: CGFloat = ICOSSpacing.md
    static let typingIndicatorCornerRadius: CGFloat = 14
    static let typingDotScaleVisible: CGFloat = 1.0
    static let typingDotScaleResting: CGFloat = 0.5
    static let typingAnimationDuration: Double = 0.6
}

// MARK: - Message Tokens

enum ICOSMessageTokens {
    static let bubbleMaxWidth: CGFloat = 520
    static let messageVerticalSpacing: CGFloat = ICOSSpacing.sm
    static let actionIconSize: CGFloat = 12
    static let actionButtonSize: CGFloat = 24
    static let actionRowSpacing: CGFloat = ICOSSpacing.xs
    static let actionStatusLeadingPadding: CGFloat = ICOSSpacing.xs
    static let actionInactiveFillOpacity: Double = 0
    static let actionButtonCornerRadius: CGFloat = ICOSSidebarTokens.rowCornerRadius
}

// MARK: - Control Style Tokens

enum ICOSControlStyleTokens {
    static let pressedScale: CGFloat = 0.98
    static let restingScale: CGFloat = 1.0
    static let enabledOpacity: Double = 1
    static let primaryDisabledOpacity: Double = 0.45
    static let secondaryDisabledOpacity: Double = 0.4
    static let iconButtonPadding: CGFloat = ICOSSpacing.xs + 2
    static let iconInactiveFillOpacity: Double = 0
    static let previewIconSize: CGFloat = 15
}

// MARK: - Control Tokens

enum ICOSControlTokens {

    // Widths
    static let controlWidthAuthMax: CGFloat = 420
    static let controlWidthAuthMaxWide: CGFloat = 520

    // Shared Gaps
    static let gapXS: CGFloat = ICOSSpacing.xs
    static let gapSM: CGFloat = ICOSSpacing.sm
    static let gapMD: CGFloat = ICOSSpacing.md
    static let gapLG: CGFloat = ICOSSpacing.lg
    static let gapXL: CGFloat = ICOSSpacing.xl

    // Buttons
    static let buttonIconSize: CGFloat = 14
    static let buttonTitleFontSize: CGFloat = 12
    static let buttonTitleLineLimit: Int = 1
    static let buttonHeightSM: CGFloat = 30
    static let buttonHeightMD: CGFloat = 38
    static let buttonHeightLG: CGFloat = 44
    static let buttonHorizontalPaddingSM: CGFloat = ICOSSpacing.md
    static let buttonHorizontalPaddingMD: CGFloat = ICOSSpacing.lg
    static let buttonHorizontalPaddingLG: CGFloat = ICOSSpacing.xl
    static let buttonCornerRadiusSM: CGFloat = ICOSRadius.sm
    static let buttonCornerRadiusMD: CGFloat = ICOSRadius.sm
    static let buttonCornerRadiusLG: CGFloat = ICOSRadius.sm
    static let buttonHoverLiftY: CGFloat = -1
    static let buttonHoverScale: CGFloat = 1.01

    // Legacy Button Aliases
    static let buttonHeight: CGFloat = buttonHeightMD
    static let buttonHorizontalPadding: CGFloat = buttonHorizontalPaddingMD
    static let buttonCornerRadius: CGFloat = buttonCornerRadiusMD

    // Toggles — Apple native macOS dimensions
    static let toggleHeight: CGFloat = 22
    static let toggleWidth: CGFloat = 38
    static let toggleKnobSize: CGFloat = 18
    static let togglePadding: CGFloat = 2
    static let toggleCornerRadius: CGFloat = 11
    static let toggleFocusRingWidth: CGFloat = 2
    static let toggleTextSpacing: CGFloat = 3
    static let toggleDisabledOpacity: Double = 0.42
    static let toggleTransitionDuration: Double = 0.22
    static let toggleThumbShadowOpacity: Double = 0.15
    static let toggleThumbActiveShadowOpacity: Double = 0.10
    static let toggleOffTrackOpacityLight: Double = 0.35
    static let toggleOffTrackOpacityDark: Double = 0.38

    // Pickers
    static let pickerHeight: CGFloat = 34
    static let pickerHorizontalPadding: CGFloat = ICOSSpacing.md
    static let pickerCornerRadius: CGFloat = ICOSRadius.sm

    // Color Pickers
    static let colorControlSpacing: CGFloat = ICOSSpacing.md
    static let colorPickerSize: CGFloat = 24
    static let colorPickerCornerRadius: CGFloat = ICOSRadius.sm

    // Control Rows
    static let rowLabelVerticalSpacing: CGFloat = 3
    static let rowTitleFontSize: CGFloat = 13
    static let rowSubtitleFontSize: CGFloat = 11
    static let rowValueFontSize: CGFloat = 11
    static let rowSubtitleLineLimit: Int = 2
    static let rowValueLineLimit: Int = 1
    static let settingsRowFontSize: CGFloat = 12

    // Settings Shell
    static let settingsCategoryColumnWidth: CGFloat = 240
    static let settingsCategoryIconSize: CGFloat = 16
    static let settingsCategoryTitleFontSize: CGFloat = 12
    static let settingsDetailIconSize: CGFloat = 22
    static let settingsDetailTitleFontSize: CGFloat = 24

    // Worktree Rows
    static let worktreeIconSize: CGFloat = 15
    static let worktreeFontSize: CGFloat = 12

    // Project Rows
    static let projectMetaFontSize: CGFloat = 10
    static let projectPathFontSize: CGFloat = 10

    // Editor Bridge
    static let editorBridgePathFontSize: CGFloat = 10

    // Profile Header
    static let profileHeaderTextSpacing: CGFloat = 2
    static let profileAvatarFontSize: CGFloat = 12
    static let profileNameFontSize: CGFloat = 13
    static let profileMetaFontSize: CGFloat = 11

    // Fields
    static let fieldHeight: CGFloat = 38
    static let fieldHorizontalPadding: CGFloat = ICOSSpacing.md
    static let fieldVerticalPadding: CGFloat = ICOSSpacing.sm
    static let fieldCornerRadius: CGFloat = ICOSRadius.sm
    static let textInputFontSize: CGFloat = 13

    // Cards
    static let cardSpacing: CGFloat = ICOSSpacing.lg
    static let cardPadding: CGFloat = ICOSSpacing.lg
    static let cardCornerRadius: CGFloat = ICOSRadius.sm
    static let emptyStateIconSize: CGFloat = 30

    // Previews
    static let previewPadding: CGFloat = ICOSSpacing.xl

    // Account/Auth Controls
    static let accountControlWidthMax: CGFloat = controlWidthAuthMax
    static let accountControlWidthMaxWide: CGFloat = controlWidthAuthMaxWide
    static let accountButtonHeight: CGFloat = buttonHeightMD
    static let accountButtonRadius: CGFloat = buttonCornerRadiusMD
    static let accountButtonPaddingX: CGFloat = buttonHorizontalPaddingLG
    static let accountFieldHeight: CGFloat = fieldHeight
    static let accountFieldRadius: CGFloat = fieldCornerRadius
    static let accountFieldPaddingX: CGFloat = fieldHorizontalPadding
    static let accountProviderButtonHeight: CGFloat = accountButtonHeight
    static let accountProviderButtonRadius: CGFloat = accountButtonRadius
    static let accountProviderButtonPaddingX: CGFloat = accountButtonPaddingX
    static let accountBackControlSize: CGFloat = 20
    static let accountBackIconSize: CGFloat = 18
}

// MARK: - Radius Tokens

enum ICOSRadius {
    static let none: CGFloat = 0
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 22
    static let xl: CGFloat = 28
    static let xxl: CGFloat = 34
    static let dialog: CGFloat = 30
    static let pill: CGFloat = 999
    static let control: CGFloat = ICOSControlTokens.buttonCornerRadius
    static let card: CGFloat = ICOSControlTokens.cardCornerRadius
    static let field: CGFloat = ICOSControlTokens.fieldCornerRadius
    static let panel: CGFloat = ICOSRadius.sm
    static let surface: CGFloat = ICOSRadius.sm
}

// MARK: - Sidebar Layout Tokens

enum ICOSSidebarTokens {

    // Widths
    static let collapsedWidth: CGFloat = 64
    static let expandedWidth: CGFloat = 260
    static let legacySidebarExpandedWidth: CGFloat = 420
    static let contentPanelWidth: CGFloat = 176
    static let workspacePanelWidth: CGFloat = 180
    static let runtimeSidebarWidth: CGFloat = 260
    static let runtimeCanvasPadding: CGFloat = 20
    static let runtimeHeroIconSize: CGFloat = 48
    static let environmentPreviewWidth: CGFloat = 220
    static let headerSymbolSize: CGFloat = 22
    static let headerPreviewWidth: CGFloat = 260
    static let searchPreviewWidth: CGFloat = 240
    static let statusDotSize: CGFloat = 7
    static let footerSeparatorHorizontalPadding: CGFloat = 16
    static let footerHorizontalPadding: CGFloat = 16
    static let footerBottomPadding: CGFloat = 12
    static let footerPreviewWidth: CGFloat = 240
    static let footerPreviewHeight: CGFloat = 180
    static let previewHeight: CGFloat = 760
    static let sidebarContainerRadius: CGFloat = ICOSRadius.sm
    static let sidebarOuterVerticalPadding: CGFloat = 0
    static let sidebarOuterLeadingPadding: CGFloat = 0
    static let sidebarOuterTrailingPadding: CGFloat = 0
    static let trafficLightOffsetPadding: CGFloat = 18
    static let sectionTitlePreviewSpacing: CGFloat = 14
    static let itemTitleFont: Font = .system(size: 13, weight: .medium)
    static let itemSubtitleFont: Font = .system(size: 11, weight: .regular)
    static let sectionTitleFont: Font = .system(size: 11, weight: .semibold)
    static let secondaryIconOpacity: Double = 0.85
    static let treeIndent: CGFloat = 12
    static let hierarchyIndent: CGFloat = 18

    // Icon sizing
    static let iconXS: CGFloat = 13
    static let iconSM: CGFloat = 14
    static let iconMD: CGFloat = 16
    static let iconLG: CGFloat = 18
    static let avatarSize: CGFloat = 34
    static let railButtonWidth: CGFloat = 42
    static let railButtonHeight: CGFloat = 36
    static let railItemSpacing: CGFloat = 8
    static let railTopPadding: CGFloat = 10
    static let railSeparatorHorizontalPadding: CGFloat = 12
    static let railSeparatorVerticalPadding: CGFloat = ICOSSpacing.xs
    static let railPreviewHeight: CGFloat = 760

    // Header
    static let headerHeight: CGFloat = 52
    static let headerHorizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 28
    static let headerBottomPadding: CGFloat = 12
    static let headerItemSpacing: CGFloat = ICOSSpacing.md
    static let headerTextSpacing: CGFloat = ICOSSpacing.xs
    static let headerVerticalPadding: CGFloat = ICOSSpacing.lg
    static let headerPreviewPadding: CGFloat = ICOSSpacing.md

    // Search
    static let searchHorizontalPadding: CGFloat = 16
    static let searchVerticalPadding: CGFloat = 10
    static let searchOuterHorizontalPadding: CGFloat = 16
    static let searchTopPadding: CGFloat = 12
    static let searchBottomPadding: CGFloat = 20
    static let searchFontSize: CGFloat = 12
    static let searchItemSpacing: CGFloat = ICOSSpacing.sm
    static let searchCornerRadius: CGFloat = ICOSRadius.sm

    // Content
    static let contentHorizontalPadding: CGFloat = 16
    static let contentTopPadding: CGFloat = 0
    static let sidebarContentTopPadding: CGFloat = 12
    static let contentBottomPadding: CGFloat = 14
    static let sectionGroupSpacing: CGFloat = 20
    static let sectionSpacing: CGFloat = 14
    static let rowSpacing: CGFloat = 5
    static let rowIconTextSpacing: CGFloat = 14
    static let sectionLabelFontSize: CGFloat = 11
    static let sectionLabelTracking: CGFloat = 0.8
    static let sectionHeaderVerticalPadding: CGFloat = ICOSSpacing.sm

    // Row
    static let rowHorizontalPadding: CGFloat = ICOSSpacing.md
    static let rowVerticalPadding: CGFloat = ICOSSpacing.sm
    static let rowCornerRadius: CGFloat = ICOSRadius.sm
    static let rowTitleFontSize: CGFloat = 12
    static let rowTitleLineLimit: Int = 1
    static let inactiveRowOpacity: Double = 0
    static let activeOpacity: Double = 0.14
    static let hoverOpacity: Double = 0.08
    static let pressedScale: CGFloat = 0.985

    static let inputBarHorizontalPadding: CGFloat = 12
    static let inputBarVerticalPadding: CGFloat = 10
    static let inputFieldHorizontalPadding: CGFloat = 12
    static let inputFieldVerticalPadding: CGFloat = 10
    static let inputFieldRadius: CGFloat = ICOSRadius.sm

    // Account
    static let accountOuterPadding: CGFloat = 16
    static let accountInnerPadding: CGFloat = ICOSSpacing.md
    static let accountCornerRadius: CGFloat = ICOSRadius.sm

    // Inspector Toggle
    static let inspectorToggleTopPadding: CGFloat = 28
    static let inspectorToggleTrailingPadding: CGFloat = 14
    static let inspectorToggleButtonSize: CGFloat = 34
    static let inspectorToggleIconSize: CGFloat = 15
    static let inspectorToggleCornerRadius: CGFloat = 10
}

// MARK: - Console Tokens

enum ICOSConsoleTokens {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 16
    static let headerBottomPadding: CGFloat = 10

    static let messageHorizontalPadding: CGFloat = 24
    static let messageVerticalPadding: CGFloat = 18

    static let composerHorizontalPadding: CGFloat = 16
    static let composerBottomPadding: CGFloat = 18
}

// MARK: - Console View Tokens

enum ICOSConsoleViewTokens {
    static let headerTextSpacing: CGFloat = 3
    static let welcomeMarkSize: CGFloat = 54
}

// MARK: - Brand Lockup Tokens

enum ICOSBrandLockupTokens {
    static let defaultMarkSize: CGFloat = 28
    static let horizontalSpacing: CGFloat = ICOSSpacing.sm
    static let verticalSpacing: CGFloat = ICOSSpacing.sm
    static let textSpacing: CGFloat = ICOSSpacing.xs
    static let markCornerRadiusRatio: CGFloat = 0.28
    static let markPrimaryOpacity: Double = 0.92
    static let markSecondaryOpacity: Double = 0.62
    static let markLetterSizeRatio: CGFloat = 0.48
    static let markShadowOpacity: Double = 0.10
    static let markShadowRadius: CGFloat = 10
    static let markShadowX: CGFloat = 0
    static let markShadowY: CGFloat = 4
    static let titleFontSize: CGFloat = 14
    static let titleTracking: CGFloat = 0.2
    static let subtitleFontSize: CGFloat = 9
    static let subtitleTracking: CGFloat = 1.2
    static let previewWidth: CGFloat = 420
}

// MARK: - Developer Shell Tokens

enum ICOSDeveloperShellTokens {
    static let sidebarWidth: CGFloat = 268
    static let sidebarCollapsedWidth: CGFloat = 58
    static let inspectorWidth: CGFloat = 300
    static let inspectorExpandedWidth: CGFloat = 560
    static let inspectorRailWidth: CGFloat = sidebarCollapsedWidth
    static let centerMinWidth: CGFloat = 360
    static let inspectorToggleTopPadding: CGFloat = ICOSSidebarTokens.inspectorToggleTopPadding
    static let inspectorToggleTrailingPadding: CGFloat = ICOSSidebarTokens.inspectorToggleTrailingPadding
    static let inspectorToggleButtonSize: CGFloat = ICOSSidebarTokens.inspectorToggleButtonSize
    static let inspectorToggleIconSize: CGFloat = ICOSSidebarTokens.inspectorToggleIconSize
    static let inspectorToggleCornerRadius: CGFloat = ICOSSidebarTokens.inspectorToggleCornerRadius
    static let collapseIconSize: CGFloat = 14
    static let collapseButtonSize: CGFloat = 38
    static let collapsedInspectorTopPadding: CGFloat = 12
    static let collapseAnimationDuration: Double = 0.18
}

// MARK: - Developer Composer Tokens

enum ICOSDeveloperComposerTokens {
    static let inputSpacing: CGFloat = 8
    static let actionIconSize: CGFloat = 14
    static let actionButtonSize: CGFloat = 34
    static let inputHorizontalPadding: CGFloat = 14
    static let inputVerticalPadding: CGFloat = 10
    static let inputMinHeight: CGFloat = 44
    static let inputMaxHeight: CGFloat = 144
    static let inputCornerRadius: CGFloat = ICOSRadius.sm
    static let placeholderTopPadding: CGFloat = ICOSSpacing.xs
    static let actionInactiveFillOpacity: Double = 0
    static let actionButtonCornerRadius: CGFloat = ICOSSidebarTokens.rowCornerRadius
    static let shellVerticalSpacing: CGFloat = 8
    static let shellHorizontalPadding: CGFloat = 0
    static let shellVerticalPadding: CGFloat = 0
    static let shellBackgroundOpacity: Double = 0
    static let shellCornerRadius: CGFloat = ICOSRadius.sm
    static let shellStrokeOpacity: Double = 0
    static let shellStrokeWidth: CGFloat = 0
    static let shellMaxWidth: CGFloat = 760
    static let inputStrokeOpacity: Double = 0.24
    static let inputStrokeWidth: CGFloat = 1
    static let toolbarItemSpacing: CGFloat = 8
    static let toolbarRailHorizontalPadding: CGFloat = 2
    static let toolbarActionSpacing: CGFloat = 6
    static let toolbarIconSize: CGFloat = 12
    static let toolbarActionHorizontalPadding: CGFloat = 12
    static let toolbarActionVerticalPadding: CGFloat = 8
    static let toolbarActionFontSize: CGFloat = 12
    static let toolbarActionLineLimit: Int = 1
    static let modeSelectorMaxWidth: CGFloat = 280
    static let selectorHeight: CGFloat = 30
    static let selectorHorizontalPadding: CGFloat = 10
    static let selectorRadius: CGFloat = ICOSRadius.sm
    static let statusIconSize: CGFloat = 12
    static let statusChipHorizontalPadding: CGFloat = 10
    static let statusChipVerticalPadding: CGFloat = 7
    static let statusChipRadius: CGFloat = ICOSRadius.sm
    static let statusFontSize: CGFloat = 11
    static let selectorFontSize: CGFloat = 11
    static let selectorLineLimit: Int = 1
}

// MARK: - Input Bar Tokens

enum ICOSInputBarTokens {
    static let itemSpacing: CGFloat = ICOSSpacing.sm
    static let iconButtonPadding: CGFloat = ICOSSpacing.sm
    static let inputFontSize: CGFloat = 14
}

// MARK: - Action Primitive Tokens

enum ICOSActionPrimitiveTokens {
    static let actionPillFontSize: CGFloat = 12
    static let statusBadgeFontSize: CGFloat = 11
    static let statusBadgeFillOpacity: Double = 0.12
    static let statusBadgeStrokeOpacity: Double = 0.18
    static let inlineSearchFontSize: CGFloat = 13
    static let emptyStateTitleFontSize: CGFloat = 14
    static let emptyStateDetailFontSize: CGFloat = 12
    static let previewWidth: CGFloat = 520
}

// MARK: - Developer Sidebar Tokens

enum ICOSDeveloperSidebarTokens {
    static let containerVerticalPadding: CGFloat = 14
    static let horizontalPadding: CGFloat = 16

    static let headerSpacing: CGFloat = 12
    static let headerIconSize: CGFloat = 15
    static let headerButtonIconSize: CGFloat = 14
    static let headerButtonSize: CGFloat = 32
    static let headerBottomPadding: CGFloat = 20

    static let searchSpacing: CGFloat = 10
    static let searchIconSize: CGFloat = 13
    static let searchInnerHorizontalPadding: CGFloat = ICOSSpacing.lg
    static let searchInnerVerticalPadding: CGFloat = ICOSSpacing.md
    static let searchCornerRadius: CGFloat = ICOSRadius.sm
    static let searchBottomPadding: CGFloat = 20
    static let searchFontSize: CGFloat = 12

    static let navigationSpacing: CGFloat = 8
    static let collapsedRailSpacing: CGFloat = ICOSSidebarTokens.sectionGroupSpacing
    static let navigationHorizontalPadding: CGFloat = 12
    static let navigationTopPadding: CGFloat = 4
    static let workspaceTreeMaxHeight: CGFloat = 260
    static let inactiveRowOpacity: Double = 0

    static let sectionLabelTopPadding: CGFloat = 12
    static let sectionLabelBottomPadding: CGFloat = 2
    static let sectionLabelFontSize: CGFloat = 11
    static let sectionLabelOpacity: Double = 0.72

    static let footerSpacing: CGFloat = 12
    static let footerAccountSpacing: CGFloat = 10
    static let accountAvatarSize: CGFloat = 30
    static let accountTextSpacing: CGFloat = 2

    static let dividerHeight: CGFloat = 1

    static let rowSpacing: CGFloat = 10
    static let rowIconSize: CGFloat = 13
    static let rowHorizontalPadding: CGFloat = ICOSSpacing.md
    static let rowVerticalPadding: CGFloat = ICOSSpacing.md
    static let rowTitleFontSize: CGFloat = 12
    static let rowSubtitleFontSize: CGFloat = 11
    static let workspaceMenuTextSpacing: CGFloat = 2
    static let fileNodeVerticalPadding: CGFloat = ICOSSpacing.xs
}

// MARK: - Developer Inspector Tokens

enum ICOSDeveloperInspectorTokens {
    static let containerVerticalPadding: CGFloat = 14
    static let horizontalPadding: CGFloat = 16
    static let headerSpacing: CGFloat = 10
    static let headerButtonIconSize: CGFloat = 14
    static let headerButtonSize: CGFloat = 32
    static let headerBottomPadding: CGFloat = 18
    static let dividerOpacity: Double = 0.22
    static let dividerHeight: CGFloat = 1
    static let dividerBottomPadding: CGFloat = 14
}

// MARK: - Developer Top Bar Tokens

enum ICOSDeveloperTopBarTokens {
    static let pillSpacing: CGFloat = 7
    static let pillIconSize: CGFloat = 14
    static let pillHorizontalPadding: CGFloat = 10
    static let pillVerticalPadding: CGFloat = 7
    static let itemSpacing: CGFloat = 12
    static let titleSpacing: CGFloat = 2
}

// MARK: - Developer Runtime Tokens

enum ICOSDeveloperRuntimeTokens {
    static let cardSpacing: CGFloat = 9
    static let cardHeaderSpacing: CGFloat = 8
    static let cardIconSize: CGFloat = 14
}

// MARK: - Developer Panel Tokens

enum ICOSDeveloperPanelTokens {
    static let headerSpacing: CGFloat = 8
    static let headerIconSize: CGFloat = 15
    static let headerHeight: CGFloat = 42

    static let emptyPanelSpacing: CGFloat = 10
    static let emptyPanelIconSize: CGFloat = 26
    static let emptyPanelMinHeight: CGFloat = 180
    static let filePreviewMaxHeight: CGFloat = 240
    static let editorMinHeight: CGFloat = 320
    static let terminalHistoryMaxHeight: CGFloat = 92

    static let terminalOutputMinHeight: CGFloat = 180

    // Session Rows
    static let sessionRowTextSpacing: CGFloat = ICOSSpacing.xs
    static let sessionRowPadding: CGFloat = ICOSSpacing.sm
    static let sessionTitleLineLimit: Int = 1

    // Review Panel
    static let reviewResultTextSpacing: CGFloat = 3
    static let reviewPathFontSize: CGFloat = 10
    static let reviewPreviewFontSize: CGFloat = 12
    static let reviewPanelPadding: CGFloat = 18

    // Integration Rows
    static let integrationLedgerIconSize: CGFloat = 15
    static let integrationLedgerTextSpacing: CGFloat = 2
    static let integrationLedgerActionFontSize: CGFloat = 12
    static let integrationLedgerReasonFontSize: CGFloat = 10
    static let integrationTitleFontSize: CGFloat = 13
    static let integrationStatusFontSize: CGFloat = 10
    static let integrationDetailFontSize: CGFloat = 11

    // Developer Plan
    static let planRequestFontSize: CGFloat = 13
    static let planIntentFontSize: CGFloat = 13
    static let planStepIconSize: CGFloat = 15
    static let planStepTextSpacing: CGFloat = 2
    static let planStepTitleFontSize: CGFloat = 12
    static let agentAnalysisMinHeight: CGFloat = 140
    static let agentAnalysisMaxHeight: CGFloat = 280
    static let agentRuntimeMapSpacing: CGFloat = 4
    static let runtimeMetricValueFontSize: CGFloat = 14

    // Runtime Developer Panel
    static let runtimePanelSpacing: CGFloat = 16
    static let runtimePanelTitleFontSize: CGFloat = 20
    static let runtimePanelPadding: CGFloat = 24
    static let runtimePanelWidth: CGFloat = 420
    static let runtimePanelHeight: CGFloat = 760
    static let runtimeSectionSpacing: CGFloat = 10
    static let runtimeSectionTitleFontSize: CGFloat = 13
    static let runtimeLabelFontSize: CGFloat = 12
    static let runtimeMonoFontSize: CGFloat = 12
    static let runtimeMetaFontSize: CGFloat = 11
    static let runtimeTerminalPadding: CGFloat = 10
    static let runtimeTerminalHeight: CGFloat = 260
    static let runtimeButtonSpacing: CGFloat = 10

    // Diff Preview
    static let diffRowSpacing: CGFloat = 2
    static let diffColumnSpacing: CGFloat = 8
    static let diffPrefixWidth: CGFloat = 12
    static let diffHorizontalPadding: CGFloat = 8
    static let diffVerticalPadding: CGFloat = 3
    static let diffUnchangedOpacity: Double = 0
}

// MARK: - Developer Preview Tokens

enum ICOSDeveloperPreviewTokens {
    static let consoleWidth: CGFloat = 1280
    static let consoleHeight: CGFloat = 780
    static let patchPanelWidth: CGFloat = 420
    static let patchPanelHeight: CGFloat = 760
}

// MARK: - Runtime Shell Tokens

enum ICOSRuntimeShellTokens {
    static let headerTitleFontSize: CGFloat = 14
    static let headerSubtitleFontSize: CGFloat = 11
    static let sidebarWidth: CGFloat = 260
    static let inspectorWidth: CGFloat = 280
    static let inspectorRowFillOpacity: Double = 0.6
    static let headerIconSize: CGFloat = 28
    static let canvasTopSpacerHeight: CGFloat = 58
    static let heroIconSize: CGFloat = 52
    static let heroIconOpacity: Double = 0.82
    static let heroTitleFontSize: CGFloat = 26
    static let heroSubtitleFontSize: CGFloat = 14
    static let sectionTitleFontSize: CGFloat = 11
    static let sectionTitleTracking: CGFloat = 0.8
    static let sectionItemFontSize: CGFloat = 12
    static let previewWidth: CGFloat = 1400
    static let previewHeight: CGFloat = 820
    static let workspacePreviewWidth: CGFloat = 1200
    static let workspacePreviewHeight: CGFloat = 760
}

// MARK: - Runtime Developer Tokens

enum ICOSRuntimeDeveloperTokens {
    static let composerPillFontSize: CGFloat = 12
    static let composerInputFontSize: CGFloat = 14
    static let composerInputMinHeight: CGFloat = 72
    static let composerStatusFontSize: CGFloat = 11
    static let disabledSendOpacity: Double = 0.45
    static let enabledSendOpacity: Double = 1
    static let composerMaxWidth: CGFloat = 720
    static let inspectorCardTitleFontSize: CGFloat = 12
    static let inspectorMetricFontSize: CGFloat = 12
}

// MARK: - Bottom Panel Tokens

enum ICOSBottomPanelTokens {
    static let tabTitleFontSize: CGFloat = 12
    static let inactiveTabFillOpacity: Double = 0
    static let terminalCommandFontSize: CGFloat = 12
    static let terminalOutputFontSize: CGFloat = 11
    static let panelTitleFontSize: CGFloat = 13
    static let panelLineFontSize: CGFloat = 12
}

// MARK: - Navigation Shell Tokens

enum ICOSNavigationShellTokens {
    static let noBlurRadius: CGFloat = 0
    static let titleBarHeight: CGFloat = 52
    static let titleBarHorizontalPadding: CGFloat = ICOSSpacing.lg
    static let titleBarTitleFontSize: CGFloat = 15
    static let titleBarNavigationIconSize: CGFloat = 14

    static let spotlightBackgroundBlurRadius: CGFloat = 4
    static let spotlightOverlayOpacity: Double = 0.80
    static let spotlightSearchIconSize: CGFloat = 18
    static let spotlightCloseIconSize: CGFloat = 14
    static let spotlightSearchFontSize: CGFloat = 18
    static let spotlightSearchHeight: CGFloat = 58
    static let spotlightResultFontSize: CGFloat = 12
    static let spotlightWidth: CGFloat = 620
    static let spotlightTopPadding: CGFloat = 96
    static let emptyRouteTitleFontSize: CGFloat = 28
    static let emptyRouteDescriptionFontSize: CGFloat = 14
    static let emptyRoutePadding: CGFloat = 32
}

// MARK: - Intelligence Module Tokens

enum ICOSIntelligenceModuleTokens {
    static let detailVisualHeight: CGFloat = 260
    static let capabilityFontSize: CGFloat = 12
    static let statusDotSize: CGFloat = 8
    static let statusFontSize: CGFloat = 13
    static let headerMarkSize: CGFloat = 42
    static let headerSubtitleFontSize: CGFloat = 13
    static let headerSubtitleMaxWidth: CGFloat = 360
    static let cardVisualHeight: CGFloat = 94
    static let cardIconSize: CGFloat = 18
    static let cardTitleFontSize: CGFloat = 15
    static let cardStatusFontSize: CGFloat = 10
    static let cardSummaryFontSize: CGFloat = 12
    static let cardSummaryLineLimit: Int = 3
    static let cardMinHeight: CGFloat = 250
    static let fallbackIconSize: CGFloat = 30
    static let fallbackIconOpacity: Double = 0.72
    static let previewWidth: CGFloat = 1100
    static let previewHeight: CGFloat = 760
}

// MARK: - Wrapping Flow Tokens

enum ICOSWrappingFlowTokens {
    static let previewChipFontSize: CGFloat = 11
    static let previewWidth: CGFloat = 360
}

// MARK: - Window Token Extensions

extension ICOSWindowTokens {
    static let titlebarAccessoryBackgroundOpacity: Double = 0
    static let titlebarAccessoryButtonCount: CGFloat = 3
    static let titlebarAccessoryGapCount: CGFloat = 2
}
