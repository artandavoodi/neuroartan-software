import SwiftUI
import AppKit

// MARK: - Message Bubble View

struct MessageBubbleView: View {
    let message: ChatMessage

    @EnvironmentObject private var services: SystemServices
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @State private var feedbackState: MessageFeedbackState = .none
    @State private var actionStatus = ""

    @AppStorage("ICOS.Developer.Transcript.FontSize") private var transcriptFontSize = 15.5
    @AppStorage("ICOS.Developer.Transcript.LineSpacing") private var transcriptLineSpacing = 6.0
    @AppStorage("ICOS.Developer.Transcript.HorizontalPadding") private var transcriptHorizontalPadding = 3.0
    @AppStorage("ICOS.Developer.Transcript.VerticalPadding") private var transcriptVerticalPadding = 8.0

    var body: some View {
        VStack(
            alignment: message.role == .user ? .trailing : .leading,
            spacing: scaled(ICOSMessageTokens.messageVerticalSpacing)
        ) {
            HStack {
                if message.role == .system || message.role == .assistant {
                    bubble
                    Spacer()
                } else {
                    Spacer()
                    bubble
                }
            }

            actionRow
        }
        .id(message.id)
    }


    // MARK: - Bubble

    private var bubble: some View {
        Text(message.content)
            .font(.system(size: scaledFont(CGFloat(transcriptFontSize)), weight: .regular))
            .lineSpacing(scaled(CGFloat(transcriptLineSpacing)))
            .padding(.horizontal, scaled(CGFloat(transcriptHorizontalPadding)))
            .padding(.vertical, scaled(CGFloat(transcriptVerticalPadding)))
            .foregroundStyle(ICOSSidebarColors.textPrimary)
            .frame(maxWidth: scaled(ICOSMessageTokens.bubbleMaxWidth), alignment: alignment)
            .textSelection(.enabled)
    }

    private var actionRow: some View {
        HStack(spacing: scaled(ICOSMessageTokens.actionRowSpacing)) {
            messageAction("Copy", icon: .copy) {
                copyToPasteboard(message.content)
                actionStatus = "Copied"
            }

            if message.role == .assistant || message.role == .system {
                messageAction("Read aloud", icon: .audio) {
                    speak(message.content)
                }

                messageAction("Good response", icon: .success) {
                    feedbackState = feedbackState == .liked ? .none : .liked
                    actionStatus = feedbackState == .liked ? "Liked" : ""
                }

                messageAction("Needs work", icon: .review) {
                    feedbackState = feedbackState == .disliked ? .none : .disliked
                    actionStatus = feedbackState == .disliked ? "Marked" : ""
                }
            }

            messageAction("Fork", icon: .fork) {
                copyToPasteboard("Fork from message \(message.id.uuidString):\n\n\(message.content)")
                actionStatus = "Fork copied"
            }

            if !actionStatus.isEmpty {
                Text(actionStatus)
                    .font(ICOSTypography.micro)
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
                    .padding(.leading, scaled(ICOSMessageTokens.actionStatusLeadingPadding))
            }
        }
        .frame(
            maxWidth: scaled(ICOSMessageTokens.bubbleMaxWidth),
            alignment: message.role == .user ? .trailing : .leading
        )
    }

    private func messageAction(
        _ title: String,
        icon: ICOSIcon,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(
                    width: scaled(ICOSMessageTokens.actionIconSize),
                    height: scaled(ICOSMessageTokens.actionIconSize)
                )
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .frame(
                    width: scaled(ICOSMessageTokens.actionButtonSize),
                    height: scaled(ICOSMessageTokens.actionButtonSize)
                )
                .contentShape(Rectangle())
                .background(
                    ICOSMaterials.hoverSurface.opacity(ICOSMessageTokens.actionInactiveFillOpacity),
                    in: RoundedRectangle(
                        cornerRadius: scaled(ICOSMessageTokens.actionButtonCornerRadius),
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .help(title)
    }

    private func copyToPasteboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    private func speak(_ text: String) {
        services.voicePlaybackService.toggleSpeech(
            text,
            voiceIdentifier: services.voiceCognitionService.profile.selectedSystemVoiceIdentifier
        )
        actionStatus = services.voicePlaybackService.isSpeaking ? "Reading" : "Stopped"
    }

    // MARK: - Styling

    private var alignment: Alignment {
        switch message.role {
        case .user:
            return .trailing
        case .system, .assistant:
            return .leading
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * density.spacingScale
    }

    private func scaledFont(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }
}

private enum MessageFeedbackState {
    case none
    case liked
    case disliked
}
