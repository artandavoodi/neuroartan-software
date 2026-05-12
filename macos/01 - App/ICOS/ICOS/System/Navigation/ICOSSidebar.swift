import SwiftUI

struct ICOSSidebar: View {

    @ObservedObject var appState: ICOSAppState
    let onSelectWorkspaceRoute: (AppRouter.Route) -> Void

    @State private var searchText: String = ""
    @State private var isCollapsed: Bool = false

    var body: some View {
        HStack(spacing: ICOSShellTokens.shellSectionSpacing) {
            LeftIconRail(
                isCollapsed: $isCollapsed,
                activeRoute: appState.activeView,
                onSelect: { route in
                    handle(route: route)
                }
            )

            if !isCollapsed {
                SidebarContentPanel(
                    activeRoute: appState.activeView,
                    onSelect: { route in
                        handle(route: route)
                    },
                    onSelectWorkspaceRoute: onSelectWorkspaceRoute,
                    onTalk: {
                        appState.activeView = .developerConsole
                    },
                    searchText: $searchText
                )
            }
        }
        .frame(
            width: isCollapsed
            ? ICOSSidebarTokens.collapsedWidth
            : ICOSSidebarTokens.legacySidebarExpandedWidth
        )
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    // MARK: - Route Handling

    private func handle(route: ICOSRoute) {
        appState.activeView = route
    }
}

#Preview {
    ICOSSidebar(
        appState: .preview(),
        onSelectWorkspaceRoute: { _ in }
    )
    .frame(width: ICOSSidebarTokens.legacySidebarExpandedWidth, height: 760)
}
