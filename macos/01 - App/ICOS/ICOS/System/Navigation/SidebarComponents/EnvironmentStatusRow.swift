import SwiftUI

struct EnvironmentStatusRow: View {

    let title: String
    let icon: ICOSIcon
    let value: String

    var body: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSSidebarTokens.iconXS,
                    height: ICOSSidebarTokens.iconXS
                )
                .foregroundStyle(ICOSSidebarColors.textSecondary)

            Text(title)
                .font(ICOSTypography.caption.weight(.medium))
                .foregroundStyle(ICOSSidebarColors.textPrimary)

            Spacer()

            Text(value)
                .font(ICOSTypography.micro.weight(.medium))
                .foregroundStyle(ICOSSidebarColors.textSecondary)
        }
        .padding(.horizontal, ICOSSidebarTokens.rowHorizontalPadding)
        .padding(.vertical, ICOSSpacing.sm)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(
                    cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                    style: .continuous
                )
                .fill(ICOSSidebarColors.rowPassiveFill)
            }
        }
    }
}

#Preview {
    VStack(spacing: ICOSSpacing.sm) {
        EnvironmentStatusRow(
            title: "Workspace",
            icon: .workspace,
            value: "Ready"
        )

        EnvironmentStatusRow(
            title: "Patch Engine",
            icon: .rename,
            value: "Ready"
        )

        EnvironmentStatusRow(
            title: "Terminal",
            icon: .console,
            value: "Ready"
        )
    }
    .padding(ICOSSpacing.md)
    .frame(width: ICOSSidebarTokens.environmentPreviewWidth)
}
