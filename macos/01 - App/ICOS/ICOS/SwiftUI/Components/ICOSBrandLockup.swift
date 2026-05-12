import SwiftUI

// MARK: - ICOS Brand Lockup
// Company-native brand identity component for titlebars, headers, sidebars, and launch surfaces.

struct ICOSBrandLockup: View {
    let title: String
    let subtitle: String?
    let markSize: CGFloat
    let orientation: ICOSBrandLockupOrientation
    let showsMark: Bool

    init(
        title: String = "ICOS",
        subtitle: String? = "Neuroartan",
        markSize: CGFloat = ICOSBrandLockupTokens.defaultMarkSize,
        orientation: ICOSBrandLockupOrientation = .horizontal,
        showsMark: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.markSize = markSize
        self.orientation = orientation
        self.showsMark = showsMark
    }

    var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                horizontalLockup
            case .vertical:
                verticalLockup
            case .markOnly:
                brandMark
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityTitle)
    }

    // MARK: - Horizontal

    private var horizontalLockup: some View {
        HStack(spacing: ICOSBrandLockupTokens.horizontalSpacing) {
            if showsMark {
                brandMark
            }

            textStack(alignment: .leading)
        }
    }

    // MARK: - Vertical

    private var verticalLockup: some View {
        VStack(spacing: ICOSBrandLockupTokens.verticalSpacing) {
            if showsMark {
                brandMark
            }

            textStack(alignment: .center)
        }
    }

    // MARK: - Mark

    private var brandMark: some View {
        ZStack {
            RoundedRectangle(cornerRadius: markSize * ICOSBrandLockupTokens.markCornerRadiusRatio, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ICOSSidebarColors.textPrimary.opacity(ICOSBrandLockupTokens.markPrimaryOpacity),
                            ICOSSidebarColors.textSecondary.opacity(ICOSBrandLockupTokens.markSecondaryOpacity)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: markSize * ICOSBrandLockupTokens.markCornerRadiusRatio, style: .continuous)
                .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)

            Text("I")
                .font(.system(size: markSize * ICOSBrandLockupTokens.markLetterSizeRatio, weight: .semibold, design: .serif))
                .foregroundStyle(ICOSMaterials.windowBackground)
        }
        .frame(width: markSize, height: markSize)
        .shadow(
            color: ICOSMaterials.separator.opacity(ICOSBrandLockupTokens.markShadowOpacity),
            radius: ICOSBrandLockupTokens.markShadowRadius,
            x: ICOSBrandLockupTokens.markShadowX,
            y: ICOSBrandLockupTokens.markShadowY
        )
    }

    // MARK: - Text

    private func textStack(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: ICOSBrandLockupTokens.textSpacing) {
            Text(title)
                .font(.system(size: ICOSBrandLockupTokens.titleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
                .tracking(ICOSBrandLockupTokens.titleTracking)

            if let subtitle, !subtitle.isEmpty {
                Text(subtitle.uppercased())
                    .font(.system(size: ICOSBrandLockupTokens.subtitleFontSize, weight: .semibold))
                    .foregroundStyle(ICOSColors.textSecondary)
                    .tracking(ICOSBrandLockupTokens.subtitleTracking)
            }
        }
    }

    // MARK: - Accessibility

    private var accessibilityTitle: String {
        if let subtitle, !subtitle.isEmpty {
            return "\(title), \(subtitle)"
        }

        return title
    }
}

// MARK: - ICOS Brand Lockup Orientation

enum ICOSBrandLockupOrientation {
    case horizontal
    case vertical
    case markOnly
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: ICOSSpacing.xl) {
        ICOSBrandLockup()
        ICOSBrandLockup(title: "Runtime", subtitle: "Neuroartan", markSize: 34)
        ICOSBrandLockup(title: "ICOS", subtitle: "Cognitive Operating System", markSize: 52, orientation: .vertical)
        ICOSBrandLockup(markSize: 40, orientation: .markOnly)
    }
    .padding(ICOSSpacing.xxl)
    .frame(width: ICOSBrandLockupTokens.previewWidth)
}