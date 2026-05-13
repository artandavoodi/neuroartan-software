import SwiftUI

// MARK: - Configuration Settings View

struct ConfigurationSettingsView: View {
    @ObservedObject var shellState: ShellState
    @State private var selectedTab: ConfigurationSettingsTab = .runtime

    var body: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.lg) {
            header

            Picker("", selection: $selectedTab) {
                ForEach(ConfigurationSettingsTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
               .frame(maxWidth: .infinity, alignment: .center)
 .frame(maxWidth: .infinity, alignment: .center)

            tabBody
        }
        .padding(.vertical, ICOSSpacing.sm)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
            Text("Configuration")
                .font(.system(size: ICOSControlTokens.rowTitleFontSize, weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            Text("")
                .font(.system(size: ICOSControlTokens.rowSubtitleFontSize, weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
        }
    }

    // MARK: - Tab Body

    @ViewBuilder
    private var tabBody: some View {
        switch selectedTab {
        case .browserUse:
            ConfigurationBrowserUseTab()
        case .chatManagement:
            ConfigurationChatManagementTab()
        case .environment:
            ConfigurationEnvironmentTab(shellState: shellState)
        case .events:
            ConfigurationEventsTab()
        case .runtime:
            ConfigurationRuntimeTab()
        case .worktree:
            ConfigurationWorktreeTab(shellState: shellState)
        }
    }
}

// MARK: - Configuration Settings Tabs

private enum ConfigurationSettingsTab: String, CaseIterable, Identifiable {
    case browserUse = "Browser Use"
    case chatManagement = "Chat Management"
    case environment = "Environment"
    case events = "Events"
    case runtime = "Runtime"
    case worktree = "Worktree"

    var id: String { rawValue }
    var title: String { rawValue }
}
