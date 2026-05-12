import SwiftUI

// MARK: - Developer Runtime Shell

struct DeveloperRuntimeShell: View {

    @ObservedObject var appState: ICOSAppState
    @State private var isSidebarVisible = true
    @State private var isInspectorVisible = true

    var body: some View {
        HStack(alignment: .top, spacing: ICOSShellTokens.shellSectionSpacing) {
            if isSidebarVisible {
                DeveloperRuntimeSidebar()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: ICOSShellTokens.workspaceRadius,
                            style: .continuous
                        )
                    )
            }

            DeveloperRuntimeCanvas()
                .environmentObject(SystemServices.shared.developerWorkspaceService)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: ICOSShellTokens.workspaceRadius,
                        style: .continuous
                    )
                )
                .layoutPriority(1)

            if isInspectorVisible {
                DeveloperRuntimeInspector()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: ICOSShellTokens.workspaceRadius,
                            style: .continuous
                        )
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: ICOSMotion.panelStateDuration), value: isSidebarVisible)
        .animation(.easeInOut(duration: ICOSMotion.panelStateDuration), value: isInspectorVisible)
        .onReceive(
            NotificationCenter.default.publisher(
                for: .icosToggleSidebar
            )
        ) { _ in
            isSidebarVisible.toggle()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .icosToggleInspector
            )
        ) { _ in
            isInspectorVisible.toggle()
        }
    }
}

#Preview {
    DeveloperRuntimeShell(
        appState: .preview()
    )
    .environmentObject(SystemServices.preview().developerWorkspaceService)
    .frame(
        width: ICOSRuntimeShellTokens.previewWidth,
        height: ICOSRuntimeShellTokens.previewHeight
    )
}
