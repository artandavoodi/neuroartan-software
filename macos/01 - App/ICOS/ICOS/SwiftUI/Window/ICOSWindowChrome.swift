import AppKit
import SwiftUI

// MARK: - ICOS Window Chrome

/// Single owner for native macOS window chrome.
/// Uses native AppKit window controls with native toolbar/titlebar accessories; no custom traffic-light controls are allowed.
enum ICOSWindowChrome {

    static func configure(window: NSWindow) {
        configureContentSurface(window: window)
        configureToolbar(window: window)
        configureTitlebar(window: window)
        configureStandardButtons(window: window)
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
