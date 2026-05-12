import SwiftUI

struct SidebarContentPanel: View {

    let activeRoute: ICOSRoute
    let onSelect: (ICOSRoute) -> Void
    let onSelectWorkspaceRoute: (AppRouter.Route) -> Void
    let onTalk: () -> Void

    @Binding var searchText: String

    var body: some View {
        VStack(spacing: 0) {
            SidebarHeader(
                title: "ICOS",
                subtitle: "Developer Runtime",
                action: onTalk
            )

            SidebarSearchField(
                text: $searchText
            )
            .padding(.horizontal, ICOSSidebarTokens.searchOuterHorizontalPadding)
            .padding(.bottom, ICOSSidebarTokens.searchBottomPadding)

            WorkspacePanel(
                searchText: searchText,
                onSelectWorkspaceRoute: onSelectWorkspaceRoute
            )

            Spacer()

            SidebarFooter(
                statusText: "Runtime Online",
                isOnline: true
            )
        }
        .frame(width: ICOSSidebarTokens.contentPanelWidth)
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }
}

#Preview {
    SidebarContentPanel(
        activeRoute: .workspace,
        onSelect: { _ in },
        onSelectWorkspaceRoute: { _ in },
        onTalk: {},
        searchText: .constant("")
    )
    .frame(height: ICOSSidebarTokens.previewHeight)
}
