import SwiftUI

// MARK: - ICOS Adaptive Pair Layout
// Company-native adaptive split-pair layout for ICOS interface surfaces.
// Preserves adaptive horizontal/vertical pairing inside the ICOS architecture.

private enum ICOSAdaptivePairLayoutTokens {
    static let breakpoint: CGFloat = 920
    static let spacing: CGFloat = ICOSSpacing.md
    static let primaryMinWidth: CGFloat = 420
    static let secondaryMinWidth: CGFloat = 320
    static let previewPrimaryHeight: CGFloat = 280
    static let previewSecondaryHeight: CGFloat = 220
    static let previewPadding: CGFloat = ICOSSpacing.xl
    static let previewWidth: CGFloat = 1100
    static let previewHeight: CGFloat = 620
    static let previewCornerRadius: CGFloat = ICOSPanelTokens.cornerRadius
}

struct ICOSAdaptivePairLayout<Primary: View, Secondary: View>: View {
    let breakpoint: CGFloat
    let spacing: CGFloat
    let primaryMinWidth: CGFloat
    let secondaryMinWidth: CGFloat
    let primary: Primary
    let secondary: Secondary

    init(
        breakpoint: CGFloat = ICOSAdaptivePairLayoutTokens.breakpoint,
        spacing: CGFloat = ICOSAdaptivePairLayoutTokens.spacing,
        primaryMinWidth: CGFloat = ICOSAdaptivePairLayoutTokens.primaryMinWidth,
        secondaryMinWidth: CGFloat = ICOSAdaptivePairLayoutTokens.secondaryMinWidth,
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.breakpoint = breakpoint
        self.spacing = spacing
        self.primaryMinWidth = primaryMinWidth
        self.secondaryMinWidth = secondaryMinWidth
        self.primary = primary()
        self.secondary = secondary()
    }

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width >= breakpoint {
                HStack(alignment: .top, spacing: spacing) {
                    primary
                        .frame(
                            minWidth: primaryMinWidth,
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )

                    secondary
                        .frame(
                            minWidth: secondaryMinWidth,
                            maxWidth: secondaryMinWidth,
                            alignment: .topLeading
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                ICOSScrollView {
                    VStack(alignment: .leading, spacing: spacing) {
                        primary
                            .frame(maxWidth: .infinity, alignment: .topLeading)

                        secondary
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ICOSAdaptivePairLayout {
        RoundedRectangle(cornerRadius: ICOSAdaptivePairLayoutTokens.previewCornerRadius, style: .continuous)
            .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.floatingSurface : .clear)
            .overlay(Text("Primary"))
            .frame(height: ICOSAdaptivePairLayoutTokens.previewPrimaryHeight)
    } secondary: {
        RoundedRectangle(cornerRadius: ICOSAdaptivePairLayoutTokens.previewCornerRadius, style: .continuous)
            .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.panelBackground : .clear)
            .overlay(Text("Secondary"))
            .frame(height: ICOSAdaptivePairLayoutTokens.previewSecondaryHeight)
    }
    .padding(ICOSAdaptivePairLayoutTokens.previewPadding)
    .frame(
        width: ICOSAdaptivePairLayoutTokens.previewWidth,
        height: ICOSAdaptivePairLayoutTokens.previewHeight
    )
}