import SwiftUI

// MARK: - Dashboard Settings View

struct DashboardSettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Dashboard",
            subtitle: "Activity, analytics, readiness, health, and knowledge graph status.",
            tabs: [
                SettingsCategoryTabItem(id: "activity", title: "Activity") { AnyView(DashboardActivityTab()) },
            SettingsCategoryTabItem(id: "analytics", title: "Analytics") { AnyView(DashboardAnalyticsTab()) },
            SettingsCategoryTabItem(id: "health", title: "Health") { AnyView(DashboardHealthTab()) },
            SettingsCategoryTabItem(id: "knowledgeGraph", title: "Knowledge Graph") { AnyView(DashboardKnowledgeGraphTab()) },
            SettingsCategoryTabItem(id: "modelDashboard", title: "Model Dashboard") { AnyView(DashboardModelDashboardTab()) },
            SettingsCategoryTabItem(id: "readiness", title: "Readiness") { AnyView(DashboardReadinessTab()) }
            ]
        )
    }
}
