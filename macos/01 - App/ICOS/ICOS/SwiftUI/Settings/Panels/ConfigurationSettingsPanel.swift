import SwiftUI

// MARK: - Configuration Settings Panel

struct ConfigurationSettingsPanel: View {
    @ObservedObject var shellState: ShellState
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            header
            RuntimeSettingsView(runtimeSettings: runtimeSettings)
            liveSummary
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
            Text("Configuration")
                .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            Text("Runtime wiring, execution routing, provider discovery, and model management.")
                .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
        }
    }

    // MARK: - Live Summary

    private var liveSummary: some View {
        SettingsSectionCard(title: "Live Summary", icon: .workspace) {
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

                WorktreeRow(
                    name: "Endpoint",
                    state: runtimeSettings.activeEndpointTitle,
                    icon: .cloud
                )

                HStack {
                    Spacer(minLength: 0)
                    Button("Save runtime state") {
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
