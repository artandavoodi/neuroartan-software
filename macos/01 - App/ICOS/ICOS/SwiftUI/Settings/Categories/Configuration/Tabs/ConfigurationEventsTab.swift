import SwiftUI

// MARK: - Events Tab

struct ConfigurationEventsTab: View {
    @AppStorage("ICOS.Configuration.Events.Enabled") private var eventsEnabled = true
    @AppStorage("ICOS.Configuration.Events.AutoPublish") private var autoPublish = false
    @AppStorage("ICOS.Configuration.Events.AutoRefresh") private var autoRefresh = true
    @AppStorage("ICOS.Configuration.Events.PollSeconds") private var pollSeconds = 15.0

    var body: some View {
        SettingsSectionCard(
            title: "Events",
            subtitle: "Automation hooks and event loop behavior."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.md) {
                ICOSToggleRow("Events enabled", isOn: $eventsEnabled)
                ICOSToggleRow("Auto publish events", isOn: $autoPublish)
                ICOSToggleRow("Auto refresh event state", isOn: $autoRefresh)

                ICOSSliderRow(
                    "Poll seconds",
                    subtitle: "How often the event surface refreshes.",
                    value: $pollSeconds,
                    in: 5...120
                )

                WorktreeRow(
                    name: "State",
                    state: eventsEnabled ? "Operational" : "Disabled",
                    icon: eventsEnabled ? .success : .loading
                )
            }
        }
    }
}
