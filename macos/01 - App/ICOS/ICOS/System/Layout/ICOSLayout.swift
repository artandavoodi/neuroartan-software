import SwiftUI

// MARK: - ICOS Layout

struct ICOSLayout<Content: View>: View {

    @ObservedObject private var appState: ICOSAppState
    private let content: () -> Content

    init(appState: ICOSAppState, @ViewBuilder content: @escaping () -> Content) {
        self._appState = ObservedObject(wrappedValue: appState)
        self.content = content
    }

    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
