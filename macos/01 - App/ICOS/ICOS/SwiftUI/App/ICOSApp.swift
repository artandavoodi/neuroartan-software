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

                    ICOSBootGate {
                        coordinator.rootView()
                    }
                        .environmentObject(themeState)
                        .preferredColorScheme(themeState.colorScheme)
                        .environment(\.icosThemeDensity, themeState.density)
                        .environment(\.icosTypographyScale, themeState.typographyScale)
                        .onChange(of: themeState.mode) { _, _ in
                            themeState.saveAndApplyRuntimeTheme()
                        }
                        .onChange(of: themeState.palette) { _, _ in
                            themeState.saveAndApplyRuntimeTheme()
                        }
                        .onChange(of: themeState.contrast) { _, _ in
                            themeState.saveAndApplyRuntimeTheme()
                        }
                        .onChange(of: themeState.density) { _, _ in
                            themeState.saveAndApplyRuntimeTheme()
                        }
                        .onChange(of: themeState.typographyScale) { _, _ in
                            themeState.saveAndApplyRuntimeTheme()
                        }
                        .onAppear {
                            themeState.applyRuntimeTheme()
                        }
                        .background(
                            WindowAccessor { window in
                                windowCoordinator.register(window: window)
                            }
                        )
                }
            }
            .frame(minWidth: 1120, minHeight: 720)
        }
    }
}
