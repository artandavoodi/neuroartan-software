import SwiftUI

// MARK: - Accessibility Settings View

struct AccessibilitySettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Accessibility",
            subtitle: "Assistive behavior, contrast, motion, reading, keyboard, and captions.",
            tabs: [
                SettingsCategoryTabItem(id: "captions", title: "Captions") { AnyView(AccessibilityCaptionsTab()) },
            SettingsCategoryTabItem(id: "contrast", title: "Contrast") { AnyView(AccessibilityContrastTab()) },
            SettingsCategoryTabItem(id: "keyboard", title: "Keyboard") { AnyView(AccessibilityKeyboardTab()) },
            SettingsCategoryTabItem(id: "motion", title: "Motion") { AnyView(AccessibilityMotionTab()) },
            SettingsCategoryTabItem(id: "screenreader", title: "Screen Reader") { AnyView(AccessibilityScreenReaderTab()) },
            SettingsCategoryTabItem(id: "text", title: "Text") { AnyView(AccessibilityTextTab()) }
            ]
        )
    }
}
