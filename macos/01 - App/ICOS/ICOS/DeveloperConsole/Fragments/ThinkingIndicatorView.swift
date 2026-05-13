import SwiftUI

// MARK: - Thinking Indicator (ChatGPT-style UX)
// Minimal breathing animation for system "thinking" state

struct ThinkingIndicatorView: View {

    @State private var animate = false

    var body: some View {
        HStack(spacing: ICOSDeveloperCanvasTokens.thinkingDotSpacing) {

            Circle()
                .fill(ICOSSidebarColors.textSecondary.opacity(ICOSDeveloperCanvasTokens.thinkingDotOpacity))
                .frame(
                    width: ICOSDeveloperCanvasTokens.thinkingDotSize,
                    height: ICOSDeveloperCanvasTokens.thinkingDotSize
                )
                .scaleEffect(animate ? ICOSDeveloperCanvasTokens.thinkingDotScaleLarge : ICOSDeveloperCanvasTokens.thinkingDotScaleSmall)
                .opacity(animate ? ICOSDeveloperCanvasTokens.thinkingDotVisibleOpacity : ICOSDeveloperCanvasTokens.thinkingDotDimOpacity)
                .animation(
                    .easeInOut(duration: ICOSDeveloperCanvasTokens.thinkingAnimationDuration)
                    .repeatForever(autoreverses: true),
                    value: animate
                )

            Circle()
                .fill(ICOSSidebarColors.textSecondary.opacity(ICOSDeveloperCanvasTokens.thinkingDotOpacity))
                .frame(
                    width: ICOSDeveloperCanvasTokens.thinkingDotSize,
                    height: ICOSDeveloperCanvasTokens.thinkingDotSize
                )
                .scaleEffect(animate ? ICOSDeveloperCanvasTokens.thinkingDotScaleMedium : ICOSDeveloperCanvasTokens.thinkingDotScaleLarge)
                .opacity(animate ? ICOSDeveloperCanvasTokens.thinkingDotDimOpacity : ICOSDeveloperCanvasTokens.thinkingDotVisibleOpacity)
                .animation(
                    .easeInOut(duration: ICOSDeveloperCanvasTokens.thinkingAnimationDuration)
                    .repeatForever(autoreverses: true)
                    .delay(ICOSDeveloperCanvasTokens.thinkingAnimationDelayShort),
                    value: animate
                )

            Circle()
                .fill(ICOSSidebarColors.textSecondary.opacity(ICOSDeveloperCanvasTokens.thinkingDotOpacity))
                .frame(
                    width: ICOSDeveloperCanvasTokens.thinkingDotSize,
                    height: ICOSDeveloperCanvasTokens.thinkingDotSize
                )
                .scaleEffect(animate ? ICOSDeveloperCanvasTokens.thinkingDotScaleActive : ICOSDeveloperCanvasTokens.thinkingDotScaleTiny)
                .opacity(animate ? ICOSDeveloperCanvasTokens.thinkingDotVisibleOpacity : ICOSDeveloperCanvasTokens.thinkingDotFaintOpacity)
                .animation(
                    .easeInOut(duration: ICOSDeveloperCanvasTokens.thinkingAnimationDuration)
                    .repeatForever(autoreverses: true)
                    .delay(ICOSDeveloperCanvasTokens.thinkingAnimationDelayLong),
                    value: animate
                )
        }
        .onAppear {
            animate = true
        }
        .onDisappear {
            animate = false
        }
    }
}