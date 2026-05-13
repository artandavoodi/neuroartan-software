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
    @State private var isFullscreen = false

    private var resolvedForeground: Color {
        if ICOSMaterials.mode == .light && isFullscreen {
            return .white
        }
        return ICOSColors.textPrimary
    }

    private var resolvedTertiaryForeground: Color {
        if ICOSMaterials.mode == .light && isFullscreen {
            return .white.opacity(0.4)
        }
        return ICOSColors.textTertiary
    }

    private func syncFullscreenState() {
        let window = NSApp.keyWindow ?? NSApp.mainWindow
        isFullscreen = window?.styleMask.contains(.fullScreen) == true
    }

    var body: some View {
        Group {
            if isTitlebarNavigationVisible, let titlebarNavigationTitle {
                titlebarNavigationCluster(title: titlebarNavigationTitle)
            }
        }
        .id(materialRenderEpoch)
        .onAppear {
            syncFullscreenState()
            NotificationCenter.default.post(
                name: .icosTitlebarNavigationRefreshRequested,
                object: nil
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .icosMaterialAppearanceDidApply)) { _ in
            materialRenderEpoch += 1
            syncFullscreenState()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didEnterFullScreenNotification)) { _ in
            syncFullscreenState()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didExitFullScreenNotification)) { _ in
            syncFullscreenState()
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
                .foregroundStyle(resolvedForeground)
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
        .foregroundStyle(isEnabled ? resolvedForeground : resolvedTertiaryForeground)
        .disabled(!isEnabled)
        .help(label)
    }
}