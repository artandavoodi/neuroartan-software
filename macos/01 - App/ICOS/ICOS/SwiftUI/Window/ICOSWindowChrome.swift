import AppKit
import SwiftUI

// MARK: - ICOS Window Chrome

/// Single owner for native macOS window chrome.
/// Uses native AppKit window controls with native toolbar/titlebar accessories; no custom traffic-light controls are allowed.
enum ICOSWindowChrome {

    // MARK: - Shell launch (boot gate)

    /// Whether the shell boot animation has finished (or was skipped). `false` hides supplementary
    /// titlebar chrome until the boot surface is dismissed.
    private(set) static var isShellBootAnimationComplete: Bool = false

    // MARK: - Material identity (SwiftUI `.id(themeState.runtimeSignature)`)

    private static var materialIdentityRevealToken: UInt64 = 0
    private static var isSuppressingForMaterialIdentity: Bool = false

    @MainActor
    static func configure(window: NSWindow) {
        configureContentSurface(window: window)
        configureToolbar(window: window)
        configureTitlebar(window: window)
        configureStandardButtons(window: window)

        applySupplementaryChromeVisibilityFromPolicy()

        DispatchQueue.main.async { @MainActor in
            applySupplementaryChromeVisibilityFromPolicy()
        }
    }

    /// Invoked from `ICOSBootGate` whenever boot completion changes.
    @MainActor
    static func setShellBootAnimationComplete(_ complete: Bool) {
        isShellBootAnimationComplete = complete
        applySupplementaryChromeVisibilityFromPolicy()
    }

    /// Invoked when toolbar items or titlebar accessories install their `NSHostingView`s so policy can run.
    @MainActor
    static func supplementaryChromeViewsDidInstall() {
        applySupplementaryChromeVisibilityFromPolicy()
    }

    /// Briefly hides ICOS supplementary titlebar chrome while the SwiftUI tree rebuilds for a new material signature.
    @MainActor
    static func applyMaterialIdentityTransitionChromePolicy() {
        materialIdentityRevealToken += 1
        let token = materialIdentityRevealToken
        setMaterialIdentitySuppression(true)

        DispatchQueue.main.async {
            guard token == materialIdentityRevealToken else { return }
            DispatchQueue.main.async {
                guard token == materialIdentityRevealToken else { return }
                setMaterialIdentitySuppression(false)
                NotificationCenter.default.post(
                    name: .icosMaterialAppearanceDidApply,
                    object: nil
                )
                NotificationCenter.default.post(
                    name: .icosTitlebarNavigationRefreshRequested,
                    object: nil
                )
            }
        }
    }

    // MARK: - Policy

    @MainActor
    private static func setMaterialIdentitySuppression(_ active: Bool) {
        isSuppressingForMaterialIdentity = active
        applySupplementaryChromeVisibilityFromPolicy()
    }

    @MainActor
    private static func applySupplementaryChromeVisibilityFromPolicy() {
        let hideForBoot = !isShellBootAnimationComplete
        let hideForMaterials = isSuppressingForMaterialIdentity
        let hidden = hideForBoot || hideForMaterials

        ICOSWindowToolbar.setSupplementaryToolbarItemViewsHidden(hidden)
        ICOSTitlebarAccessoryHost.setToggleAccessoryHostingViewHidden(hidden)
    }

    // MARK: - Titlebar

    private static func configureTitlebar(window: NSWindow) {
        window.title = ""
        window.titleVisibility = .hidden
        window.styleMask.remove(.borderless)
        window.styleMask.insert(.titled)
        window.styleMask.insert(.fullSizeContentView)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = false

        if #available(macOS 11.0, *) {
            window.titlebarSeparatorStyle = .none
        }
    }

    // MARK: - Content Surface

    private static func configureContentSurface(window: NSWindow) {
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
    }

    // MARK: - Toolbar

    private static func configureToolbar(window: NSWindow) {
        window.toolbar = ICOSWindowToolbar.build()

        if #available(macOS 11.0, *) {
            window.toolbarStyle = .unified
        }
    }

    // MARK: - Standard Buttons

    private static func configureStandardButtons(window: NSWindow) {
        window.standardWindowButton(.closeButton)?.isHidden = false
        window.standardWindowButton(.miniaturizeButton)?.isHidden = false
        window.standardWindowButton(.zoomButton)?.isHidden = false
    }
}
