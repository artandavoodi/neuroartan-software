import AppKit
import SwiftUI

// MARK: - ICOS Boot Animation View

struct ICOSBootAnimationView: View {
    var onFinished: () -> Void

    @EnvironmentObject private var themeState: ThemeState
    @State private var didFinish = false
    @State private var startedAt = Date()
    @State private var isVisible = false
    @State private var revealedCharacters = 0
    @State private var launchSound: NSSound?

    private let tagline = "Your intelligence, continuous"
    private let taglineDelay: TimeInterval = ICOSBootAnimationTokens.taglineDelay
    private let transitionDelay: TimeInterval = ICOSBootAnimationTokens.transitionDelay
    private let collapseStart: TimeInterval = ICOSBootAnimationTokens.collapseStart
    private let fadeStart: TimeInterval = ICOSBootAnimationTokens.fadeStart
    private let fallbackCompletionDelay: TimeInterval = ICOSBootAnimationTokens.fallbackCompletionDelay

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startedAt)

            ZStack {
                ICOSMaterials.windowBackground
                    .ignoresSafeArea()

                Canvas { context, size in
                    drawBootFigure(
                        in: context,
                        size: size,
                        elapsed: elapsed
                    )
                }
                .opacity(animationOpacity(elapsed))

                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    taglineView
                        .padding(.bottom, ICOSBootAnimationTokens.taglineBottomPadding)
                }
                .opacity(isVisible ? 1 : 0)
            }
            .animation(ICOSMotion.quick, value: isVisible)
        }
        .onAppear {
            startedAt = Date()
            isVisible = true
            revealTagline()
            playLaunchSoundAndScheduleCompletion()
        }
        .onTapGesture {
            finishOnce()
        }
        .onChange(of: themeState.runtimeSignature) { _, _ in
            isVisible = true
        }
    }


    private var taglineView: some View {
        HStack(spacing: 0) {
            ForEach(Array(tagline.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .font(.system(size: ICOSBootAnimationTokens.taglineFontSize, weight: .light, design: .default))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .opacity(index < revealedCharacters ? ICOSBootAnimationTokens.visibleOpacity : ICOSBootAnimationTokens.hiddenOpacity)
                    .offset(y: index < revealedCharacters ? ICOSBootAnimationTokens.revealedOffsetY : ICOSBootAnimationTokens.hiddenOffsetY)
                    .animation(
                        .easeOut(duration: ICOSBootAnimationTokens.taglineRevealDuration),
                        value: revealedCharacters
                    )
            }
        }
        .accessibilityLabel(tagline)
    }

    // MARK: - Native Boot Figure

    private func drawBootFigure(in context: GraphicsContext, size: CGSize, elapsed: TimeInterval) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let figureSize = min(size.width, size.height) * ICOSBootAnimationTokens.figureSizeRatio
        let energy = audioEnergy(at: elapsed)
        let drive = audioDrive(at: elapsed)
        let progress = motionProgress(elapsed, drive: drive)
        let collapse = collapseProgress(elapsed)
        let circleHold = smoothstep(progress)
        let infinityHold = 1 - circleHold
        let wobble = sin(elapsed * (ICOSBootAnimationTokens.wobbleBaseFrequency + (energy * ICOSBootAnimationTokens.wobbleEnergyFrequency))) * (ICOSBootAnimationTokens.wobbleBaseAmplitude + (energy * ICOSBootAnimationTokens.wobbleEnergyAmplitude)) * circleHold
        let lineWidth = max(ICOSBootAnimationTokens.minimumLineWidth, figureSize * (ICOSBootAnimationTokens.lineWidthBaseRatio + (energy * ICOSBootAnimationTokens.lineWidthEnergyRatio)))
        let color = ICOSSidebarColors.textPrimary.opacity(ICOSBootAnimationTokens.figureOpacity)
        let verticalScale = lerp(ICOSBootAnimationTokens.verticalScaleMin, ICOSBootAnimationTokens.verticalScaleMax, circleHold)
        let circleEnergyScale = ICOSBootAnimationTokens.baseScale + (circleHold * energy * ICOSBootAnimationTokens.circleEnergyScaleRatio)

        var path = Path()
        let samples = ICOSBootAnimationTokens.pathSampleCount

        for index in 0...samples {
            let t = Double(index) / Double(samples)
            let angle = t * .pi * 2
            let infinityX = sin(angle)
            let infinityY = sin(angle) * cos(angle)
            let ringX = cos(angle)
            let ringY = sin(angle)
            let twist = sin((angle * ICOSBootAnimationTokens.twistAngleMultiplier) + (elapsed * (ICOSBootAnimationTokens.twistBaseSpeed + (drive * ICOSBootAnimationTokens.twistDriveSpeed)))) * (ICOSBootAnimationTokens.twistBaseAmplitude + (energy * ICOSBootAnimationTokens.twistEnergyAmplitude)) * infinityHold

            let xBlend = lerp(infinityX, ringX, progress)
            let yBlend = lerp(infinityY, ringY, progress)
            let scale = figureSize * lerp(ICOSBootAnimationTokens.infinityScaleRatio + (energy * ICOSBootAnimationTokens.infinityEnergyScaleRatio), ICOSBootAnimationTokens.circleScaleRatio * circleEnergyScale, circleHold)
            let x = center.x + CGFloat(xBlend + twist) * scale
            let y = center.y + CGFloat(yBlend + wobble) * scale * CGFloat(verticalScale)

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()

        context.stroke(
            path,
            with: .color(color),
            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
        )
    }

    private func motionProgress(_ elapsed: TimeInterval, drive: Double) -> Double {
        guard elapsed > transitionDelay else {
            return 0
        }

        let baseProgress = min(ICOSBootAnimationTokens.maximumProgress, (elapsed - transitionDelay) / ICOSBootAnimationTokens.transitionDuration)
        let drivenProgress = min(ICOSBootAnimationTokens.maximumProgress, baseProgress + (drive * ICOSBootAnimationTokens.driveProgressBoost))

        return smoothstep(drivenProgress)
    }

    private func audioDrive(at elapsed: TimeInterval) -> Double {
        let energy = audioEnergy(at: elapsed)
        let previous = audioEnergy(at: max(ICOSBootAnimationTokens.zeroTime, elapsed - ICOSBootAnimationTokens.transientLookback))
        let transient = max(0, energy - previous)

        return min(ICOSBootAnimationTokens.maximumProgress, (energy * ICOSBootAnimationTokens.energyDriveWeight) + (transient * ICOSBootAnimationTokens.transientDriveWeight))
    }

    private func audioEnergy(at elapsed: TimeInterval) -> Double {
        let keyframes: [(TimeInterval, Double)] = [
            (0.0, 0.02),
            (1.4, 0.08),
            (4.0, 0.16),
            (5.5, 0.22),
            (7.0, 0.30),
            (8.5, 0.42),
            (9.3, 0.44),
            (9.6, 0.71),
            (10.0, 0.66),
            (10.1, 0.90),
            (10.3, 1.00),
            (10.6, 0.95),
            (11.0, 0.75),
            (11.4, 0.97),
            (11.8, 0.96),
            (12.2, 0.93),
            (12.5, 0.80),
            (12.6, 0.54),
            (12.7, 0.18),
            (12.8, 0.31),
            (13.0, 0.11),
            (13.4, 0.04),
            (14.1, 0.02)
        ]

        guard let first = keyframes.first else { return ICOSBootAnimationTokens.zeroEnergy }
        guard elapsed > first.0 else { return first.1 }

        for index in 1..<keyframes.count {
            let previous = keyframes[index - 1]
            let current = keyframes[index]

            if elapsed <= current.0 {
                let span = max(ICOSBootAnimationTokens.minimumKeyframeSpan, current.0 - previous.0)
                let progress = (elapsed - previous.0) / span
                return lerp(previous.1, current.1, smoothstep(progress))
            }
        }

        return keyframes.last?.1 ?? ICOSBootAnimationTokens.zeroEnergy
    }

    private func collapseProgress(_ elapsed: TimeInterval) -> Double {
        guard elapsed > collapseStart else {
            return 0
        }

        return smoothstep(min(ICOSBootAnimationTokens.maximumProgress, (elapsed - collapseStart) / ICOSBootAnimationTokens.collapseDuration))
    }

    private func animationOpacity(_ elapsed: TimeInterval) -> Double {
        1
    }

    private func lerp(_ from: Double, _ to: Double, _ progress: Double) -> Double {
        from + ((to - from) * progress)
    }

    private func smoothstep(_ progress: Double) -> Double {
        let clamped = min(max(progress, ICOSBootAnimationTokens.minimumProgress), ICOSBootAnimationTokens.maximumProgress)
        return clamped * clamped * (3 - (2 * clamped))
    }

    // MARK: - Sequencing

    private func revealTagline() {
        revealedCharacters = 0

        for index in 0...tagline.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + taglineDelay + (Double(index) * ICOSBootAnimationTokens.taglineCharacterDelay)) {
                revealedCharacters = index
            }
        }
    }

    private func playLaunchSoundAndScheduleCompletion() {
        let duration = playLaunchSound()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            finishOnce()
        }
    }

    @discardableResult
    private func playLaunchSound() -> TimeInterval {
        guard let soundURL = launchSoundURL(),
              let sound = NSSound(contentsOf: soundURL, byReference: false)
        else {
            return fallbackCompletionDelay
        }

        sound.volume = ICOSBootAnimationTokens.launchSoundVolume
        sound.play()
        launchSound = sound

        return sound.duration > 0 ? sound.duration : fallbackCompletionDelay
    }

    private func launchSoundURL() -> URL? {
        ICOSSoundTokens.launchSoundURL
    }


    private func finishOnce() {
        guard !didFinish else { return }
        didFinish = true
        launchSound?.stop()
        onFinished()
    }
}

private enum ICOSBootAnimationTokens {
    static let taglineDelay: TimeInterval = 1.4
    static let transitionDelay: TimeInterval = 5.5
    static let collapseStart: TimeInterval = 12.6
    static let fadeStart: TimeInterval = 12.8
    static let fallbackCompletionDelay: TimeInterval = 14.2
    static let taglineBottomPadding: CGFloat = 64
    static let taglineFontSize: CGFloat = 22
    static let taglineRevealDuration: TimeInterval = 0.45
    static let taglineCharacterDelay: TimeInterval = 0.035
    static let visibleOpacity: Double = 1
    static let hiddenOpacity: Double = 0
    static let revealedOffsetY: CGFloat = 0
    static let hiddenOffsetY: CGFloat = 10
    static let figureSizeRatio: CGFloat = 0.28
    static let wobbleBaseFrequency: Double = 4.8
    static let wobbleEnergyFrequency: Double = 7.2
    static let wobbleBaseAmplitude: Double = 0.01
    static let wobbleEnergyAmplitude: Double = 0.018
    static let minimumLineWidth: CGFloat = 1.4
    static let lineWidthBaseRatio: CGFloat = 0.009
    static let lineWidthEnergyRatio: CGFloat = 0.006
    static let figureOpacity: Double = 0.88
    static let verticalScaleMin: Double = 0.62
    static let verticalScaleMax: Double = 1.0
    static let baseScale: Double = 1
    static let circleEnergyScaleRatio: Double = 0.075
    static let pathSampleCount: Int = 260
    static let twistAngleMultiplier: Double = 3.0
    static let twistBaseSpeed: Double = 2.2
    static let twistDriveSpeed: Double = 3.8
    static let twistBaseAmplitude: Double = 0.035
    static let twistEnergyAmplitude: Double = 0.045
    static let infinityScaleRatio: Double = 0.42
    static let infinityEnergyScaleRatio: Double = 0.025
    static let circleScaleRatio: Double = 0.31
    static let transitionDuration: TimeInterval = 1.35
    static let driveProgressBoost: Double = 0.10
    static let transientLookback: TimeInterval = 0.18
    static let energyDriveWeight: Double = 0.74
    static let transientDriveWeight: Double = 1.8
    static let collapseDuration: TimeInterval = 0.6
    static let minimumKeyframeSpan: TimeInterval = 0.001
    static let minimumProgress: Double = 0
    static let maximumProgress: Double = 1
    static let zeroTime: TimeInterval = 0
    static let zeroEnergy: Double = 0
    static let launchSoundVolume: Float = 0.82
}
