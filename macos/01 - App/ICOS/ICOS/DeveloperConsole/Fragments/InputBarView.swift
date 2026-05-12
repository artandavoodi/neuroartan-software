import SwiftUI

// MARK: - Input Bar View

struct InputBarView: View {

    @Binding var inputText: String

    var onSend: () -> Void
    var onAttach: () -> Void = {}
    var onMic: () -> Void = {}
    var isMicActive: Bool = false

    var body: some View {
        HStack(spacing: ICOSInputBarTokens.itemSpacing) {
            attachmentMenu

            inputField

            iconButton(
                icon: .voice,
                isActive: isMicActive,
                action: onMic
            )

            sendButton
        }
        .padding(.horizontal, ICOSSidebarTokens.inputBarHorizontalPadding)
        .padding(.vertical, ICOSSidebarTokens.inputBarVerticalPadding)
        .background(ICOSMaterials.floatingSurface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(ICOSMaterials.separator)
                .frame(height: ICOSMaterials.softStrokeWidth)
        }
    }

    // MARK: - Attachment Menu

    private var attachmentMenu: some View {
        Menu {
            Button("Attach file", action: onAttach)
            Button("Voice command", action: onMic)
        } label: {
            SVGImageView(icon: .add)
                .frame(
                    width: ICOSSidebarTokens.iconMD,
                    height: ICOSSidebarTokens.iconMD
                )
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .padding(ICOSInputBarTokens.iconButtonPadding)
                .background(
                    RoundedRectangle(
                        cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                        style: .continuous
                    )
                    .fill(ICOSSidebarColors.rowPassiveFill)
                )
        }
        .menuStyle(.borderlessButton)
    }

    // MARK: - Input Field

    private var inputField: some View {
        ICOSTextInput("Message", placeholder: "Message ICOS...", text: $inputText)
            .onSubmit {
                onSend()
            }
    }

    // MARK: - Send Button

    private var sendButton: some View {
        Button(action: onSend) {
            SVGImageView(icon: .arrowUp)
                .frame(
                    width: ICOSSidebarTokens.iconMD,
                    height: ICOSSidebarTokens.iconMD
                )
                .foregroundStyle(
                    inputText.isEmpty
                    ? ICOSSidebarColors.textSecondary
                    : ICOSSidebarColors.textPrimary
                )
                .padding(ICOSInputBarTokens.iconButtonPadding)
                .background(
                    RoundedRectangle(
                        cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                        style: .continuous
                    )
                    .fill(
                        inputText.isEmpty
                        ? ICOSSidebarColors.rowPassiveFill
                        : ICOSSidebarColors.rowActiveFill
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(inputText.isEmpty)
    }

    // MARK: - Icon Button

    private func iconButton(
        icon: ICOSIcon,
        isActive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            SVGImageView(icon: icon)
                .frame(
                    width: ICOSSidebarTokens.iconMD,
                    height: ICOSSidebarTokens.iconMD
                )
                .foregroundStyle(ICOSSidebarColors.textPrimary)
                .padding(ICOSInputBarTokens.iconButtonPadding)
                .background(
                    RoundedRectangle(
                        cornerRadius: ICOSSidebarTokens.rowCornerRadius,
                        style: .continuous
                    )
                    .fill(isActive ? ICOSSidebarColors.rowActiveFill : ICOSSidebarColors.rowPassiveFill)
                )
        }
        .buttonStyle(.plain)
    }
}
