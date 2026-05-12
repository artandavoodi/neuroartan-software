import AppKit
import Combine
import SwiftUI

// MARK: - ICOS Window Toolbar

/// Native AppKit toolbar owner for Finder/Xcode-style titlebar integration.
/// This owner must not replace, hide, or custom-draw native Apple window controls.
enum ICOSWindowToolbar {
    fileprivate static let delegate = ICOSWindowToolbarDelegate()

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

    /// Applies visibility to the search + navigation hosting views once the delegate has created them.
    @MainActor
    static func setSupplementaryToolbarItemViewsHidden(_ hidden: Bool) {
        delegate.setSupplementaryToolbarItemViewsHidden(hidden)
    }
}

// MARK: - Toolbar Item Identifiers

private extension NSToolbarItem.Identifier {
    static let icosSearch = NSToolbarItem.Identifier("ICOSWindowToolbar.Search")
    static let icosNavigation = NSToolbarItem.Identifier("ICOSWindowToolbar.Navigation")
}

// MARK: - ICOS Window Toolbar Delegate

@MainActor
private final class ICOSWindowToolbarDelegate: NSObject, NSToolbarDelegate {

    private weak var navigationItemView: NSView?
    private weak var searchItemView: NSView?

    @MainActor
    fileprivate func setSupplementaryToolbarItemViewsHidden(_ hidden: Bool) {
        navigationItemView?.isHidden = hidden
        searchItemView?.isHidden = hidden
    }

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
        navigationItemView = hostingView
        ICOSWindowChrome.supplementaryChromeViewsDidInstall()
        return item
    }

    private func searchItem() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: .icosSearch)
        item.label = "Search"
        item.paletteLabel = "Search"
        item.toolTip = "Search"
        item.isBordered = false

        let button = NSHostingView(
            rootView: ICOSTitlebarToolbarSearchControl()
        )
        button.frame.size = NSSize(
            width: ICOSWindowTokens.titlebarButtonSize,
            height: ICOSWindowTokens.titlebarButtonSize
        )
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.clear.cgColor
        button.layer?.isOpaque = false

        item.view = button
        searchItemView = button
        ICOSWindowChrome.supplementaryChromeViewsDidInstall()
        return item
    }
}

// MARK: - Titlebar search (toolbar)

/// Hosted outside the main SwiftUI tree; re-renders on `icosMaterialAppearanceDidApply` so template
/// icons pick up updated `ICOSMaterials` / `ICOSColors` immediately.
private struct ICOSTitlebarToolbarSearchControl: View {
    @State private var materialRenderEpoch: UInt = 0

    var body: some View {
        SVGImageView(icon: .search)
            .frame(
                width: ICOSWindowTokens.titlebarButtonIconSize,
                height: ICOSWindowTokens.titlebarButtonIconSize
            )
            .contentShape(Rectangle())
            .onTapGesture {
                NotificationCenter.default.post(name: .icosToggleSearch, object: nil)
            }
            .foregroundStyle(ICOSColors.textPrimary)
            .help("Search")
            .id(materialRenderEpoch)
            .onReceive(NotificationCenter.default.publisher(for: .icosMaterialAppearanceDidApply)) { _ in
                materialRenderEpoch += 1
            }
    }
}
