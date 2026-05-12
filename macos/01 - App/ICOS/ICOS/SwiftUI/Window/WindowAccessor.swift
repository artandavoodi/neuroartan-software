import SwiftUI
import AppKit

/* =============================================================================
   WINDOW ACCESSOR
   Native NSWindow resolver for production window orchestration.
============================================================================= */

struct WindowAccessor: NSViewRepresentable {

    let onResolve: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()

        DispatchQueue.main.async {
            guard let window = view.window else {
                return
            }

            onResolve(window)
        }

        return view
    }

    func updateNSView(
        _ nsView: NSView,
        context: Context
    ) {
        DispatchQueue.main.async {
            guard let window = nsView.window else {
                return
            }

            onResolve(window)
        }
    }
}
