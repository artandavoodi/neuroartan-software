import SwiftUI

// MARK: - Theme Provider

struct ThemeProvider<Content: View>: View {

    @StateObject private var theme = ThemeState()
    @Environment(\.colorScheme) private var systemColorScheme

    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .environmentObject(theme)
            .preferredColorScheme(theme.colorScheme)
            .id(theme.runtimeSignature)
            .onAppear {
                theme.updateSystemColorScheme(systemColorScheme)
            }
            .onChange(of: systemColorScheme) { _, newValue in
                theme.updateSystemColorScheme(newValue)
            }
    }
}