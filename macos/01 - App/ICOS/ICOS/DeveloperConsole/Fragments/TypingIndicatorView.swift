import SwiftUI

// MARK: - Typing Indicator View (RR-007)

struct TypingIndicatorView: View {
    
    @State private var animate: Bool = false
    @ObservedObject var appState: ICOSAppState
    
    private var isActive: Bool {
        false
    }
    
    var body: some View {
        Group {
            if isActive {
                HStack {
                    HStack(spacing: ICOSDeveloperCanvasTokens.thinkingDotSpacing) {
                        dot(delay: 0)
                        dot(delay: ICOSDeveloperCanvasTokens.thinkingAnimationDelayShort)
                        dot(delay: ICOSDeveloperCanvasTokens.thinkingAnimationDelayLong)
                    }
                    .padding(ICOSDeveloperCanvasTokens.typingIndicatorPadding)
                    .background(
                        ICOSMaterials.floatingSurface,
                        in: RoundedRectangle(
                            cornerRadius: ICOSDeveloperCanvasTokens.typingIndicatorCornerRadius,
                            style: .continuous
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: ICOSDeveloperCanvasTokens.typingIndicatorCornerRadius,
                            style: .continuous
                        )
                        .strokeBorder(
                            ICOSMaterials.softStroke,
                            lineWidth: ICOSMaterials.softStrokeWidth
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, ICOSDeveloperCanvasTokens.typingIndicatorHorizontalPadding)
                .onAppear {
                    animate = true
                }
            }
        }
    }
    
    // MARK: - Dot
    
    private func dot(delay: Double) -> some View {
        Circle()
            .fill(ICOSSidebarColors.textSecondary.opacity(ICOSDeveloperCanvasTokens.thinkingDotOpacity))
            .frame(
                width: ICOSDeveloperCanvasTokens.thinkingDotSize,
                height: ICOSDeveloperCanvasTokens.thinkingDotSize
            )
            .scaleEffect(animate ? ICOSDeveloperCanvasTokens.typingDotScaleVisible : ICOSDeveloperCanvasTokens.typingDotScaleResting)
            .opacity(animate ? ICOSDeveloperCanvasTokens.thinkingDotVisibleOpacity : ICOSDeveloperCanvasTokens.thinkingDotFaintOpacity)
            .animation(
                Animation.easeInOut(duration: ICOSDeveloperCanvasTokens.typingAnimationDuration)
                    .repeatForever()
                    .delay(delay),
                value: animate
            )
    }
}