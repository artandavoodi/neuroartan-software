import SwiftUI

// MARK: - Worktree Row

struct WorktreeRow: View {
    let name: String
    let state: String
    let icon: ICOSIcon

    init(
        name: String,
        state: String,
        icon: ICOSIcon = .file
    ) {
        self.name = name
        self.state = state
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: ICOSSpacing.sm) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSControlTokens.worktreeIconSize,
                    height: ICOSControlTokens.worktreeIconSize
                )
                .foregroundStyle(ICOSColors.textSecondary)

            Text(name)
                .foregroundStyle(ICOSColors.textPrimary)

            Spacer()

            Text(state)
                .foregroundStyle(ICOSColors.textSecondary)
        }
        .font(.system(size: ICOSControlTokens.worktreeFontSize))
    }
}
