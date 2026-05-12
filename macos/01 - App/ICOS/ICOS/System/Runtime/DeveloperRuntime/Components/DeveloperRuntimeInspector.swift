import SwiftUI

// MARK: - Developer Runtime Inspector

struct DeveloperRuntimeInspector: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.lg)) {
            Text("Inspector")
                .font(.system(size: scaledFont(14), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            DeveloperRuntimeInspectorCard(title: "Runtime State") {
                DeveloperRuntimeInspectorMetric(key: "Mode", value: "Developer")
                DeveloperRuntimeInspectorMetric(key: "Shell", value: "Active")
                DeveloperRuntimeInspectorMetric(key: "Panel", value: "Visible")
            }

            DeveloperRuntimeInspectorCard(title: "Workspace") {
                DeveloperRuntimeInspectorMetric(key: "Editor", value: "Ready")
                DeveloperRuntimeInspectorMetric(key: "Terminal", value: "Available")
                DeveloperRuntimeInspectorMetric(key: "Review", value: "Pending")
            }

            Spacer()
        }
        .padding(.horizontal, scaled(ICOSShellTokens.shellSectionSpacing))
        .padding(.vertical, scaled(ICOSShellTokens.shellSectionSpacing))
        .frame(width: scaled(ICOSShellTokens.inspectorWidth))
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                ICOSMaterials.inspectorBackground
            }
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}