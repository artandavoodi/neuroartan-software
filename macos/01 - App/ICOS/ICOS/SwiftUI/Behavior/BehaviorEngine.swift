import SwiftUI
import Combine

/// ICOS Behavior Engine
/// Mirrors website behavior-driven UI system (state, overlays, motion)
public final class BehaviorEngine: ObservableObject {

    // MARK: - Global State
    @Published public var isOverlayPresented: Bool = false
    @Published public var activeOverlay: OverlayType? = nil
    @Published public var motionEnabled: Bool = true

    // MARK: - Overlay Types
    public enum OverlayType {
        case account
        case settings
        case system
    }

    // MARK: - Overlay Control
    public func present(_ overlay: OverlayType) {
        activeOverlay = overlay
        isOverlayPresented = true
    }

    public func dismissOverlay() {
        activeOverlay = nil
        isOverlayPresented = false
    }

    // MARK: - Motion Control
    public func toggleMotion() {
        motionEnabled.toggle()
    }

    // MARK: - State Reset
    public func reset() {
        activeOverlay = nil
        isOverlayPresented = false
        motionEnabled = true
    }

    @ViewBuilder
    private func overlayContent(_ type: OverlayType) -> some View {
        switch type {
        case .account:
            Text("Account Overlay")
                .padding()
                .background(ICOSMaterials.elevatedSurface)

        case .settings:
            Text("Settings Overlay")
                .padding()
                .background(ICOSMaterials.elevatedSurface)

        case .system:
            Text("System Overlay")
                .padding()
                .background(ICOSMaterials.elevatedSurface)
        }
    }

    // MARK: - Overlay Renderer
    public var overlayView: some View {
        Group {
            if let active = activeOverlay, isOverlayPresented {
                overlayContent(active)
                    .transition(.opacity)
            } else {
                EmptyView()
            }
        }
    }
}
