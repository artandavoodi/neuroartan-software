import SwiftUI

struct SidebarView: View {
    @ObservedObject var router: AppRouter
    @ObservedObject var shellState: ShellState
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(spacing: 0) {

            ICOSScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.sectionGroupSpacing)) {
                    primaryNavigation

                    recentSessionsBlock
                }
                .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))
                .padding(.top, scaled(ICOSSidebarTokens.accountOuterPadding))
                .padding(.bottom, scaled(ICOSSidebarTokens.contentBottomPadding))
            }
        }
        .frame(width: shellState.isSidebarCollapsed ? ICOSSidebarTokens.collapsedWidth : ICOSSidebarTokens.expandedWidth)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }

    private var primaryNavigation: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.sectionSpacing)) {
            ForEach(SidebarSection.all) { section in
                sectionBlock(section)
            }
        }
    }

    private var recentSessionsBlock: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.rowSpacing)) {
            if !shellState.isSidebarCollapsed {
                Text("RECENT")
                    .font(.system(size: scaledFont(ICOSSidebarTokens.sectionLabelFontSize), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .tracking(ICOSSidebarTokens.sectionLabelTracking)
                    .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
            }
        }
    }

    private func sectionBlock(_ section: SidebarSection) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.rowSpacing)) {
            Button {
                shellState.toggleSection(section)
            } label: {
                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    SVGImageView(icon: section.icon)
                        .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))
                    if !shellState.isSidebarCollapsed {
                        Text(section.title)
                            .font(.system(size: scaledFont(ICOSSidebarTokens.sectionLabelFontSize), weight: .semibold))
                            .foregroundStyle(ICOSSidebarColors.textSecondary)
                        Spacer()
                        SVGImageView(icon: shellState.expandedSections.contains(section.id) ? .chevronUp : .chevronRight)
                            .frame(width: scaled(ICOSSidebarTokens.iconXS), height: scaled(ICOSSidebarTokens.iconXS))
                            .foregroundStyle(ICOSSidebarColors.textSecondary)
                    }
                }
                .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
                .padding(.vertical, scaled(ICOSSidebarTokens.sectionHeaderVerticalPadding))
            }
            .buttonStyle(.plain)

            if shellState.expandedSections.contains(section.id) || shellState.isSidebarCollapsed {
                ForEach(section.items) { route in
                    sidebarButton(title: route.title, icon: route.icon, isActive: isRouteActive(route)) {
                        if route.isSettingsCategory {
                            router.openSettings(route)
                        } else {
                            router.navigate(to: route)
                        }
                    }
                }
            }
        }
    }

    private func isRouteActive(_ route: AppRouter.Route) -> Bool {
        if route.isSettingsCategory {
            return router.selectedSettingsCategory == route && router.currentRoute == .settings
        }

        return router.currentRoute == route
    }

    private func sidebarButton(title: String, icon: ICOSIcon, isActive: Bool, isMinimal: Bool = false, action: @escaping () -> Void) -> some View {
        Button {
            action()
            NotificationCenter.default.post(name: .icosSetSidebarVisibility, object: false)
            NotificationCenter.default.post(name: .icosSetSecondarySidebarVisibility, object: false)
        } label: {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                SVGImageView(icon: icon)
                    .frame(width: scaled(ICOSSidebarTokens.iconMD), height: scaled(ICOSSidebarTokens.iconMD))
                    .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)

                if !shellState.isSidebarCollapsed {
                    Text(title)
                        .font(.system(size: scaledFont(ICOSSidebarTokens.rowTitleFontSize), weight: isActive ? .semibold : .regular))
                        .lineLimit(ICOSSidebarTokens.rowTitleLineLimit)
                        .foregroundStyle(isActive ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                    Spacer()
                }
            }
            .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
            .padding(.vertical, scaled(ICOSSidebarTokens.rowVerticalPadding))
            .background(
                RoundedRectangle(
                    cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                    style: .continuous
                )
                .fill(
                    isMinimal
                    ? ICOSSidebarColors.background.opacity(ICOSSidebarTokens.inactiveRowOpacity)
                    : (isActive ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.background.opacity(ICOSSidebarTokens.inactiveRowOpacity))
                )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(title)
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}
