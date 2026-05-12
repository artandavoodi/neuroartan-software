import SwiftUI

// MARK: - Workspace Runtime Canvas

struct WorkspaceRuntimeCanvas: View {

    var body: some View {
        ZStack {
            background

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Background

    private var background: some View {
        Rectangle()
            .fill(ICOSMaterials.windowBackground)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: ICOSRuntimeShellTokens.canvasTopSpacerHeight)

            GeometryReader { _ in
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

                    VStack(spacing: ICOSControlTokens.cardSpacing) {
                        SVGImageView(icon: .workspace)
                            .frame(width: ICOSSidebarTokens.runtimeHeroIconSize, height: ICOSSidebarTokens.runtimeHeroIconSize)
                            .foregroundStyle(ICOSColors.textSecondary)
                            .opacity(ICOSRuntimeShellTokens.heroIconOpacity)

                        Text("Workspace Runtime")
                            .font(.system(size: ICOSRuntimeShellTokens.heroTitleFontSize, weight: .semibold))
                            .foregroundStyle(ICOSColors.textPrimary)

                        Text("Canvas architecture is now modularized.")
                            .font(.system(size: ICOSRuntimeShellTokens.heroSubtitleFontSize, weight: .regular))
                            .foregroundStyle(ICOSColors.textSecondary)
                    }
                }
                .padding(ICOSShellTokens.shellSectionSpacing)
            }
        }
    }
}

#Preview {
    WorkspaceRuntimeCanvas()
        .frame(
            width: ICOSRuntimeShellTokens.workspacePreviewWidth,
            height: ICOSRuntimeShellTokens.workspacePreviewHeight
        )
}
