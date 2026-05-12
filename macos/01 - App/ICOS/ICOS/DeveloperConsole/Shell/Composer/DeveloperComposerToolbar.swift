import SwiftUI

// MARK: - Developer Composer Toolbar

struct DeveloperComposerToolbar: View {
    let onAction: (DeveloperExtensionAction) -> Void

    // MARK: - Body

    var body: some View {
        ICOSScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ICOSDeveloperComposerTokens.toolbarItemSpacing) {
                ForEach(DeveloperExtensionAction.allCases) { action in
                    toolbarAction(action)
                }
            }
            .padding(.horizontal, ICOSDeveloperComposerTokens.toolbarRailHorizontalPadding)
        }
    }

    // MARK: - Toolbar Action

    @ViewBuilder
    private func toolbarAction(_ action: DeveloperExtensionAction) -> some View {
        Button {
            onAction(action)
        } label: {
            HStack(spacing: ICOSDeveloperComposerTokens.toolbarActionSpacing) {
                SVGImageView(icon: action.icon)
                    .frame(
                        width: ICOSDeveloperComposerTokens.toolbarIconSize,
                        height: ICOSDeveloperComposerTokens.toolbarIconSize
                    )

                Text(action.rawValue)
                    .font(.system(size: ICOSDeveloperComposerTokens.toolbarActionFontSize, weight: .regular))
                    .lineLimit(ICOSDeveloperComposerTokens.toolbarActionLineLimit)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(ICOSSidebarColors.textSecondary)
        .padding(.horizontal, ICOSDeveloperComposerTokens.toolbarActionHorizontalPadding)
        .padding(.vertical, ICOSDeveloperComposerTokens.toolbarActionVerticalPadding)
        .background(
            ICOSMaterials.floatingSurface,
            in: RoundedRectangle(
                cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                style: .continuous
            )
        )
    }
}
