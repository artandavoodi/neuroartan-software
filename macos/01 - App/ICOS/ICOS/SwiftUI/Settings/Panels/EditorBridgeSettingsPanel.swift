import SwiftUI

struct EditorBridgeSettingsPanel: View {
    @ObservedObject var editorBridge: ExternalEditorBridge

    var body: some View {
        SettingsSectionCard(title: "Editor Bridge", icon: .configuration) {
            WorktreeRow(
                name: "Visual Studio Code",
                state: editorBridge.vscodeAvailable ? "Detected" : "Not detected",
                icon: editorBridge.vscodeAvailable ? .success : .error
            )
            WorktreeRow(
                name: "Xcode",
                state: editorBridge.xcodeAvailable ? "Detected" : "Not detected",
                icon: editorBridge.xcodeAvailable ? .success : .error
            )
            WorktreeRow(
                name: "Active file bridge",
                state: editorBridge.lastEditorState?.activeFilePath.isEmpty == false ? "Ready" : "Waiting",
                icon: editorBridge.lastEditorState == nil ? .loading : .success
            )

            Text(editorBridge.vscodeExtensionBridgePath)
                .font(.system(size: ICOSControlTokens.editorBridgePathFontSize, design: .monospaced))
                .foregroundStyle(ICOSColors.textSecondary)
                .textSelection(.enabled)

            HStack(spacing: ICOSSpacing.sm) {
                ICOSButton("Refresh Editors") {
                    editorBridge.refreshAvailability()
                    editorBridge.refreshActiveEditorState()
                }

                Text(editorBridge.statusText)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
    }
}
