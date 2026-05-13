import SwiftUI

// MARK: - Connectors Settings View

struct ConnectorsSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Connectors",
            subtitle: "API keys, models, health, local LLM, and cloud providers.",
            tabs: [
                SettingsCategoryTabItem(id: "apiKeys", title: "API Keys") { AnyView(ConnectorsAPIKeysTab()) },
            SettingsCategoryTabItem(id: "cloudProviders", title: "Cloud Providers") { AnyView(ConnectorsCloudProvidersTab()) },
            SettingsCategoryTabItem(id: "health", title: "Health") { AnyView(ConnectorsHealthTab()) },
            SettingsCategoryTabItem(id: "localLLM", title: "Local LLM") { AnyView(ConnectorsLocalLLMTab()) },
            SettingsCategoryTabItem(id: "models", title: "Models") { AnyView(ConnectorsModelsTab()) }
            ]
        )
    }
}
