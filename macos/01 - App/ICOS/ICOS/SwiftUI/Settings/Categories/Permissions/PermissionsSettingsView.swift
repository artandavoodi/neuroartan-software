import SwiftUI

// MARK: - Permissions Settings View

struct PermissionsSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Permissions",
            subtitle: "Device, browser, file, contact, camera, microphone, and notification access.",
            tabs: [
                SettingsCategoryTabItem(id: "accessibilityAccess", title: "Accessibility Access") { AnyView(PermissionsAccessibilityAccessTab()) },
            SettingsCategoryTabItem(id: "browser", title: "Browser") { AnyView(PermissionsBrowserTab()) },
            SettingsCategoryTabItem(id: "camera", title: "Camera") { AnyView(PermissionsCameraTab()) },
            SettingsCategoryTabItem(id: "contacts", title: "Contacts") { AnyView(PermissionsContactsTab()) },
            SettingsCategoryTabItem(id: "files", title: "Files") { AnyView(PermissionsFilesTab()) },
            SettingsCategoryTabItem(id: "microphone", title: "Microphone") { AnyView(PermissionsMicrophoneTab()) },
            SettingsCategoryTabItem(id: "notifications", title: "Notifications") { AnyView(PermissionsNotificationsTab()) }
            ]
        )
    }
}
