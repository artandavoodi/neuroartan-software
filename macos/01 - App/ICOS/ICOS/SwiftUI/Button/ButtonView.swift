import SwiftUI

/// ICOS ButtonView
/// Production SwiftUI component mapped from UX Button specification
public struct ButtonView: View {
    // MARK: - Properties
    public let title: String
    public let action: () -> Void

    @EnvironmentObject var behaviorEngine: BehaviorEngine

    // MARK: - Init
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    // MARK: - Body
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: ICOSButtonViewTokens.titleFontSize, weight: .medium))
                .foregroundStyle(ICOSColors.textPrimary)
                .padding(.vertical, ICOSSpacing.sm)
                .padding(.horizontal, ICOSSpacing.md)
        }
        .onLongPressGesture {
            behaviorEngine.present(.settings)
        }
        .background(
            RoundedRectangle(cornerRadius: ICOSControlTokens.buttonCornerRadius, style: .continuous)
                .fill(ICOSMaterials.floatingSurface.opacity(ICOSButtonViewTokens.backgroundOpacity))
        )
        .buttonStyle(.plain)
    }
}

private enum ICOSButtonViewTokens {
    static let titleFontSize: CGFloat = 16
    static let backgroundOpacity: Double = 0.8
}
