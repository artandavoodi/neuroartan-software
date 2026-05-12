import SwiftUI
import AppKit

// MARK: - SVG Rendering Bridge

struct SVGImageView: View {

    let icon: ICOSIcon

    @State private var resolvedImage: NSImage?

    var body: some View {
        Group {
            if let resolvedImage {
                Image(nsImage: resolvedImage)
                    .renderingMode(.template)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
            } else {
                Color.clear
            }
        }
        .scaledToFit()
        .id(icon.path)
        .task(id: icon.path) {
            resolvedImage = nil
            resolvedImage = SVGKitRenderer.shared.load(icon: icon)
        }
    }
}
