import SwiftUI

struct ConnectorsSettingsPanel: View {
    @Environment(\.icosTypographyScale) private var typographyScale
    @ObservedObject var service: ConnectorRegistryService

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            SettingsSectionCard(title: "Connector Runtime", icon: .integration) {
                Text("Connectors control which external and local capabilities agents may access.")
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textSecondary)

                Text(service.statusText)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textTertiary)
            }

            ForEach(ConnectorKind.allCases) { kind in
                ConnectorCard(
                    configuration: service.connector(kind),
                    hasCredential: service.hasCredential(for: kind),
                    onUpdate: service.update,
                    onCredentialSave: { service.setCredential($0, for: kind) },
                    onTest: { service.testConnection(kind) }
                )
            }
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

private struct ConnectorCard: View {
    @State var configuration: ConnectorConfiguration
    @State private var credential = ""
    @Environment(\.icosTypographyScale) private var typographyScale
    let hasCredential: Bool
    let onUpdate: (ConnectorConfiguration) -> Void
    let onCredentialSave: (String) -> Void
    let onTest: () -> Void

    var body: some View {
        SettingsSectionCard(title: configuration.kind.title, icon: icon) {
            ICOSToggleRow("Enabled", isOn: binding(\.isEnabled))

            ICOSPickerRow(
                "Permission",
                selection: binding(\.permissionState),
                options: [
                    ICOSPickerOption(value: ConnectorPermissionState.disabled, title: ConnectorPermissionState.disabled.rawValue),
                    ICOSPickerOption(value: ConnectorPermissionState.userOnly, title: ConnectorPermissionState.userOnly.rawValue),
                    ICOSPickerOption(value: ConnectorPermissionState.agentAllowed, title: ConnectorPermissionState.agentAllowed.rawValue)
                ]
            )

            ICOSTextInput("Endpoint or root path", placeholder: "Endpoint or root path", text: binding(\.endpoint))

            ICOSTextInput("Account / username", placeholder: "Account / username", text: binding(\.usernameOrAccount))

            SecureField(hasCredential ? "Credential stored in Keychain" : "Credential / token", text: $credential)
                .textFieldStyle(.plain)
                .font(.system(size: scaled(ICOSConnectorsSettingsTokens.credentialFontSize), weight: .regular))
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(.horizontal, scaled(ICOSControlTokens.fieldHorizontalPadding))
                .frame(height: scaled(ICOSControlTokens.fieldHeight))

            HStack(spacing: scaled(ICOSSpacing.sm)) {
                ICOSButton("Save Credential", icon: .key) {
                    onCredentialSave(credential)
                    credential = ""
                }

                ICOSButton("Test Connection", role: .primary) {
                    onTest()
                }

                Spacer()

                statusBadge(configuration.authenticationState.rawValue)
            }

            if !configuration.lastError.isEmpty {
                Text(configuration.lastError)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.destructive)
            }

            if !configuration.logs.isEmpty {
                VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                    ForEach(configuration.logs.prefix(3), id: \.self) { entry in
                        Text(entry)
                            .font(ICOSTypography.monoCaption)
                            .foregroundStyle(ICOSColors.textTertiary)
                            .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
                    }
                }
            }
        }
        .onChange(of: configuration) { _, newValue in
            onUpdate(newValue)
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    private var icon: ICOSIcon {
        switch configuration.kind {
        case .email: return .email
        case .github: return .github
        case .googleDrive, .calendar, .contacts: return .cloud
        case .localFilesystem: return .fileManager
        case .vsCode: return .software
        case .terminal: return .console
        case .lmStudio: return .profileModel
        case .openRouter: return .route
        case .huggingFace: return .integration
        case .futureRegistry: return .registryIndex
        }
    }

    private func binding<Value: Equatable>(_ keyPath: WritableKeyPath<ConnectorConfiguration, Value>) -> Binding<Value> {
        Binding(
            get: { configuration[keyPath: keyPath] },
            set: { configuration[keyPath: keyPath] = $0 }
        )
    }

    private func statusBadge(_ text: String) -> some View {
        Text(text)
            .font(.system(size: scaled(ICOSConnectorsSettingsTokens.statusBadgeFontSize), weight: .regular))
            .foregroundStyle(ICOSColors.textSecondary)
            .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
            .padding(.vertical, scaled(ICOSConnectorsSettingsTokens.statusBadgeVerticalPadding))
            .background(ICOSColors.passiveFill)
    }
}

private enum ICOSConnectorsSettingsTokens {
    static let credentialFontSize: CGFloat = 13
    static let statusBadgeFontSize: CGFloat = 12
    static let statusBadgeVerticalPadding: CGFloat = ICOSSpacing.xs
}
