import SwiftUI

struct LeftIconRail: View {

    @Binding var isCollapsed: Bool

    let activeRoute: ICOSRoute
    let onSelect: (ICOSRoute) -> Void

    var body: some View {
        VStack(spacing: ICOSSidebarTokens.railItemSpacing) {
            SidebarRailButton(icon: .menu, isActive: false) {
                withAnimation(.easeInOut(duration: ICOSShellTokens.shellVisibilityAnimationDuration)) {
                    isCollapsed.toggle()
                }
            }
            .padding(.top, ICOSSidebarTokens.railTopPadding)

            Rectangle()
                .fill(ICOSSidebarColors.separator)
                .frame(height: ICOSShellTokens.sidebarSeparatorWidth)
                .padding(.horizontal, ICOSSidebarTokens.railSeparatorHorizontalPadding)
                .padding(.vertical, ICOSSidebarTokens.railSeparatorVerticalPadding)

            SidebarRailButton(
                icon: .workspace,
                isActive: activeRoute == .workspace
            ) {
                onSelect(.workspace)
            }

            SidebarRailButton(
                icon: .thought,
                isActive: activeRoute == .intelligence
            ) {
                onSelect(.intelligence)
            }

            SidebarRailButton(
                icon: .console,
                isActive: activeRoute == .developerConsole
            ) {
                onSelect(.developerConsole)
            }

            SidebarRailButton(
                icon: .operations,
                isActive: activeRoute == .operations
            ) {
                onSelect(.operations)
            }

            Spacer()
        }
        .frame(width: ICOSSidebarTokens.collapsedWidth)
        .frame(maxHeight: .infinity)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }
}

#Preview {
    LeftIconRail(
        isCollapsed: .constant(false),
        activeRoute: .workspace,
        onSelect: { _ in }
    )
    .frame(height: ICOSSidebarTokens.railPreviewHeight)
}
