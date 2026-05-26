import SwiftUI

// MARK: - Model Dashboard Tab

struct DashboardModelDashboardTab: View {
    @StateObject private var personalModelFoundationRegistry = PersonalModelFoundationRegistry.shared

    var body: some View {
        SettingsSectionCard(
            title: "Model Dashboard",
            subtitle: "Private model foundation status."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Model Dashboard")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                if let foundation = personalModelFoundationRegistry.foundation {
                    modelFoundationRows(foundation)
                } else {
                    Text("No private model foundation has been initialized yet.")
                        .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                }
            }
        }
    }

    @ViewBuilder
    private func modelFoundationRows(_ foundation: PersonalModelFoundation) -> some View {
        VStack(alignment: .leading, spacing: ICOSSpacing.xs) {
            dashboardRow(label: "Model ID", value: foundation.personalModel.modelID)
            dashboardRow(label: "Birth", value: foundation.dashboard.birthStatusDisplay.rawValue)
            dashboardRow(label: "Registry", value: foundation.dashboard.registryStatusDisplay.rawValue)
            dashboardRow(label: "Visibility", value: foundation.personalModel.visibilityState.rawValue)
            dashboardRow(label: "Provider", value: foundation.dashboard.providerRouteDisplay.rawValue)
            dashboardRow(label: "Entitlement", value: foundation.dashboard.entitlementDisplay.rawValue)
            dashboardRow(label: "Permissions", value: foundation.dashboard.permissionDisplay.rawValue)
            dashboardRow(label: "Readiness", value: foundation.dashboard.readinessDisplay.rawValue)
            dashboardRow(label: "Economy", value: foundation.dashboard.blockedEconomyDisplay.rawValue)
        }
    }

    private func dashboardRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: ICOSSpacing.sm) {
            Text(label)
                .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Text(value)
                .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                .foregroundStyle(ICOSSidebarColors.textSecondary)
        }
    }
}
