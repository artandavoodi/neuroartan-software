import SwiftUI

// MARK: - Telemetry Tab

struct PrivacyTelemetryTab: View {
    var body: some View {
        SettingsSectionCard(
            title: "Telemetry",
            subtitle: "Telemetry and data collection scope."
        ) {
            VStack(alignment: .leading, spacing: ICOSSpacing.sm) {
                Text("Telemetry")
                    .font(ICOSSidebarTokens.itemTitleFont)
                    .foregroundStyle(ICOSSidebarColors.textPrimary)
                    .font(.system(size: ICOSControlTokens.profileMetaFontSize, weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }
        }
    }
}
