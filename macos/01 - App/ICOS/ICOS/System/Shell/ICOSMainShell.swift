import SwiftUI

// MARK: - ICOS Main Shell

struct ICOSMainShell: View {

    // MARK: - Properties

    @ObservedObject private var appState: ICOSAppState

    // MARK: - Initialization

    init(appState: ICOSAppState) {
        self._appState = ObservedObject(wrappedValue: appState)
    }

    // MARK: - Body

    var body: some View {
        NavigationShell(
            router: appState.router,
            appState: appState
        )
    }
}
