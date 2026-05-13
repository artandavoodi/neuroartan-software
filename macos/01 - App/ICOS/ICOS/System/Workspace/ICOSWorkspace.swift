import SwiftUI

struct ICOSWorkspace: View {

    @ObservedObject var appState: ICOSAppState

    var body: some View {
        ZStack {

            switch appState.activeView {
            case .developerConsole:
                EmptyView()

            case .workspace:
                EmptyView()

            case .intelligence:
                EmptyView()

            case .operations:
                EmptyView()

            case .settings:
                EmptyView()
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
