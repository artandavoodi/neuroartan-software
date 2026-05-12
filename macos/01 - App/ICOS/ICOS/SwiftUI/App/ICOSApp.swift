import SwiftUI
import Foundation

/* =============================================================================
   00) PREVIEW DETECTION
============================================================================= */
private extension ProcessInfo {

    var isRunningSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

@main
struct ICOSApp: App {
    @StateObject private var coordinator = UIRootCoordinator()
    @StateObject private var windowCoordinator = ICOSWindowCoordinator.shared
    @StateObject private var themeState = ThemeState()

    private let isPreview = ProcessInfo.processInfo
        .isRunningSwiftUIPreview

    var body: some Scene {
        WindowGroup {

            VStack(spacing: 0) {

                if isPreview {

                    Text("ICOS Preview Runtime")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {

                    ICOSAppRootView(
                        coordinator: coordinator,
                        themeState: themeState,
                        windowCoordinator: windowCoordinator
                    )
                }
            }
            .frame(minWidth: 1120, minHeight: 720)
        }
    }
}

// MARK: - Root theme + window chrome

/// Binds SwiftUI refresh to `ThemeState.runtimeSignature` so static `ICOSMaterials` consumers redraw
/// immediately (same contract as `ThemeProvider`). Tracks system appearance when mode is `.system`.
private struct ICOSAppRootView: View {
    @ObservedObject var coordinator: UIRootCoordinator
    @ObservedObject var themeState: ThemeState
    @ObservedObject var windowCoordinator: ICOSWindowCoordinator
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        ICOSBootGate {
            coordinator.rootView()
        }
        .environmentObject(themeState)
        .preferredColorScheme(themeState.colorScheme)
        .environment(\.icosThemeDensity, themeState.density)
        .environment(\.icosTypographyScale, themeState.typographyScale)
        .id(themeState.runtimeSignature)
        .onAppear {
            themeState.updateSystemColorScheme(systemColorScheme)
            themeState.applyRuntimeTheme()
        }
        .onChange(of: themeState.runtimeSignature) { _, _ in
            ICOSWindowChrome.applyMaterialIdentityTransitionChromePolicy()
        }
        .onChange(of: systemColorScheme) { _, newValue in
            themeState.updateSystemColorScheme(newValue)
        }
        .background(
            WindowAccessor { window in
                windowCoordinator.register(window: window)
            }
        )
    }
}
