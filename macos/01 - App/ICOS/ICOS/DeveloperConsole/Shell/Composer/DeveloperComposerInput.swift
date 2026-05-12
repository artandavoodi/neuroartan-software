import SwiftUI
import AppKit

// MARK: - Developer Composer Input

struct DeveloperComposerInput: View {

    // MARK: - Properties

    @Binding var inputText: String

    let onSend: () -> Void
    let onStop: () -> Void
    let onVoice: () -> Void
    let onAction: (DeveloperExtensionAction) -> Void
    let isRunning: Bool
    let isVoiceRecording: Bool
    let modelSelector: AnyView

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    @AppStorage("ICOS.Developer.Transcript.InputFontSize") private var inputFontSize = 15.0
    @AppStorage("ICOS.Developer.Transcript.InputLineSpacing") private var inputLineSpacing = 5.0

    // MARK: - Body

    var body: some View {
        VStack(spacing: scaled(ICOSDeveloperComposerTokens.inputSpacing)) {
            messageInput

            HStack(alignment: .center, spacing: scaled(ICOSDeveloperComposerTokens.inputSpacing)) {
                attachButton

                modelSelector

                Spacer(minLength: 0)

                voiceButton

                sendButton
            }
        }
        .padding(.horizontal, scaled(ICOSDeveloperComposerTokens.inputHorizontalPadding))
        .padding(.vertical, scaled(ICOSDeveloperComposerTokens.inputVerticalPadding))
        .background(
            ICOSMaterials.solidPanelBackground,
            in: RoundedRectangle(
                cornerRadius: scaled(ICOSDeveloperComposerTokens.inputCornerRadius),
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: scaled(ICOSDeveloperComposerTokens.inputCornerRadius),
                style: .continuous
            )
            .strokeBorder(
                ICOSMaterials.softStroke,
                lineWidth: ICOSMaterials.softStrokeWidth
            )
        }
    }

    // MARK: - Attach Button

    private var attachButton: some View {
        Menu {
            ForEach(DeveloperExtensionAction.allCases) { action in
                MenuButton(action.rawValue) {
                    onAction(action)
                }
            }
        } label: {
            SVGImageView(icon: .add)
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionIconSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionIconSize)
                )
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionButtonSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionButtonSize)
                )
                .background(
                    ICOSMaterials.hoverSurface.opacity(ICOSDeveloperComposerTokens.actionInactiveFillOpacity),
                    in: RoundedRectangle(
                        cornerRadius: scaled(ICOSDeveloperComposerTokens.actionButtonCornerRadius),
                        style: .continuous
                    )
                )
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .menuIndicator(.hidden)
        .help("Attach or add context")
    }

    // MARK: - Message Input

    private var messageInput: some View {
        ZStack(alignment: .topLeading) {
            if inputText.isEmpty {
                Text("Ask ICOS")
                    .font(.system(size: scaledFont(CGFloat(inputFontSize)), weight: .regular))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .padding(.top, scaled(ICOSDeveloperComposerTokens.placeholderTopPadding))
            }

            DeveloperMultilineComposerTextView(
                text: $inputText,
                onSend: onSend,
                fontSize: scaledFont(CGFloat(inputFontSize)),
                lineSpacing: CGFloat(inputLineSpacing)
            )
            .frame(
                minHeight: scaled(ICOSDeveloperComposerTokens.inputMinHeight),
                maxHeight: scaled(ICOSDeveloperComposerTokens.inputMaxHeight)
            )
        }
    }

    // MARK: - Voice Button

    private var voiceButton: some View {
        Button(action: onVoice) {
            SVGImageView(icon: .voice)
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionIconSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionIconSize)
                )
                .foregroundStyle(isVoiceRecording ? ICOSSidebarColors.textPrimary : ICOSSidebarColors.textSecondary)
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionButtonSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionButtonSize)
                )
                .background(
                    isVoiceRecording ? ICOSSidebarColors.rowActiveFill : ICOSMaterials.hoverSurface.opacity(ICOSDeveloperComposerTokens.actionInactiveFillOpacity),
                    in: RoundedRectangle(
                        cornerRadius: scaled(ICOSDeveloperComposerTokens.actionButtonCornerRadius),
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .help(isVoiceRecording ? "Stop voice transcription and send" : "Start voice transcription")
    }

    // MARK: - Send Button

    private var sendButton: some View {
        Button(action: isRunning ? onStop : onSend) {
            SVGImageView(icon: isRunning ? .stop : .send)
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionIconSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionIconSize)
                )
                .foregroundStyle(sendEnabled || isRunning ? ICOSMaterials.windowBackground : ICOSSidebarColors.textSecondary)
                .frame(
                    width: scaled(ICOSDeveloperComposerTokens.actionButtonSize),
                    height: scaled(ICOSDeveloperComposerTokens.actionButtonSize)
                )
                .background(
                    sendEnabled || isRunning
                    ? ICOSSidebarColors.textPrimary
                    : ICOSMaterials.hoverSurface.opacity(ICOSDeveloperComposerTokens.actionInactiveFillOpacity),
                    in: RoundedRectangle(
                        cornerRadius: scaled(ICOSDeveloperComposerTokens.actionButtonCornerRadius),
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(!sendEnabled && !isRunning)
    }

    // MARK: - State

    private var sendEnabled: Bool {
        !inputText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
    private func MenuButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
    }
}

// MARK: - Developer Multiline Composer Text View

private struct DeveloperMultilineComposerTextView: NSViewRepresentable {

    @Binding var text: String

    let onSend: () -> Void
    let fontSize: CGFloat
    let lineSpacing: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onSend: onSend)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.autohidesScrollers = true

        let textView = KeyHandlingTextView()
        textView.delegate = context.coordinator
        textView.onReturn = onSend
        textView.isRichText = false
        textView.importsGraphics = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.drawsBackground = false
        textView.backgroundColor = .clear
        textView.textColor = NSColor.labelColor
        textView.font = .systemFont(ofSize: fontSize, weight: .regular)
        textView.defaultParagraphStyle = paragraphStyle
        textView.typingAttributes[.paragraphStyle] = paragraphStyle
        textView.textContainerInset = .zero
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width, height: .greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.string = text

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? KeyHandlingTextView else { return }
        textView.onReturn = onSend
        textView.font = .systemFont(ofSize: fontSize, weight: .regular)
        textView.defaultParagraphStyle = paragraphStyle
        textView.typingAttributes[.paragraphStyle] = paragraphStyle
        if textView.string != text {
            textView.string = text
        }
    }

    private var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        return style
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding private var text: String
        private let onSend: () -> Void

        init(text: Binding<String>, onSend: @escaping () -> Void) {
            _text = text
            self.onSend = onSend
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }

    final class KeyHandlingTextView: NSTextView {
        var onReturn: (() -> Void)?

        override func keyDown(with event: NSEvent) {
            let isReturn = event.keyCode == 36 || event.keyCode == 76
            let isShift = event.modifierFlags.contains(.shift)

            if isReturn && !isShift {
                onReturn?()
                return
            }

            super.keyDown(with: event)
        }
    }
}
