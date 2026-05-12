import SwiftUI

struct SidebarFooter: View {

    let statusText: String
    let isOnline: Bool

    var body: some View {
        VStack(spacing: ICOSSpacing.sm) {
            Rectangle()
                .fill(ICOSSidebarColors.separator)
                .frame(height: ICOSShellTokens.sidebarSeparatorWidth)
                .padding(.horizontal, ICOSSidebarTokens.footerSeparatorHorizontalPadding)

            HStack(spacing: ICOSSpacing.sm) {
                Circle()
                    .fill(isOnline ? ICOSColors.online : ICOSColors.warning)
                    .frame(
                        width: ICOSSidebarTokens.statusDotSize,
                        height: ICOSSidebarTokens.statusDotSize
                    )

                Text(statusText)
                    .font(ICOSTypography.caption.weight(.medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)

                Spacer()
            }
            .padding(.horizontal, ICOSSidebarTokens.footerHorizontalPadding)
            .padding(.bottom, ICOSSidebarTokens.footerBottomPadding)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        Spacer()

        SidebarFooter(
            statusText: "Runtime Online",
            isOnline: true
        )
    }
    .frame(
        width: ICOSSidebarTokens.footerPreviewWidth,
        height: ICOSSidebarTokens.footerPreviewHeight
    )
}
