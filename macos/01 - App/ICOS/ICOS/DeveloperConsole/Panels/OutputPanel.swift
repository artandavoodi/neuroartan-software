import SwiftUI

struct OutputPanel: View {
    
    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }
    
    @ObservedObject var appState: ICOSAppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Output")
                .font(.system(size: ICOSOutputPanelTokens.titleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(ICOSOutputPanelTokens.titlePadding)
            
            Divider()
                .background(ICOSMaterials.separator)
            
            ICOSScrollView {
                Text(appState.activeSession.currentOutput.isEmpty ? "[Execution Output Pending]" : appState.activeSession.currentOutput)
                    .font(.system(size: ICOSOutputPanelTokens.outputFontSize, weight: .regular, design: .monospaced))
                    .foregroundStyle(ICOSColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(ICOSOutputPanelTokens.outputPadding)
            }
            .background(ICOSMaterials.panelBackground)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


private enum ICOSOutputPanelTokens {
    static let titleFontSize: CGFloat = 13
    static let titlePadding: CGFloat = ICOSSpacing.md
    static let outputFontSize: CGFloat = 13
    static let outputPadding: CGFloat = ICOSSpacing.md
}