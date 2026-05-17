import SwiftUI

// MARK: - General Settings Panel

struct GeneralSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @ObservedObject var runtimeSettings: RuntimeSettingsState
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    @State private var selectedTab: GeneralSettingsTab = .defaults

    private let executionModes = RuntimeMode.allCases

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            Picker("", selection: $selectedTab) {
                ForEach(GeneralSettingsTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: .infinity, alignment: .center)

            tabBody
        }
    }

    @ViewBuilder
    private var tabBody: some View {
        switch selectedTab {
        case .defaults:
            defaultsTab
        case .startup:
            startupTab
        case .behavior:
            behaviorTab
        case .shortcuts:
            shortcutsTab
        case .reset:
            resetTab
        }
    }

    private var defaultsTab: some View {
        SettingsSectionCard(title: "Runtime Summary", icon: .configuration) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                WorktreeRow(name: "Mode", state: runtimeSettings.mode.title, icon: .configuration)
                WorktreeRow(name: "Routing", state: runtimeSettings.activeRoutingSummary, icon: .cloud)
                WorktreeRow(
                    name: "Selected model",
                    state: runtimeSettings.selectedModelID.isEmpty ? "Not set" : runtimeSettings.selectedModelID,
                    icon: .knowledge
                )
                WorktreeRow(
                    name: "Endpoint",
                    state: runtimeSettings.cloudEndpoint.isEmpty ? "Not set" : runtimeSettings.cloudEndpoint,
                    icon: .cloud
                )

                HStack {
                    Spacer(minLength: 0)
                    Button("Reload saved runtime state") {
                        runtimeSettings.load()
                    }
                    .buttonStyle(.bordered)

                    Button("Save runtime snapshot") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    private var startupTab: some View {
        SettingsSectionCard(title: "Startup State", icon: .workspace) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                WorktreeRow(
                    name: "App mode",
                    state: runtimeSettings.mode.title,
                    icon: .configuration
                )

                WorktreeRow(
                    name: "Work execution",
                    state: shellState.workExecutionMode,
                    icon: .worktree
                )

                WorktreeRow(
                    name: "Active provider",
                    state: runtimeSettings.activeProviderTitle,
                    icon: .cloud
                )

                WorktreeRow(
                    name: "Active model",
                    state: runtimeSettings.activeModelTitle,
                    icon: .knowledge
                )
            }
        }
    }

    private var behaviorTab: some View {
        SettingsSectionCard(title: "Execution Behavior", icon: .response) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                Picker("Work execution mode", selection: $shellState.workExecutionMode) {
                    ForEach(executionModes, id: \.rawValue) { executionMode in
                        Text(executionMode.title).tag(executionMode.rawValue)
                    }
                }

                Text("This tab owns the live execution posture of the shell.")
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
    }

    private var shortcutsTab: some View {
        SettingsSectionCard(title: "Quick Routes", icon: .settings) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                WorktreeRow(name: "Appearance", state: "Theme and surfaces", icon: .appearance)
                WorktreeRow(name: "Voice", state: "Audio identity", icon: .voice)
                WorktreeRow(name: "Configuration", state: "Runtime wiring", icon: .configuration)
                WorktreeRow(name: "Connectors", state: "Providers and models", icon: .cloud)
                WorktreeRow(name: "Security", state: "Access and trust", icon: .key)
            }
        }
    }

    private var resetTab: some View {
        SettingsSectionCard(title: "Persistence", icon: .update) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                Text("This restores the runtime owner without theatrical placeholders.")
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)

                HStack {
                    Spacer(minLength: 0)
                    Button("Load saved runtime") {
                        runtimeSettings.load()
                    }
                    .buttonStyle(.bordered)

                    Button("Save current general state") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

// MARK: - General Settings Tabs

private enum GeneralSettingsTab: String, CaseIterable, Identifiable {
    case defaults = "Defaults"
    case startup = "Startup"
    case behavior = "Behavior"
    case shortcuts = "Shortcuts"
    case reset = "Reset"

    var id: String { rawValue }
    var title: String { rawValue }
}
