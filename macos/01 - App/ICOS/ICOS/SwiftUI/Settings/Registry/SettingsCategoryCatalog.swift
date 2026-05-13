import Foundation

// MARK: - Settings Category Catalog

struct SettingsTabDescriptor: Identifiable {
    let id = UUID()
    let title: String
    let fileName: String
}

struct SettingsCategoryDescriptor: Identifiable {
    let id = UUID()
    let title: String
    let folderName: String
    let shellFileName: String
    let tabs: [SettingsTabDescriptor]
}

enum SettingsCategoryCatalog {
    static let categories: [SettingsCategoryDescriptor] = [
        .init(title: "General", folderName: "General", shellFileName: "GeneralSettingsView.swift", tabs: [
            .init(title: "Defaults", fileName: "GeneralDefaultsTab.swift"),
            .init(title: "Startup", fileName: "GeneralStartupTab.swift"),
            .init(title: "Behavior", fileName: "GeneralBehaviorTab.swift"),
            .init(title: "Shortcuts", fileName: "GeneralShortcutsTab.swift"),
            .init(title: "Reset", fileName: "GeneralResetTab.swift")
        ]),
        .init(title: "Appearance", folderName: "Appearance", shellFileName: "AppearanceSettingsView.swift", tabs: []),
        .init(title: "Voice", folderName: "Voice", shellFileName: "VoiceSettingsView.swift", tabs: [
            .init(title: "Input", fileName: "VoiceInputTab.swift"),
            .init(title: "Output", fileName: "VoiceOutputTab.swift"),
            .init(title: "Training", fileName: "VoiceTrainingTab.swift"),
            .init(title: "Language", fileName: "VoiceLanguageTab.swift"),
            .init(title: "Wake/Hold", fileName: "VoiceWakeHoldTab.swift")
        ]),
        .init(title: "Permissions", folderName: "Permissions", shellFileName: "PermissionsSettingsView.swift", tabs: [
            .init(title: "Microphone", fileName: "PermissionsMicrophoneTab.swift"),
            .init(title: "Files", fileName: "PermissionsFilesTab.swift"),
            .init(title: "Camera", fileName: "PermissionsCameraTab.swift"),
            .init(title: "Notifications", fileName: "PermissionsNotificationsTab.swift"),
            .init(title: "Contacts", fileName: "PermissionsContactsTab.swift"),
            .init(title: "Accessibility", fileName: "PermissionsAccessibilityAccessTab.swift"),
            .init(title: "Browser", fileName: "PermissionsBrowserTab.swift")
        ]),
        .init(title: "Privacy", folderName: "Privacy", shellFileName: "PrivacySettingsView.swift", tabs: [
            .init(title: "Retention", fileName: "PrivacyRetentionTab.swift"),
            .init(title: "Export/Delete", fileName: "PrivacyExportDeleteTab.swift"),
            .init(title: "Public/Private", fileName: "PrivacyPublicPrivateTab.swift"),
            .init(title: "Telemetry", fileName: "PrivacyTelemetryTab.swift"),
            .init(title: "Linked Sources", fileName: "PrivacyLinkedSourcesTab.swift")
        ]),
        .init(title: "Accessibility", folderName: "Accessibility", shellFileName: "AccessibilitySettingsView.swift", tabs: [
            .init(title: "Text", fileName: "AccessibilityTextTab.swift"),
            .init(title: "Contrast", fileName: "AccessibilityContrastTab.swift"),
            .init(title: "Motion", fileName: "AccessibilityMotionTab.swift"),
            .init(title: "Keyboard", fileName: "AccessibilityKeyboardTab.swift"),
            .init(title: "Screen Reader", fileName: "AccessibilityScreenReaderTab.swift"),
            .init(title: "Captions", fileName: "AccessibilityCaptionsTab.swift")
        ]),
        .init(title: "Configuration", folderName: "Configuration", shellFileName: "ConfigurationSettingsView.swift", tabs: [
            .init(title: "Runtime", fileName: "ConfigurationRuntimeTab.swift"),
            .init(title: "Environment", fileName: "ConfigurationEnvironmentTab.swift"),
            .init(title: "Worktree", fileName: "ConfigurationWorktreeTab.swift"),
            .init(title: "Events", fileName: "ConfigurationEventsTab.swift"),
            .init(title: "Browser Use", fileName: "ConfigurationBrowserUseTab.swift"),
            .init(title: "Chat Management", fileName: "ConfigurationChatManagementTab.swift")
        ]),
        .init(title: "Connectors", folderName: "Connectors", shellFileName: "ConnectorsSettingsView.swift", tabs: [
            .init(title: "Cloud Providers", fileName: "ConnectorsCloudProvidersTab.swift"),
            .init(title: "Local LLM", fileName: "ConnectorsLocalLLMTab.swift"),
            .init(title: "API Keys", fileName: "ConnectorsAPIKeysTab.swift"),
            .init(title: "Models", fileName: "ConnectorsModelsTab.swift"),
            .init(title: "Health", fileName: "ConnectorsHealthTab.swift")
        ]),
        .init(title: "Personalization", folderName: "Personalization", shellFileName: "PersonalizationSettingsView.swift", tabs: [
            .init(title: "Profile", fileName: "PersonalizationProfileTab.swift"),
            .init(title: "Identity", fileName: "PersonalizationIdentityTab.swift"),
            .init(title: "Memory", fileName: "PersonalizationMemoryTab.swift"),
            .init(title: "Tone", fileName: "PersonalizationToneTab.swift"),
            .init(title: "Style", fileName: "PersonalizationStyleTab.swift"),
            .init(title: "Social Graph", fileName: "PersonalizationSocialGraphTab.swift")
        ]),
        .init(title: "Dashboard", folderName: "Dashboard", shellFileName: "DashboardSettingsView.swift", tabs: [
            .init(title: "Model Dashboard", fileName: "DashboardModelDashboardTab.swift"),
            .init(title: "Analytics", fileName: "DashboardAnalyticsTab.swift"),
            .init(title: "Knowledge Graph", fileName: "DashboardKnowledgeGraphTab.swift"),
            .init(title: "Readiness", fileName: "DashboardReadinessTab.swift"),
            .init(title: "Activity", fileName: "DashboardActivityTab.swift"),
            .init(title: "Health", fileName: "DashboardHealthTab.swift")
        ]),
        .init(title: "Storage & Backup", folderName: "StorageBackup", shellFileName: "StorageBackupSettingsView.swift", tabs: [
            .init(title: "Local Data", fileName: "StorageBackupLocalDataTab.swift"),
            .init(title: "Sync", fileName: "StorageBackupSyncTab.swift"),
            .init(title: "Backup", fileName: "StorageBackupBackupTab.swift"),
            .init(title: "Restore", fileName: "StorageBackupRestoreTab.swift"),
            .init(title: "Archive", fileName: "StorageBackupArchiveTab.swift"),
            .init(title: "Export", fileName: "StorageBackupExportTab.swift")
        ]),
        .init(title: "Security", folderName: "Security", shellFileName: "SecuritySettingsView.swift", tabs: [
            .init(title: "Sign In", fileName: "SecuritySignInTab.swift"),
            .init(title: "Sessions", fileName: "SecuritySessionsTab.swift"),
            .init(title: "Trust", fileName: "SecurityTrustTab.swift"),
            .init(title: "Linked Accounts", fileName: "SecurityLinkedAccountsTab.swift"),
            .init(title: "Two-Factor", fileName: "SecurityTwoFactorTab.swift"),
            .init(title: "Anti-Impersonation", fileName: "SecurityAntiImpersonationTab.swift")
        ])
    ]
}
