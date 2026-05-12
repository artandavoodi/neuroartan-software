import AppKit
import Combine
import SwiftUI

// MARK: - ICOS Window Coordinator

@MainActor
final class ICOSWindowCoordinator: ObservableObject {

    static let shared = ICOSWindowCoordinator()

    let objectWillChange = ObservableObjectPublisher()

    private weak var window: NSWindow?

    private init() {}

    // MARK: - Registration

    func register(window: NSWindow) {
        guard self.window !== window else {
            return
        }

        self.window = window

        configure(window: window)
    }

    // MARK: - Secondary Sidebar

    func toggleSecondarySidebar() {
        NotificationCenter.default.post(
            name: .icosToggleSecondarySidebar,
            object: nil
        )
    }

    func toggleBottomPanel() {
        NotificationCenter.default.post(
            name: .icosToggleBottomPanel,
            object: nil
        )
    }

    func toggleSearch() {
        NotificationCenter.default.post(
            name: .icosToggleSearch,
            object: nil
        )
    }

    // MARK: - Window Controls

    func closeWindow() {
        window?.performClose(nil)
    }

    func minimizeWindow() {
        window?.performMiniaturize(nil)
    }

    func zoomWindow() {
        window?.performZoom(nil)
    }

    // MARK: - Configuration

    private func configure(window: NSWindow) {
        ICOSWindowChrome.configure(window: window)
        ICOSTitlebarAccessoryHost.install(window: window)
    }
}

// MARK: - Notifications

extension Notification.Name {

    static let icosToggleSidebar = Notification.Name("ICOS.ToggleSidebar")
    static let icosToggleSecondarySidebar = Notification.Name("ICOS.ToggleSecondarySidebar")
    static let icosSetSidebarVisibility = Notification.Name("ICOS.SetSidebarVisibility")
    static let icosSetSecondarySidebarVisibility = Notification.Name("ICOS.SetSecondarySidebarVisibility")
    static let icosToggleBottomPanel = Notification.Name("ICOS.ToggleBottomPanel")
    static let icosToggleSearch = Notification.Name("ICOS.ToggleSearch")
    static let icosToggleInspector = Notification.Name("ICOS.ToggleDeveloperInspector")
    static let icosDeveloperReviewExpandedDidChange = Notification.Name("ICOS.DeveloperReviewExpandedDidChange")
    static let icosSetDeveloperReviewExpanded = Notification.Name("ICOS.SetDeveloperReviewExpanded")
    static let icosSidebarVisibilityDidChange = Notification.Name("ICOS.SidebarVisibilityDidChange")
    static let icosSecondarySidebarVisibilityDidChange = Notification.Name("ICOS.SecondarySidebarVisibilityDidChange")
    static let icosBottomPanelVisibilityDidChange = Notification.Name("ICOS.BottomPanelVisibilityDidChange")
    static let icosPrimaryShellSplitViewDidAttach = Notification.Name("ICOS.PrimaryShellSplitViewDidAttach")
    static let icosTitlebarNavigationStateDidChange = Notification.Name("ICOS.TitlebarNavigationStateDidChange")
    static let icosTitlebarNavigationRefreshRequested = Notification.Name("ICOS.TitlebarNavigationRefreshRequested")
    static let icosSettingsSidebarTitlebarAlignmentDidChange = Notification.Name("ICOS.SettingsSidebarTitlebarAlignmentDidChange")
    static let icosTitlebarNavigateBack = Notification.Name("ICOS.TitlebarNavigateBack")
    static let icosTitlebarNavigateForward = Notification.Name("ICOS.TitlebarNavigateForward")
    static let icosMaterialAppearanceDidApply = Notification.Name("ICOS.MaterialAppearanceDidApply")
}
