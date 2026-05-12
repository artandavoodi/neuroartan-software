import SwiftUI

/// ICOS Layout Engine
/// Defines deterministic UI layout system for all SwiftUI views
public struct LayoutEngine {

    // MARK: - Grid System
    public static let baseUnit: CGFloat = 4

    public static func spacing(_ multiplier: CGFloat) -> CGFloat {
        return baseUnit * multiplier
    }

    // MARK: - Layout Containers

    public struct VStackLayout<Content: View>: View {
        public let spacing: CGFloat
        public let content: Content

        public init(spacing: CGFloat = LayoutEngine.spacing(2), @ViewBuilder content: () -> Content) {
            self.spacing = spacing
            self.content = content()
        }

        public var body: some View {
            VStack(spacing: spacing) {
                content
            }
        }
    }

    public struct HStackLayout<Content: View>: View {
        public let spacing: CGFloat
        public let content: Content

        public init(spacing: CGFloat = LayoutEngine.spacing(2), @ViewBuilder content: () -> Content) {
            self.spacing = spacing
            self.content = content()
        }

        public var body: some View {
            HStack(spacing: spacing) {
                content
            }
        }
    }

    public struct ZStackLayout<Content: View>: View {
        public let content: Content

        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        public var body: some View {
            ZStack {
                content
            }
        }
    }
}
