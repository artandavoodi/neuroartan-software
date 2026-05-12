import SwiftUI

struct ICOSBootGate<Content: View>: View {
    private let dismissalDuration = 0.04

    @AppStorage("icos.skipBootAnimation") private var skipBootAnimation = false
    @State private var bootFinished: Bool

    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        let envSkip = ProcessInfo.processInfo.environment["ICOS_SKIP_BOOT"] == "1"
        _bootFinished = State(initialValue: envSkip)
    }

    var body: some View {
        let isBootComplete = bootFinished || skipBootAnimation

        ZStack {
            content()
                .environment(\.icosBootAnimationFinished, isBootComplete)

            if !isBootComplete {
                ICOSBootAnimationView {
                    withAnimation(.easeOut(duration: dismissalDuration)) {
                        bootFinished = true
                    }
                }
                .transition(.opacity.animation(.easeOut(duration: dismissalDuration)))
                .zIndex(1)
            }
        }
    }
}

private struct ICOSBootAnimationFinishedKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var icosBootAnimationFinished: Bool {
        get { self[ICOSBootAnimationFinishedKey.self] }
        set { self[ICOSBootAnimationFinishedKey.self] = newValue }
    }
}
