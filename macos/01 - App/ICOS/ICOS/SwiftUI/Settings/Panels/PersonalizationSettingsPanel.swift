import SwiftUI

struct PersonalizationSettingsPanel: View {
    @EnvironmentObject private var services: SystemServices
    @State private var profile = ProfileManager.shared.current()
    @State private var saveStatus = ""

    var body: some View {
        SettingsSectionCard(title: "Account Identity", icon: .personalization) {
            ICOSTextInput("Email", placeholder: "Account email", text: $profile.accountEmail)
            ICOSTextInput("Phone", placeholder: "Phone number", text: $profile.phoneNumber)
            ICOSTextInput("Username", placeholder: "Username", text: $profile.username)
                .onChange(of: profile.username) { _, value in
                    profile.username = sanitizedUsername(value)
                    profile.usernameStatus = profile.username.isEmpty ? .unreserved : .reserved
                }

            Text(profile.username.isEmpty ? "Choose a username for account continuity." : "@\(profile.normalizedUsername)")
                .font(ICOSTypography.caption)
                .foregroundStyle(ICOSColors.textSecondary)

            ICOSPickerRow(
                "Provider",
                selection: $profile.accountProvider,
                options: AccountProvider.allCases.map { provider in
                    ICOSPickerOption(value: provider, title: provider.title)
                }
            )
        }

        SettingsSectionCard(title: "Private Profile", icon: .key) {
            ICOSTextInput("First name", placeholder: "First name", text: $profile.firstName)
            ICOSTextInput("Last name", placeholder: "Last name", text: $profile.lastName)
            ICOSTextInput("Display name", placeholder: "Display name", text: $profile.displayName)
        }

        SettingsSectionCard(title: "Public Profile", icon: .personalization) {
            ICOSTextInput("Public display name", placeholder: "Public display name", text: $profile.publicDisplayName)
            ICOSTextInput("Public bio", placeholder: "Public bio", text: $profile.publicBio)
            ICOSTextInput("Avatar image URL", placeholder: "Avatar image URL", text: $profile.avatarURL)
            ICOSTextInput("Header image URL", placeholder: "Header image URL", text: $profile.headerImageURL)
        }

        SettingsSectionCard(title: "Privacy Settings", icon: .key) {
            ICOSToggleRow("Enable public profile", isOn: $profile.publicProfileEnabled)
            ICOSToggleRow("Allow discovery", isOn: $profile.publicProfileDiscoverable)
            ICOSPickerRow(
                "Profile visibility",
                selection: $profile.profileVisibility,
                options: ProfileVisibility.allCases.map { visibility in
                    ICOSPickerOption(value: visibility, title: visibility.title)
                }
            )
            ICOSToggleRow("Allow public model display", isOn: $profile.allowsPublicModelDisplay)
        }

        SettingsSectionCard(title: "Behavioral Preferences", icon: .response) {
            ICOSPickerRow(
                "Tone",
                selection: $profile.tone,
                options: [
                    ICOSPickerOption(value: ToneProfile.neutral, title: "Neutral"),
                    ICOSPickerOption(value: ToneProfile.analytical, title: "Analytical"),
                    ICOSPickerOption(value: ToneProfile.expressive, title: "Expressive"),
                    ICOSPickerOption(value: ToneProfile.minimal, title: "Minimal")
                ]
            )
            ICOSPickerRow(
                "Response style",
                selection: $profile.responseStyle,
                options: [
                    ICOSPickerOption(value: ResponseStyle.concise, title: "Concise"),
                    ICOSPickerOption(value: ResponseStyle.balanced, title: "Balanced"),
                    ICOSPickerOption(value: ResponseStyle.detailed, title: "Detailed")
                ]
            )
        }

        VoiceSettingsPanel(voice: services.voiceCognitionService)

        SettingsSectionCard(title: "Memory Controls", icon: .chatManagement) {
            ICOSToggleRow("Memory enabled", isOn: $profile.memoryEnabled)
            ICOSPickerRow(
                "Memory scope",
                selection: $profile.memoryScope,
                options: [
                    ICOSPickerOption(value: MemoryScope.session, title: "Session"),
                    ICOSPickerOption(value: MemoryScope.persistent, title: "Persistent"),
                    ICOSPickerOption(value: MemoryScope.hybrid, title: "Hybrid")
                ]
            )
        }

        SettingsSectionCard(title: "Model Profile", icon: .configuration) {
            ICOSTextInput("Model name", placeholder: "Model name", text: $profile.modelName)
            ICOSTextInput("Model summary", placeholder: "Model summary", text: $profile.modelSummary)
            ICOSPickerRow(
                "Model privacy",
                selection: $profile.modelPrivacy,
                options: ModelPrivacy.allCases.map { privacy in
                    ICOSPickerOption(value: privacy, title: privacy.title)
                }
            )
            ICOSToggleRow("Authorize model training", isOn: $profile.allowsModelTraining)
            ICOSToggleRow("Allow self-modification", isOn: $profile.allowsSelfModification)
        }

        HStack(spacing: ICOSSpacing.md) {
            ICOSButton("Save profile", icon: .success, role: .primary) {
                profile.username = profile.normalizedUsername
                profile.updatedAt = Date()
                ProfileManager.shared.setProfile(profile)
                saveStatus = "Profile saved"
            }

            if !saveStatus.isEmpty {
                Text(saveStatus)
                    .font(ICOSTypography.caption)
                    .foregroundStyle(ICOSColors.textSecondary)
            }
        }
        .onAppear {
            profile = ProfileManager.shared.current()
        }
    }

    private func sanitizedUsername(_ value: String) -> String {
        let allowed = Set("abcdefghijklmnopqrstuvwxyz0123456789._")
        let normalized = value
            .lowercased()
            .filter { allowed.contains($0) }

        return String(normalized.prefix(32))
    }
}
