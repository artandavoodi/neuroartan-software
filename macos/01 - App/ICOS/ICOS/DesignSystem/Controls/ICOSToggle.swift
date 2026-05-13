import AppKit
import SwiftUI

// MARK: - ICOS Toggle Style

struct ICOSToggleStyle: ToggleStyle {
    @State private var materialEpoch: UInt = 0

    func makeBody(configuration: Configuration) -> some View {
        ICOSToggleTrack(configuration: configuration)
            .id(materialEpoch)
            .onReceive(NotificationCenter.default.publisher(for: .icosMaterialAppearanceDidApply)) { _ in
                materialEpoch += 1
            }
    }
}

// MARK: - Toggle Track

private struct ICOSToggleTrack: View {
    let configuration: ToggleStyleConfiguration

    @Environment(\.isEnabled) private var isEnabled
    @State private var isAnimating = false

    private var trackColor: Color {
        if !isEnabled {
            return ICOSMaterials.toggleOffTrackColor.opacity(ICOSControlTokens.toggleDisabledOpacity)
        }
        return configuration.isOn ? Color.accentColor : ICOSMaterials.toggleOffTrackColor
    }

    private var thumbShadowOpacity: Double {
        configuration.isOn
            ? ICOSControlTokens.toggleThumbActiveShadowOpacity
            : ICOSControlTokens.toggleThumbShadowOpacity
    }

    private var thumbOffset: CGFloat {
        let travel = (ICOSControlTokens.toggleWidth / 2)
            - (ICOSControlTokens.toggleKnobSize / 2)
            - ICOSControlTokens.togglePadding
        return configuration.isOn ? travel : -travel
    }

    var body: some View {
        ZStack {
            Capsule()
                .fill(trackColor)
                .frame(
                    width: ICOSControlTokens.toggleWidth,
                    height: ICOSControlTokens.toggleHeight
                )

            Circle()
                .fill(Color.white)
                .frame(
                    width: ICOSControlTokens.toggleKnobSize,
                    height: ICOSControlTokens.toggleKnobSize
                )
                .shadow(
                    color: .black.opacity(thumbShadowOpacity),
                    radius: 1,
                    x: 0,
                    y: 0.5
                )
                .offset(x: thumbOffset)
        }
        .frame(
            width: ICOSControlTokens.toggleWidth,
            height: ICOSControlTokens.toggleHeight
        )
        .contentShape(Rectangle())
        .opacity(isEnabled ? 1 : ICOSControlTokens.toggleDisabledOpacity)
        .onTapGesture {
            guard isEnabled else { return }
            withAnimation(ICOSMotion.quick) {
                configuration.isOn.toggle()
            }
        }
        .animation(isAnimating ? ICOSMotion.quick : nil, value: configuration.isOn)
        .animation(isAnimating ? ICOSMotion.quick : nil, value: trackColor)
        .onAppear {
            DispatchQueue.main.async {
                isAnimating = true
            }
        }
    }
}

// MARK: - Toggle Style Extension

extension ToggleStyle where Self == ICOSToggleStyle {
    static var icos: ICOSToggleStyle { ICOSToggleStyle() }
}
