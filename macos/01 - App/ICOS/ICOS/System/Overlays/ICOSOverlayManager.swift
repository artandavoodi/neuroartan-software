import SwiftUI
import Combine

// MARK: - Overlay Manager

final class ICOSOverlayManager: ObservableObject {
    
    @Published var activeOverlay: ICOSOverlay? = nil
    
    func present(_ overlay: ICOSOverlay) {
        activeOverlay = overlay
    }
    
    func dismiss() {
        activeOverlay = nil
    }
}

// MARK: - Overlay Types

enum ICOSOverlay: Identifiable {
    case commandPalette
    case settings
    case modal(message: String)
    
    var id: String {
        switch self {
        case .commandPalette: return "commandPalette"
        case .settings: return "settings"
        case .modal(let message): return "modal_\(message)"
        }
    }
}

// MARK: - Overlay Container View

struct ICOSOverlayContainer: View {
    @EnvironmentObject var overlayManager: ICOSOverlayManager
    
    var body: some View {
        ZStack {
            if let overlay = overlayManager.activeOverlay {
                ICOSMaterials.overlayScrim.opacity(ICOSOverlayTokens.scrimOpacity)
                    .ignoresSafeArea()
                    .onTapGesture { overlayManager.dismiss() }
                
                overlayView(overlay)
            }
        }
        .animation(.easeInOut(duration: ICOSShellTokens.shellVisibilityAnimationDuration), value: overlayManager.activeOverlay != nil)
    }
    
    @ViewBuilder
    private func overlayView(_ overlay: ICOSOverlay) -> some View {
        switch overlay {
        case .commandPalette:
            Text("Command Palette")
                .font(ICOSTypography.body)
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(ICOSOverlayTokens.contentPadding)
                .background {
                    if ICOSMaterials.showsLayeredSurfaces {
                        RoundedRectangle(
                            cornerRadius: ICOSOverlayTokens.cornerRadius,
                            style: .continuous
                        )
                        .fill(ICOSMaterials.elevatedSurface)
                    }
                }
                .overlay {
                    if ICOSMaterials.showsSurfaceBorders {
                        RoundedRectangle(
                            cornerRadius: ICOSOverlayTokens.cornerRadius,
                            style: .continuous
                        )
                        .strokeBorder(
                            ICOSMaterials.softStroke,
                            lineWidth: ICOSMaterials.softStrokeWidth
                        )
                    }
                }
        case .settings:
            Text("Settings")
                .font(ICOSTypography.body)
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(ICOSOverlayTokens.contentPadding)
                .background {
                    if ICOSMaterials.showsLayeredSurfaces {
                        RoundedRectangle(
                            cornerRadius: ICOSOverlayTokens.cornerRadius,
                            style: .continuous
                        )
                        .fill(ICOSMaterials.elevatedSurface)
                    }
                }
                .overlay {
                    if ICOSMaterials.showsSurfaceBorders {
                        RoundedRectangle(
                            cornerRadius: ICOSOverlayTokens.cornerRadius,
                            style: .continuous
                        )
                        .strokeBorder(
                            ICOSMaterials.softStroke,
                            lineWidth: ICOSMaterials.softStrokeWidth
                        )
                    }
                }
        case .modal(let message):
            VStack(spacing: ICOSOverlayTokens.modalSpacing) {
                Text(message)
                    .font(ICOSTypography.body)
                    .foregroundStyle(ICOSColors.textPrimary)

                ICOSButton("Close", icon: .close, role: .secondary) {
                    overlayManager.dismiss()
                }
            }
            .padding(ICOSOverlayTokens.contentPadding)
            .background {
                if ICOSMaterials.showsLayeredSurfaces {
                    RoundedRectangle(
                        cornerRadius: ICOSOverlayTokens.cornerRadius,
                        style: .continuous
                    )
                    .fill(ICOSMaterials.elevatedSurface)
                }
            }
            .overlay {
                if ICOSMaterials.showsSurfaceBorders {
                    RoundedRectangle(
                        cornerRadius: ICOSOverlayTokens.cornerRadius,
                        style: .continuous
                    )
                    .strokeBorder(
                        ICOSMaterials.softStroke,
                        lineWidth: ICOSMaterials.softStrokeWidth
                    )
                }
            }
        }
    }
}
