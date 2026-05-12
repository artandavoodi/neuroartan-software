import SwiftUI
import AppKit

// MARK: - ICOS Scroll Axis

enum ICOSScrollAxis {
    case vertical
    case horizontal
}

// MARK: - ICOS Scroll View

struct ICOSScrollView<Content: View>: View {
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let content: Content
    private let coordinateSpaceName: String

    @State private var viewportSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var contentOrigin: CGPoint = .zero
    @State private var isIndicatorVisible = false
    @State private var hideIndicatorTask: Task<Void, Never>?
    @State private var scrollOffsetY: CGFloat = 0

    init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content()
        self.coordinateSpaceName = "ICOSScrollViewCoordinateSpace-\(UUID().uuidString)"
    }

    var body: some View {
        GeometryReader { viewportProxy in
            ScrollView(axis, showsIndicators: false) {
                content
                    .padding(.top, verticalTopPadding)
                    .padding(.bottom, verticalBottomPadding)
                    .padding(.leading, horizontalLeadingPadding)
                    .padding(.trailing, horizontalTrailingPadding)
                    .background {
                        GeometryReader { contentProxy in
                            Color.clear
                                .preference(
                                    key: ICOSScrollMetricsPreferenceKey.self,
                                    value: ICOSScrollMetrics(
                                        size: contentProxy.size,
                                        origin: contentProxy.frame(in: .named(coordinateSpaceName)).origin
                                    )
                                )
                        }
                    }
            }
            .coordinateSpace(name: coordinateSpaceName)
            .scrollBounceBehavior(.basedOnSize, axes: axis)
            .background {
                ICOSNativeScrollStripConfigurator(axis: axis)
            }
            .onScrollGeometryChange(for: ICOSScrollGeometryState.self) { geometry in
                ICOSScrollGeometryState(
                    contentOffset: geometry.contentOffset,
                    contentSize: geometry.contentSize,
                    viewportSize: geometry.containerSize
                )
            } action: { oldValue, newValue in
                viewportSize = newValue.viewportSize
                contentSize = newValue.contentSize
                scrollOffsetY = newValue.contentOffset.y

                if oldValue.contentOffset != newValue.contentOffset {
                    showIndicatorTemporarily()
                }
            }
            .overlay(alignment: .trailing) {
                if showsVerticalIndicator && isIndicatorVisible {
                    verticalIndicator
                }
            }
            .onAppear {
                viewportSize = viewportProxy.size
            }
            .onChange(of: viewportProxy.size) { _, newSize in
                viewportSize = newSize
            }
            .onPreferenceChange(ICOSScrollMetricsPreferenceKey.self) { metrics in
                let didScroll = metrics.origin != contentOrigin
                contentSize = metrics.size

                if didScroll {
                    contentOrigin = metrics.origin
                    showIndicatorTemporarily()
                } else {
                    contentOrigin = metrics.origin
                }
            }
        }
    }

    private var verticalTopPadding: CGFloat {
        axis.contains(.vertical) ? ICOSScrollTokens.verticalContentTopPadding : 0
    }

    private var verticalBottomPadding: CGFloat {
        axis.contains(.vertical) ? ICOSScrollTokens.verticalContentBottomPadding : 0
    }

    private var horizontalLeadingPadding: CGFloat {
        axis.contains(.horizontal) ? ICOSScrollTokens.horizontalContentLeadingPadding : 0
    }

    private var horizontalTrailingPadding: CGFloat {
        axis.contains(.horizontal) ? ICOSScrollTokens.horizontalContentTrailingPadding : 0
    }

    private var showsVerticalIndicator: Bool {
        axis.contains(.vertical) && contentSize.height > viewportSize.height
    }

    private var verticalIndicator: some View {
        GeometryReader { proxy in
            let containerHeight = proxy.size.height
            let trackTop = ICOSScrollTokens.indicatorInsetTop
            let trackBottom = max(trackTop, containerHeight - ICOSScrollTokens.indicatorInsetBottom)
            let trackHeight = max(0, trackBottom - trackTop)
            let thumbHeight = min(ICOSScrollVisualTokens.verticalThumbHeight, trackHeight)
            let travelDistance = max(0, trackHeight - thumbHeight)
            let scrollableDistance = max(1, contentSize.height - viewportSize.height)
            let rawProgress = scrollOffsetY / scrollableDistance
            let progress = min(max(rawProgress, 0), 1)
            let offsetY = trackTop + (travelDistance * progress)

            RoundedRectangle(
                cornerRadius: ICOSScrollVisualTokens.verticalThumbCornerRadius,
                style: .continuous
            )
            .fill(ICOSColors.textSecondary.opacity(ICOSScrollVisualTokens.verticalThumbOpacity))
            .frame(
                width: ICOSScrollVisualTokens.verticalThumbWidth,
                height: thumbHeight
            )
            .offset(
                x: -ICOSScrollVisualTokens.verticalThumbTrailingInset,
                y: offsetY
            )
            .animation(ICOSMotion.quick, value: offsetY)
            .transition(.opacity)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .allowsHitTesting(false)
    }

    private func showIndicatorTemporarily() {
        hideIndicatorTask?.cancel()

        if !isIndicatorVisible {
            withAnimation(ICOSMotion.quick) {
                isIndicatorVisible = true
            }
        }

        hideIndicatorTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: ICOSScrollVisualTokens.hideDelayNanoseconds)
            guard !Task.isCancelled else { return }

            withAnimation(ICOSMotion.quick) {
                isIndicatorVisible = false
            }
        }
    }
}

// MARK: - Native Scroll Strip Configurator

private struct ICOSNativeScrollStripConfigurator: NSViewRepresentable {
    let axis: Axis.Set

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            configureScrollView(from: view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            configureScrollView(from: nsView)
        }
    }

    private func configureScrollView(from view: NSView) {
        guard let scrollView = view.enclosingScrollView else { return }

        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.scrollerStyle = .overlay
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsetsZero
        scrollView.scrollerInsets = NSEdgeInsets(
            top: axis.contains(.vertical) ? ICOSScrollTokens.indicatorInsetTop : 0,
            left: 0,
            bottom: axis.contains(.vertical) ? ICOSScrollTokens.indicatorInsetBottom : 0,
            right: 0
        )
    }
}

private extension NSView {
    var enclosingScrollView: NSScrollView? {
        sequence(first: superview, next: { $0?.superview })
            .first { $0 is NSScrollView } as? NSScrollView
    }
}

// MARK: - Scroll Metrics

private struct ICOSScrollMetrics: Equatable {
    let size: CGSize
    let origin: CGPoint

    static let zero = ICOSScrollMetrics(size: .zero, origin: .zero)
}

private struct ICOSScrollMetricsPreferenceKey: PreferenceKey {
    static var defaultValue: ICOSScrollMetrics = .zero

    static func reduce(value: inout ICOSScrollMetrics, nextValue: () -> ICOSScrollMetrics) {
        value = nextValue()
    }
}

private struct ICOSScrollGeometryState: Equatable {
    let contentOffset: CGPoint
    let contentSize: CGSize
    let viewportSize: CGSize
}

// MARK: - Scroll Visual Tokens

private enum ICOSScrollVisualTokens {
    static let verticalThumbWidth: CGFloat = 3
    static let verticalThumbHeight: CGFloat = 32
    static let verticalThumbCornerRadius: CGFloat = 2
    static let verticalThumbOpacity: Double = 1
    static let verticalThumbTrailingInset: CGFloat = 2
    static let hideDelayNanoseconds: UInt64 = 700_000_000
}

// MARK: - Preview

#Preview {
    ICOSScrollView {
        VStack(spacing: ICOSSpacing.md) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: ICOSRadius.panel, style: .continuous)
                    .fill(ICOSMaterials.showsLayeredSurfaces ? ICOSMaterials.floatingSurface : .clear)
                    .frame(height: 72)
                    .overlay {
                        Text("Scroll Item \(index + 1)")
                            .foregroundStyle(ICOSColors.textPrimary)
                    }
            }
        }
        .padding(.horizontal, ICOSSpacing.xl)
    }
    .frame(width: 420, height: 520)
    .background(ICOSMaterials.workspaceBackground)
}
