import SwiftUI

// MARK: - Top Bar View
// Deprecated visual shell owner.
// Runtime shells must use native titlebar accessories instead of in-canvas top bars.

struct TopBarView: View {
    @ObservedObject var router: AppRouter
    @ObservedObject var shellState: ShellState

    var body: some View {
        EmptyView()
    }
}
