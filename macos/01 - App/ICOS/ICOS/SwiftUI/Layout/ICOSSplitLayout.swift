import SwiftUI


// MARK: - ICOS Split Layout
// Company-native persistent split layout for ICOS interface surfaces.
// Owns proportional resizing, minimum column protection, and adaptive collapse behavior.

private enum ICOSSplitLayoutTokens {
    static let leadingWidth: CGFloat = 320
    static let leadingMinWidth: CGFloat = 240
    static let leadingMaxWidth: CGFloat = 460
    static let detailMinWidth: CGFloat = 420
    static let collapsedBreakpoint: CGFloat = 820
    static let dividerWidth: CGFloat = 1
    static let dragHitWidth: CGFloat = ICOSSpacing.md
    static let collapsedSpacing: CGFloat = ICOSSpacing.md
    static let dividerOpacity: Double = 0.18
    static let previewCornerRadius: CGFloat = ICOSPanelTokens.cornerRadius
    static let previewPadding: CGFloat = ICOSSpacing.xl
    static let previewWidth: CGFloat = 1180
    static let previewHeight: CGFloat = 720
}

struct ICOSSplitLayout<Leading: View, Detail: View>: View {
    let leadingMinWidth: CGFloat
    let leadingMaxWidth: CGFloat
    let detailMinWidth: CGFloat
    let collapsedBreakpoint: CGFloat
    let dividerWidth: CGFloat
    let leading: Leading
    let detail: Detail

    @State private var leadingWidth: CGFloat

    init(
        leadingWidth: CGFloat = ICOSSplitLayoutTokens.leadingWidth,
        leadingMinWidth: CGFloat = ICOSSplitLayoutTokens.leadingMinWidth,
        leadingMaxWidth: CGFloat = ICOSSplitLayoutTokens.leadingMaxWidth,
        detailMinWidth: CGFloat = ICOSSplitLayoutTokens.detailMinWidth,
        collapsedBreakpoint: CGFloat = ICOSSplitLayoutTokens.collapsedBreakpoint,
        dividerWidth: CGFloat = ICOSSplitLayoutTokens.dividerWidth,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder detail: () -> Detail
    ) {
        self.leadingMinWidth = leadingMinWidth
        self.leadingMaxWidth = leadingMaxWidth
        self.detailMinWidth = detailMinWidth
        self.collapsedBreakpoint = collapsedBreakpoint
        self.dividerWidth = dividerWidth
        self.leading = leading()
        self.detail = detail()
        self._leadingWidth = State(initialValue: leadingWidth)
    }

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width < collapsedBreakpoint {
                collapsedLayout
            } else {
                expandedLayout(totalWidth: proxy.size.width)
            }
        }
    }

    // MARK: - Expanded Layout

    private func expandedLayout(totalWidth: CGFloat) -> some View {
        let protectedWidth = protectedLeadingWidth(totalWidth: totalWidth)

        return HStack(spacing: 0) {
            leading
                .frame(width: protectedWidth)
                .frame(maxHeight: .infinity)
                .clipped()

            divider(totalWidth: totalWidth)

            detail
                .frame(minWidth: detailMinWidth)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Collapsed Layout

    private var collapsedLayout: some View {
        ICOSScrollView {
            VStack(spacing: ICOSSplitLayoutTokens.collapsedSpacing) {
                leading
                    .frame(maxWidth: .infinity)

                detail
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Divider

    private func divider(totalWidth: CGFloat) -> some View {
        Rectangle()
            .fill(ICOSMaterials.separator.opacity(ICOSSplitLayoutTokens.dividerOpacity))
            .frame(width: dividerWidth)
            .overlay {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: ICOSSplitLayoutTokens.dragHitWidth)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let proposed = leadingWidth + value.translation.width
                                leadingWidth = clampedLeadingWidth(
                                    proposed,
                                    totalWidth: totalWidth
                                )
                            }
                    )
            }
            .cursor(.resizeLeftRight)
    }

    // MARK: - Width Protection

    private func protectedLeadingWidth(totalWidth: CGFloat) -> CGFloat {
        clampedLeadingWidth(leadingWidth, totalWidth: totalWidth)
    }

    private func clampedLeadingWidth(
        _ proposed: CGFloat,
        totalWidth: CGFloat
    ) -> CGFloat {
        let maxAllowed = min(
            leadingMaxWidth,
            max(leadingMinWidth, totalWidth - detailMinWidth - dividerWidth)
        )

        return min(max(proposed, leadingMinWidth), maxAllowed)
    }
}

// MARK: - Cursor Modifier

private extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        modifier(ICOSCursorModifier(cursor: cursor))
    }
}

private struct ICOSCursorModifier: ViewModifier {
    let cursor: NSCursor

    func body(content: Content) -> some View {
        content
            .onHover { isHovering in
                if isHovering {
                    cursor.push()
                } else {
                    NSCursor.pop()
                }
            }
    }
}

// MARK: - Preview

#Preview {
    ICOSSplitLayout {
        RoundedRectangle(cornerRadius: ICOSSplitLayoutTokens.previewCornerRadius, style: .continuous)
            .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.floatingSurface : .clear)
            .overlay(Text("Leading"))
    } detail: {
        RoundedRectangle(cornerRadius: ICOSSplitLayoutTokens.previewCornerRadius, style: .continuous)
            .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.panelBackground : .clear)
            .overlay(Text("Detail"))
    }
    .padding(ICOSSplitLayoutTokens.previewPadding)
    .frame(
        width: ICOSSplitLayoutTokens.previewWidth,
        height: ICOSSplitLayoutTokens.previewHeight
    )
}