import SwiftUI

// MARK: - Configuration Settings Panel

struct ConfigurationSettingsPanel: View {
    @ObservedObject private var runtimeSettings = RuntimeSettingsState.shared
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(runtimeSettings: Any? = nil) {}

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            sectionCard(title: "ICOS Brain", icon: .configuration) {
                settingsRow(name: "Brain Layer", state: "Governed awareness and orchestration", icon: .app)
                settingsRow(name: "Mounted Cognition", state: runtimeSettings.activeRoutingSummary, icon: .model)
            }

            sectionCard(title: "Mounted Providers", icon: .configuration) {
                ICOSToggleRow("Enable bundled local GGUF provider", isOn: $runtimeSettings.localProviderEnabled)
                    .onChange(of: runtimeSettings.localProviderEnabled) { _, _ in runtimeSettings.save() }

                ICOSToggleRow("Enable LM Studio / OpenAI-compatible provider", isOn: $runtimeSettings.externalProviderEnabled)
                    .onChange(of: runtimeSettings.externalProviderEnabled) { _, _ in runtimeSettings.save() }

                ICOSPickerRow(
                    "Runtime",
                    selection: $runtimeSettings.mode,
                    options: RuntimeMode.allCases.map { mode in
                        ICOSPickerOption(value: mode, title: mode.title)
                    }
                )
                .onChange(of: runtimeSettings.mode) { _, _ in runtimeSettings.save() }

                Text(runtimeSettings.activeRoutingSummary)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
            }

            sectionCard(title: "Local GGUF Provider", icon: .folder) {
                ICOSPickerRow(
                    "Mounted local model",
                    selection: $runtimeSettings.selectedLocalModelID,
                    options: runtimeSettings.localModels.isEmpty
                    ? [ICOSPickerOption(value: "", title: "No local provider model found")]
                    : runtimeSettings.localModels.map { model in
                        ICOSPickerOption(value: model.id, title: model.name)
                    }
                )
                .disabled(!runtimeSettings.localProviderEnabled || runtimeSettings.localModels.isEmpty)
                .onChange(of: runtimeSettings.selectedLocalModelID) { _, id in
                    if !id.isEmpty {
                        runtimeSettings.selectLocalModel(id: id)
                    }
                }

                actionRow(status: runtimeSettings.localModelStatus) {
                    ICOSButton("Scan Local Models", icon: .search) {
                        runtimeSettings.refreshLocalModels()
                    }
                }
            }

            sectionCard(title: "OpenAI-Compatible Provider", icon: .cloud) {
                ICOSTextInput("Provider name", placeholder: "Provider name", text: .constant("OpenAI-compatible"))

                ICOSTextInput("Base URL", placeholder: "Base URL", text: $runtimeSettings.cloudEndpoint)
                    .onSubmit { runtimeSettings.save() }

                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    ICOSButton("LM Studio", icon: .cloud) {
                        runtimeSettings.enableLMStudioPreset()
                        Task { await runtimeSettings.refreshExternalModels() }
                    }

                    ICOSButton(
                        runtimeSettings.isDiscoveringModels ? "Scanning" : "Scan Models",
                        icon: .search
                    ) {
                        runtimeSettings.save()
                        Task { await runtimeSettings.refreshExternalModels() }
                    }
                    .disabled(runtimeSettings.isDiscoveringModels)
                }

                if runtimeSettings.discoveredModels.isEmpty {
                    ICOSTextInput("Model ID", placeholder: "Model ID", text: $runtimeSettings.selectedModelID)
                        .disabled(!runtimeSettings.externalProviderEnabled)
                        .onSubmit { runtimeSettings.save() }
                } else {
                    ICOSPickerRow(
                        "Model",
                        selection: $runtimeSettings.selectedModelID,
                        options: runtimeSettings.discoveredModels.map { model in
                            ICOSPickerOption(value: model.id, title: model.id)
                        }
                    )
                    .onChange(of: runtimeSettings.selectedModelID) { _, id in
                        runtimeSettings.selectExternalModel(id: id)
                    }
                }

                SecureField("API key / token", text: $runtimeSettings.cloudAPIKey)
                    .textFieldStyle(.plain)
                    .font(.system(size: scaledFont(ICOSConfigurationSettingsTokens.secureFieldFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textPrimary)
                    .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                    .frame(height: scaled(ICOSControlTokens.fieldHeight))
                    .onSubmit { runtimeSettings.save() }

                actionRow(status: runtimeSettings.modelDiscoveryStatus) {
                    ICOSButton("Save Runtime", icon: .success, role: .primary) {
                        runtimeSettings.save()
                    }
                }
            }

            sectionCard(title: "Mounted Runtime", icon: .branch) {
                settingsRow(name: "Local GGUF", state: runtimeSettings.localModelStatus, icon: .loading)
                settingsRow(name: "External Provider", state: runtimeSettings.modelDiscoveryStatus, icon: .cloud)
                settingsRow(name: "Active Provider", state: runtimeSettings.activeProviderTitle, icon: .configuration)
                settingsRow(name: "Active Model", state: runtimeSettings.activeModelTitle, icon: .profileModel)
            }
        }
    }

    // MARK: - Components

    private func sectionCard<Content: View>(
        title: String,
        icon: ICOSIcon,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            HStack(spacing: scaled(ICOSSpacing.sm)) {
                SVGImageView(icon: icon)
                    .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))

                Text(title)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .semibold))
                    .foregroundStyle(ICOSColors.textPrimary)
            }

            content()
        }
        .padding(scaled(ICOSControlTokens.cardPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.sidebarGlass
            }
        }
    }


    private func actionRow<Action: View>(status: String, @ViewBuilder action: () -> Action) -> some View {
        HStack(spacing: scaled(ICOSSpacing.sm)) {
            action()

            Text(status)
                .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textSecondary)
                .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
        }
    }

    private func settingsRow(name: String, state: String, icon: ICOSIcon) -> some View {
        HStack(spacing: scaled(ICOSSpacing.sm)) {
            SVGImageView(icon: icon)
                .frame(width: scaled(ICOSSidebarTokens.iconSM), height: scaled(ICOSSidebarTokens.iconSM))
                .foregroundStyle(ICOSColors.textSecondary)

            Text(name)
                .foregroundStyle(ICOSColors.textPrimary)

            Spacer()

            Text(state)
                .foregroundStyle(ICOSColors.textSecondary)
                .lineLimit(ICOSControlTokens.rowValueLineLimit)
                .truncationMode(.middle)
        }
        .font(.system(size: scaledFont(ICOSControlTokens.settingsRowFontSize), weight: .regular))
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

private enum ICOSConfigurationSettingsTokens {
    static let secureFieldFontSize: CGFloat = ICOSControlTokens.textInputFontSize
}
