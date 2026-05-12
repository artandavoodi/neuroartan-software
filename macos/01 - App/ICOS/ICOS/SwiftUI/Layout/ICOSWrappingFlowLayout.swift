import SwiftUI

// MARK: - ICOS Wrapping Flow Layout
// Company-native wrapping layout for chips, tags, actions, and compact interface groups.

struct ICOSWrappingFlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let content: (Data.Element) -> Content

    init(
        _ data: Data,
        horizontalSpacing: CGFloat = ICOSSpacing.xs,
        verticalSpacing: CGFloat = ICOSSpacing.xs,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }

    var body: some View {
        ICOSWrappingFlow(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            ForEach(data) { element in
                content(element)
            }
        }
    }
}

// MARK: - ICOS Wrapping Flow

struct ICOSWrappingFlow: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    init(
        horizontalSpacing: CGFloat = ICOSSpacing.xs,
        verticalSpacing: CGFloat = ICOSSpacing.xs
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let rows = rows(
            proposal: proposal,
            subviews: subviews
        )

        let width = proposal.width ?? rows.map(\.width).max() ?? 0
        let height = rows.map(\.height).reduce(0, +) + CGFloat(max(0, rows.count - 1)) * verticalSpacing

        return CGSize(width: width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let rows = rows(
            proposal: ProposedViewSize(width: bounds.width, height: proposal.height),
            subviews: subviews
        )

        var y = bounds.minY

        for row in rows {
            var x = bounds.minX

            for item in row.items {
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(item.size)
                )

                x += item.size.width + horizontalSpacing
            }

            y += row.height + verticalSpacing
        }
    }

    // MARK: - Row Calculation

    private func rows(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> [ICOSWrappingFlowRow] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [ICOSWrappingFlowRow] = []
        var currentItems: [ICOSWrappingFlowItem] = []
        var currentWidth: CGFloat = 0
        var currentHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let proposedWidth = currentItems.isEmpty
                ? size.width
                : currentWidth + horizontalSpacing + size.width

            if proposedWidth > maxWidth && !currentItems.isEmpty {
                rows.append(
                    ICOSWrappingFlowRow(
                        items: currentItems,
                        width: currentWidth,
                        height: currentHeight
                    )
                )

                currentItems = [
                    ICOSWrappingFlowItem(
                        subview: subview,
                        size: size
                    )
                ]
                currentWidth = size.width
                currentHeight = size.height
            } else {
                currentItems.append(
                    ICOSWrappingFlowItem(
                        subview: subview,
                        size: size
                    )
                )
                currentWidth = proposedWidth
                currentHeight = max(currentHeight, size.height)
            }
        }

        if !currentItems.isEmpty {
            rows.append(
                ICOSWrappingFlowRow(
                    items: currentItems,
                    width: currentWidth,
                    height: currentHeight
                )
            )
        }

        return rows
    }
}

// MARK: - Flow Types

private struct ICOSWrappingFlowRow {
    let items: [ICOSWrappingFlowItem]
    let width: CGFloat
    let height: CGFloat
}

private struct ICOSWrappingFlowItem {
    let subview: LayoutSubview
    let size: CGSize
}

// MARK: - Preview

private struct ICOSWrappingFlowPreviewItem: Identifiable {
    let id = UUID()
    let title: String
}

#Preview {
    let items = [
        ICOSWrappingFlowPreviewItem(title: "Sessions"),
        ICOSWrappingFlowPreviewItem(title: "Terminal"),
        ICOSWrappingFlowPreviewItem(title: "Files"),
        ICOSWrappingFlowPreviewItem(title: "Knowledge"),
        ICOSWrappingFlowPreviewItem(title: "Automation"),
        ICOSWrappingFlowPreviewItem(title: "Usage"),
        ICOSWrappingFlowPreviewItem(title: "Providers")
    ]

    ICOSWrappingFlowLayout(items) { item in
        Text(item.title)
            .font(.system(size: ICOSWrappingFlowTokens.previewChipFontSize, weight: .semibold))
            .foregroundStyle(ICOSColors.textSecondary)
            .padding(.horizontal, ICOSSpacing.sm)
            .padding(.vertical, ICOSSpacing.xs)
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    Capsule(style: .continuous)
                        .fill(ICOSMaterials.floatingSurface)
                }
            }
            .overlay {
                if ICOSMaterials.showsSurfaceBorders {
                    Capsule(style: .continuous)
                        .strokeBorder(ICOSMaterials.softStroke, lineWidth: ICOSMaterials.softStrokeWidth)
                }
            }
    }
    .padding(ICOSSpacing.xl)
    .frame(width: ICOSWrappingFlowTokens.previewWidth)
}