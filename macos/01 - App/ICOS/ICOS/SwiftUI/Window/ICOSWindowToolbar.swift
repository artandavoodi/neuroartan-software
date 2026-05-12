import AppKit
import SwiftUI

// MARK: - ICOS Window Toolbar

/// Native AppKit toolbar owner for Finder/Xcode-style titlebar integration.
/// This owner must not replace, hide, or custom-draw native Apple window controls.
enum ICOSWindowToolbar {
    private static let delegate = ICOSWindowToolbarDelegate()

    static func build() -> NSToolbar {
        let toolbar = NSToolbar(identifier: NSToolbar.Identifier("ICOSWindowToolbar"))

        toolbar.displayMode = .iconOnly
        toolbar.sizeMode = .regular
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.showsBaselineSeparator = false
        toolbar.delegate = delegate

        return toolbar
    }
}

// MARK: - Toolbar Item Identifiers

private extension NSToolbarItem.Identifier {
    static let icosSearch = NSToolbarItem.Identifier("ICOSWindowToolbar.Search")
    static let icosNavigation = NSToolbarItem.Identifier("ICOSWindowToolbar.Navigation")
}

// MARK: - ICOS Window Toolbar Delegate

private final class ICOSWindowToolbarDelegate: NSObject, NSToolbarDelegate {


    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .icosSearch,
            .icosNavigation,
            .flexibleSpace
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .icosSearch,
            .icosNavigation,
            .flexibleSpace,
            .space
        ]
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .icosSearch:
            return searchItem()
        case .icosNavigation:
            return navigationItem()
        default:
            return nil
        }
    }

    private func navigationItem() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: .icosNavigation)
        item.label = "Navigation"
        item.paletteLabel = "Navigation"
        item.toolTip = "Navigation"
        item.isBordered = false

        let hostingView = NSHostingView(
            rootView: ICOSTitlebarNavigationHostView()
        )
        hostingView.frame = NSRect(
            x: 0,
            y: 0,
            width: ICOSWindowTokens.titlebarNavigationToolbarWidth,
            height: ICOSWindowTokens.titlebarNavigationAccessoryHeight
        )
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        hostingView.layer?.isOpaque = false

        item.view = hostingView
        return item
    }

    private func searchItem() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: .icosSearch)
        item.label = "Search"
        item.paletteLabel = "Search"
        item.toolTip = "Search"
        item.target = self
        item.action = #selector(toggleSearch)
        item.isBordered = false

        let button = NSHostingView(
            rootView: SVGImageView(icon: .search)
                .frame(
                    width: ICOSWindowTokens.titlebarButtonIconSize,
                    height: ICOSWindowTokens.titlebarButtonIconSize
                )
                .contentShape(Rectangle())
                .onTapGesture { [weak self] in
                    self?.toggleSearch()
                }
                .foregroundStyle(.primary)
                .help("Search")
        )
        button.frame.size = NSSize(
            width: ICOSWindowTokens.titlebarButtonSize,
            height: ICOSWindowTokens.titlebarButtonSize
        )
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.clear.cgColor
        button.layer?.isOpaque = false

        item.view = button
        return item
    }

    @objc private func toggleSearch() {
        NotificationCenter.default.post(
            name: .icosToggleSearch,
            object: nil
        )
    }
}
