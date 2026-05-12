import SwiftUI

// MARK: - ICOS Container

struct ICOSContainer: View {
    private var appState: ICOSAppState

    init(appState: ICOSAppState) {
        self.appState = appState
    }

    var body: some View {
        ThemeProvider {
            ICOSLayout(appState: appState) {
                ICOSMainShell(appState: appState)
            }
        }
    }
}
