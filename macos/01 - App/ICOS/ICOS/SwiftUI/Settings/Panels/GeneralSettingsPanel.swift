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
            header

            Picker("General sections", selection: $selectedTab) {
                ForEach(GeneralSettingsTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            tabBody
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
            Text("General")
                .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            Text("Core defaults, launch behavior, and saved runtime state.")
                .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
        }
    }

    // MARK: - Tab Body

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

    // MARK: - Defaults Tab

    private var defaultsTab: some View {
        SettingsSectionCard(title: "Runtime Defaults", icon: .configuration) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                Picker("App mode", selection: $runtimeSettings.mode) {
                    ForEach(executionModes) { mode in
                        Text(mode.title).tag(mode)
                    }
                }

                TextField("Selected model ID", text: $runtimeSettings.selectedModelID)
                    .textFieldStyle(.roundedBorder)

                TextField("Cloud endpoint", text: $runtimeSettings.cloudEndpoint)
                    .textFieldStyle(.roundedBorder)

                SecureField("API key", text: $runtimeSettings.cloudAPIKey)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Spacer(minLength: 0)
                    Button("Save defaults") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    // MARK: - Startup Tab

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
                    name: "Selected model",
                    state: runtimeSettings.selectedModelID.isEmpty ? "Not set" : runtimeSettings.selectedModelID,
                    icon: .knowledge
                )

                WorktreeRow(
                    name: "Cloud endpoint",
                    state: runtimeSettings.cloudEndpoint.isEmpty ? "Not set" : runtimeSettings.cloudEndpoint,
                    icon: .cloud
                )
            }
        }
    }

    // MARK: - Behavior Tab

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

    // MARK: - Shortcuts Tab

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

    // MARK: - Reset Tab

    private var resetTab: some View {
        SettingsSectionCard(title: "Persistence", icon: .update) {
            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
                Text("General state is saved through the runtime owner.")
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)

                HStack {
                    Spacer(minLength: 0)
                    Button("Save current general state") {
                        runtimeSettings.save()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    // MARK: - Scaling

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
