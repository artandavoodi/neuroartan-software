import SwiftUI

enum ICOSMotion {
    static let fast: Double = 0.30
    static let medium: Double = 0.60
    static let slow: Double = 1.20

    static let hover = Animation.easeOut(duration: 0.15)
    static let quick = Animation.easeOut(duration: 0.15)
    static let hoverStateDuration: Double = 0.12
    static let sidebarStateDuration: Double = 0.16
    static let panelStateDuration: Double = 0.18
    static let surfaceTransition = Animation.easeInOut(duration: medium)
    static let ambientReveal = Animation.easeInOut(duration: slow)
}

enum ICOSAnimationTokens {
    static let hoverScale: CGFloat = 0.98
    static let pressedScale: CGFloat = 0.985
    static let panelFadeDuration: Double = ICOSMotion.medium
    static let sceneRevealDuration: Double = ICOSMotion.slow
}
