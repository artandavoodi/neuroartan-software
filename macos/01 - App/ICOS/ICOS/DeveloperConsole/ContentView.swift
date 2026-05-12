import SwiftUI

// MARK: - Developer Console Content View

struct ContentView: View {
    @State private var terminalOutput: String = "Runtime awaiting execution."
    @State private var activeFile: String = "No active file detected"
    @State private var workspaceFiles: Int = 0

    init(appState: Any? = nil) {}

    var body: some View {
        runtimeDeveloperPanel
            .onAppear {
                bootRuntime()
            }
    }
}

// MARK: - Runtime Panels

private extension ContentView {

    var runtimeDeveloperPanel: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.runtimePanelSpacing) {
            Text("ICOS Runtime")
                .font(.system(size: ICOSDeveloperPanelTokens.runtimePanelTitleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            runtimeStatus

            Divider()
                .background(ICOSMaterials.separator)

            activeFilePanel

            Divider()
                .background(ICOSMaterials.separator)

            terminalPanel

            Spacer()
        }
        .padding(ICOSDeveloperPanelTokens.runtimePanelPadding)
        .frame(
            width: ICOSDeveloperPanelTokens.runtimePanelWidth,
            height: ICOSDeveloperPanelTokens.runtimePanelHeight
        )
        .background(ICOSMaterials.windowBackground)
    }

    var runtimeStatus: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.runtimeSectionSpacing) {
            sectionTitle("Runtime Status")

            runtimeLabel("Runtime Event Bus Online")
            runtimeLabel("Terminal Bridge Online")
            runtimeLabel("Patch Engine Online")
            runtimeLabel("Rollback Manager Online")
            runtimeLabel("Workspace Graph Online")
            runtimeLabel("Permission Gate Online")
        }
    }

    var activeFilePanel: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.runtimeSectionSpacing) {
            sectionTitle("Active File")

            Text(activeFile)
                .font(.system(size: ICOSDeveloperPanelTokens.runtimeMonoFontSize, design: .monospaced))
                .foregroundStyle(ICOSColors.textPrimary)
                .textSelection(.enabled)

            Text("Indexed Files: \(workspaceFiles)")
                .font(.system(size: ICOSDeveloperPanelTokens.runtimeMetaFontSize))
                .foregroundStyle(ICOSColors.textSecondary)
        }
    }

    var terminalPanel: some View {
        VStack(alignment: .leading, spacing: ICOSDeveloperPanelTokens.runtimeSectionSpacing) {
            sectionTitle("Terminal Output")

            ICOSScrollView {
                Text(terminalOutput)
                    .font(.system(size: ICOSDeveloperPanelTokens.runtimeMonoFontSize, design: .monospaced))
                    .foregroundStyle(ICOSColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
                    .padding(ICOSDeveloperPanelTokens.runtimeTerminalPadding)
            }
            .frame(height: ICOSDeveloperPanelTokens.runtimeTerminalHeight)
            .background(
                ICOSMaterials.floatingSurface,
                in: RoundedRectangle(cornerRadius: ICOSRadius.md, style: .continuous)
            )

            HStack(spacing: ICOSDeveloperPanelTokens.runtimeButtonSpacing) {
                ICOSButton("Run Runtime Test", icon: .terminal) {
                    runRuntimeTest()
                }

                ICOSButton("Index Workspace", icon: .workspace) {
                    indexWorkspace()
                }
            }
        }
    }
}

// MARK: - Runtime Components

private extension ContentView {

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: ICOSDeveloperPanelTokens.runtimeSectionTitleFontSize, weight: .semibold))
            .foregroundStyle(ICOSColors.textPrimary)
    }

    func runtimeLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: ICOSDeveloperPanelTokens.runtimeLabelFontSize))
            .foregroundStyle(ICOSColors.textSecondary)
    }
}

// MARK: - Runtime Actions

private extension ContentView {

    func bootRuntime() {
        activeFile = "No active file detected"
    }

    func runRuntimeTest() {
        terminalOutput = FileManager.default.currentDirectoryPath
    }

    func indexWorkspace() {
        let workspaceURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let enumerator = FileManager.default.enumerator(
            at: workspaceURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        var count = 0

        while let _ = enumerator?.nextObject() as? URL {
            count += 1
        }

        workspaceFiles = count
        terminalOutput = "Indexed \(count) files from \(workspaceURL.path)"
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
