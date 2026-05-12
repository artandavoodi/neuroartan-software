import AppKit
import SwiftUI

// MARK: - ICOS Titlebar Toggle Accessory

struct ICOSTitlebarToggleAccessory: View {
    let onToggleSidebar: () -> Void
    let onToggleSecondarySidebar: () -> Void
    let onToggleBottomPanel: () -> Void

    @State private var isSidebarVisible = true
    @State private var isSecondarySidebarVisible = false
    @State private var isBottomPanelVisible = false

    var body: some View {
        HStack(spacing: ICOSWindowTokens.titlebarAccessorySpacing) {
            titlebarToggleButton(
                icon: isSidebarVisible ? .panelLeftActivated : .panelLeftDeactivated,
                label: "Toggle Sidebar",
                action: onToggleSidebar
            )

            titlebarToggleButton(
                icon: isBottomPanelVisible ? .panelBottomActivated : .panelBottomDeactivated,
                label: "Toggle Bottom Panel",
                action: onToggleBottomPanel
            )

            titlebarToggleButton(
                icon: isSecondarySidebarVisible ? .panelRightActivated : .panelRightDeactivated,
                label: "Toggle Secondary Sidebar",
                action: onToggleSecondarySidebar
            )
        }
        .padding(.trailing, ICOSWindowTokens.titlebarAccessoryTrailingPadding)
        .background(ICOSMaterials.hoverSurface.opacity(ICOSWindowTokens.titlebarAccessoryBackgroundOpacity))
        .onReceive(NotificationCenter.default.publisher(for: .icosSidebarVisibilityDidChange)) { notification in
            guard let isVisible = notification.object as? Bool else {
                return
            }

            isSidebarVisible = isVisible
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSecondarySidebarVisibilityDidChange)) { notification in
            guard let isVisible = notification.object as? Bool else {
                return
            }

            isSecondarySidebarVisible = isVisible
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosBottomPanelVisibilityDidChange)) { notification in
            guard let isVisible = notification.object as? Bool else {
                return
            }

            isBottomPanelVisible = isVisible
        }
    }

    // MARK: - Toggle Cluster

    private func titlebarToggleButton(icon: ICOSIcon, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSWindowTokens.titlebarButtonIconSize,
                    height: ICOSWindowTokens.titlebarButtonIconSize
                )
                .frame(
                    width: ICOSWindowTokens.titlebarButtonSize,
                    height: ICOSWindowTokens.titlebarButtonSize
                )
                .contentShape(RoundedRectangle(cornerRadius: ICOSControlTokens.buttonCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(ICOSColors.textPrimary)
        .help(label)
    }
}

// MARK: - ICOS Titlebar Navigation State

struct ICOSTitlebarNavigationState {
    let title: String
    let canNavigateBack: Bool
    let canNavigateForward: Bool
    let isVisible: Bool
}

// MARK: - ICOS Titlebar Accessory Host

enum ICOSTitlebarAccessoryHost {
    static func install(window: NSWindow) {
        removeExistingAccessories(from: window)
        installToggleAccessory(in: window)
    }

    // MARK: - Toggle Accessory

    private static func installToggleAccessory(in window: NSWindow) {
        let accessory = NSTitlebarAccessoryViewController()
        accessory.identifier = NSUserInterfaceItemIdentifier("ICOSTitlebarToggleAccessory")
        accessory.layoutAttribute = .right
        accessory.fullScreenMinHeight = ICOSWindowTokens.titlebarAccessoryHeight

        let hostingView = NSHostingView(
            rootView: ICOSTitlebarToggleAccessory(
                onToggleSidebar: {
                    NotificationCenter.default.post(
                        name: .icosToggleSidebar,
                        object: nil
                    )
                },
                onToggleSecondarySidebar: {
                    NotificationCenter.default.post(
                        name: .icosToggleSecondarySidebar,
                        object: nil
                    )
                },
                onToggleBottomPanel: {
                    NotificationCenter.default.post(
                        name: .icosToggleBottomPanel,
                        object: nil
                    )
                }
            )
        )
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        hostingView.frame.size = NSSize(
            width: ICOSWindowTokens.titlebarAccessoryWidth,
            height: ICOSWindowTokens.titlebarAccessoryHeight
        )

        accessory.view = hostingView
        window.addTitlebarAccessoryViewController(accessory)
    }

    // MARK: - Cleanup

    private static func removeExistingAccessories(from window: NSWindow) {
        for index in window.titlebarAccessoryViewControllers.indices.reversed() {
            let accessory = window.titlebarAccessoryViewControllers[index]
            let identifier = accessory.identifier?.rawValue ?? ""

            if identifier == "ICOSTitlebarUnifiedAccessory" || identifier == "ICOSTitlebarNavigationAccessory" || identifier == "ICOSTitlebarToggleAccessory" || identifier == "ICOSTitlebarAccessory" {
                window.removeTitlebarAccessoryViewController(at: index)
            }
        }
    }
}
