import SwiftUI
import Combine

// MARK: - ICOS Titlebar Navigation Host View

struct ICOSTitlebarNavigationHostView: View {
    @State private var titlebarNavigationTitle: String?
    @State private var canNavigateBack = false
    @State private var canNavigateForward = false
    @State private var isTitlebarNavigationVisible = false
    @State private var settingsSidebarRightEdgeX: CGFloat = 0
    @State private var titlebarHostLeadingX: CGFloat = 0
    @State private var materialRenderEpoch: UInt = 0

    var body: some View {
        Group {
            if isTitlebarNavigationVisible, let titlebarNavigationTitle {
                titlebarNavigationCluster(title: titlebarNavigationTitle)
            }
        }
        .id(materialRenderEpoch)
        .onReceive(NotificationCenter.default.publisher(for: .icosMaterialAppearanceDidApply)) { _ in
            materialRenderEpoch += 1
        }
        .offset(x: settingsSidebarRightEdgeX - titlebarHostLeadingX)
        .background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        titlebarHostLeadingX = proxy.frame(in: .global).minX
                    }
                    .onChange(of: proxy.frame(in: .global).minX) { _, newValue in
                        titlebarHostLeadingX = newValue
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosTitlebarNavigationStateDidChange)) { notification in
            guard let state = notification.object as? ICOSTitlebarNavigationState else {
                return
            }

            titlebarNavigationTitle = state.title
            canNavigateBack = state.canNavigateBack
            canNavigateForward = state.canNavigateForward
            isTitlebarNavigationVisible = state.isVisible
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosSettingsSidebarTitlebarAlignmentDidChange)) { notification in
            guard let offset = notification.object as? CGFloat else {
                return
            }

            settingsSidebarRightEdgeX = offset
        }
        .onAppear {
            NotificationCenter.default.post(
                name: .icosTitlebarNavigationRefreshRequested,
                object: nil
            )
        }
    }

    // MARK: - Navigation Cluster

    private func titlebarNavigationCluster(title: String) -> some View {
        HStack(spacing: ICOSWindowTokens.titlebarNavigationClusterSpacing) {
            HStack(spacing: ICOSWindowTokens.titlebarNavigationButtonSpacing) {
                titlebarNavigationButton(
                    icon: .chevronLeft,
                    label: "Back",
                    isEnabled: canNavigateBack,
                    notificationName: .icosTitlebarNavigateBack
                )

                titlebarNavigationButton(
                    icon: .chevronRight,
                    label: "Forward",
                    isEnabled: canNavigateForward,
                    notificationName: .icosTitlebarNavigateForward
                )
            }
            .frame(
                width: ICOSWindowTokens.titlebarNavigationButtonClusterWidth,
                alignment: .leading
            )

            Text(title)
                .font(.system(size: ICOSWindowTokens.titlebarNavigationTitleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
                .lineLimit(1)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
        .frame(
            width: ICOSWindowTokens.titlebarNavigationToolbarWidth,
            alignment: .leading
        )
    }

    private func titlebarNavigationButton(
        icon: ICOSIcon,
        label: String,
        isEnabled: Bool,
        notificationName: Notification.Name
    ) -> some View {
        Button {
            NotificationCenter.default.post(name: notificationName, object: nil)
        } label: {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSWindowTokens.titlebarNavigationIconSize,
                    height: ICOSWindowTokens.titlebarNavigationIconSize
                )
                .frame(
                    width: ICOSWindowTokens.titlebarNavigationButtonSize,
                    height: ICOSWindowTokens.titlebarNavigationButtonSize
                )
                .contentShape(
                    RoundedRectangle(
                        cornerRadius: ICOSControlTokens.buttonCornerRadius,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .foregroundStyle(isEnabled ? ICOSColors.textPrimary : ICOSColors.textTertiary)
        .disabled(!isEnabled)
        .help(label)
    }
}