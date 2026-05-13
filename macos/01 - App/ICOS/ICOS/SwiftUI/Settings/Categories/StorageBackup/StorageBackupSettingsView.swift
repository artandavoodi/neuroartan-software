import SwiftUI

// MARK: - Storage Backup Settings View

struct StorageBackupSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Storage Backup",
            subtitle: "Backup, restore, sync, export, archive, and local data control.",
            tabs: [
                SettingsCategoryTabItem(id: "archive", title: "Archive") { AnyView(StorageBackupArchiveTab()) },
            SettingsCategoryTabItem(id: "backup", title: "Backup") { AnyView(StorageBackupBackupTab()) },
            SettingsCategoryTabItem(id: "export", title: "Export") { AnyView(StorageBackupExportTab()) },
            SettingsCategoryTabItem(id: "localData", title: "Local Data") { AnyView(StorageBackupLocalDataTab()) },
            SettingsCategoryTabItem(id: "restore", title: "Restore") { AnyView(StorageBackupRestoreTab()) },
            SettingsCategoryTabItem(id: "sync", title: "Sync") { AnyView(StorageBackupSyncTab()) }
            ]
        )
    }
}
