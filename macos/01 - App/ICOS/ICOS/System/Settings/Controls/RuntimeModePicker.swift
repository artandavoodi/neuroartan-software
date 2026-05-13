import SwiftUI

// MARK: - Runtime Mode Picker

struct RuntimeModePicker: View {
    @Binding var selection: RuntimeMode

    var body: some View {
        Picker("Runtime mode", selection: $selection) {
            ForEach(RuntimeMode.allCases) { mode in
                Text(mode.title).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
}
