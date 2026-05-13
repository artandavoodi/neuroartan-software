import SwiftUI

// MARK: - Browser Use Tab

struct ConfigurationBrowserUseTab: View {
    @AppStorage("ICOS.Configuration.BrowserUse.Enabled") private var browserUseEnabled = true
    @AppStorage("ICOS.Configuration.BrowserUse.Headless") private var headless = false
    @AppStorage("ICOS.Configuration.BrowserUse.ProfilePath") private var profilePath = ""
    @AppStorage("ICOS.Configuration.BrowserUse.StartURL") private var startURL = ""
    @AppStorage("ICOS.Configuration.BrowserUse.TimeoutSeconds") private var timeoutSeconds = 30.0

    var body: some View {
        SettingsSectionCard(
            title: "Browser Use",
            subtitle: "Browser automation and web navigation defaults."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                ICOSToggleRow("Browser use enabled", isOn: $browserUseEnabled)
                ICOSToggleRow("Headless mode", isOn: $headless)

                ICOSTextInput("Start URL", placeholder: "https://", text: $startURL)
                ICOSTextInput("Browser profile path", placeholder: "/path/to/profile", text: $profilePath)

                ICOSSliderRow(
                    "Timeout seconds",
                    subtitle: "Maximum time allowed for a browser task.",
                    value: $timeoutSeconds,
                    in: 5...180
                )

                WorktreeRow(
                    name: "State",
                    state: browserUseEnabled ? "Operational" : "Disabled",
                    icon: browserUseEnabled ? .success : .loading
                )
            }
        }
    }
}
