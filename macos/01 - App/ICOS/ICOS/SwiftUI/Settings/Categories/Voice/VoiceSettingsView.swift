import SwiftUI

// MARK: - Voice Settings View

struct VoiceSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Voice",
            subtitle: "Input, output, wake behavior, training, and language.",
            tabs: [
                SettingsCategoryTabItem(id: "input", title: "Input") { AnyView(VoiceInputTab()) },
            SettingsCategoryTabItem(id: "language", title: "Language") { AnyView(VoiceLanguageTab()) },
            SettingsCategoryTabItem(id: "output", title: "Output") { AnyView(VoiceOutputTab()) },
            SettingsCategoryTabItem(id: "training", title: "Training") { AnyView(VoiceTrainingTab()) },
            SettingsCategoryTabItem(id: "wakeHold", title: "Wake Hold") { AnyView(VoiceWakeHoldTab()) }
            ]
        )
    }
}
