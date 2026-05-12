import SwiftUI

struct InputPanel: View {
    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }
    
    @ObservedObject var appState: ICOSAppState
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Input")
                .font(.system(size: ICOSInputPanelTokens.titleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(ICOSInputPanelTokens.titlePadding)
            
            Divider()
                .background(ICOSMaterials.separator)
            
            TextEditor(text: $inputText)
                .font(.system(size: ICOSInputPanelTokens.editorFontSize, weight: .regular))
                .foregroundStyle(ICOSColors.textPrimary)
                .scrollContentBackground(.hidden)
                .padding(ICOSInputPanelTokens.editorPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ICOSMaterials.panelBackground)
            
            Divider()
                .background(ICOSMaterials.separator)
            
            ICOSButton("Execute", icon: .arrowUp, role: .primary) {
                print("EXECUTE CLICKED")
                Task {
                    await appState.orchestrator.process(input: inputText, appState: appState)
                }
            }
            .padding(ICOSInputPanelTokens.buttonPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private enum ICOSInputPanelTokens {
    static let titleFontSize: CGFloat = 13
    static let titlePadding: CGFloat = ICOSSpacing.md
    static let editorFontSize: CGFloat = 13
    static let editorPadding: CGFloat = ICOSSpacing.md
    static let buttonPadding: CGFloat = ICOSSpacing.md
}
