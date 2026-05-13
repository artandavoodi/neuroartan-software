import SwiftUI
#if os(macOS)
import AppKit
#endif

// MARK: - ICOS Picker Option

struct ICOSPickerOption<Selection: Hashable>: Identifiable {
    let value: Selection
    let title: String

    var id: Selection { value }
}

// MARK: - ICOS Picker Row

struct ICOSPickerRow<Selection: Hashable, Content: View>: View {
    let title: String
    let subtitle: String?
    let options: [ICOSPickerOption<Selection>]?
    @Binding var selection: Selection
    @ViewBuilder let content: () -> Content

    @State private var materialEpoch: UInt = 0
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    init(
        _ title: String,
        subtitle: String? = nil,
        selection: Binding<Selection>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = nil
        self._selection = selection
        self.content = content
    }

    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: scaled(ICOSSpacing.md)) {
                labelColumn

                Spacer(minLength: scaled(ICOSSpacing.md))

                pickerControl
            }
            .padding(.vertical, scaled(ICOSSpacing.md))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .id(materialEpoch)
        .onReceive(NotificationCenter.default.publisher(for: .icosMaterialAppearanceDidApply)) { _ in
            materialEpoch += 1
        }
    }

    // MARK: - Label Column

    private var labelColumn: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSControlTokens.rowLabelVerticalSpacing)) {
            Text(title)
                .font(.system(size: scaledFont(ICOSControlTokens.rowTitleFontSize), weight: .medium))
                .foregroundStyle(ICOSColors.textPrimary)

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: scaledFont(ICOSControlTokens.rowSubtitleFontSize), weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
                    .lineLimit(ICOSControlTokens.rowSubtitleLineLimit)
            }
        }
    }

    // MARK: - Picker Control

    @ViewBuilder
    private var pickerControl: some View {
        if let options {
            ICOSAppKitPicker(
                selection: $selection,
                options: options,
                controlSize: scaled(ICOSControlTokens.pickerHeight),
                textChevronSpacing: scaled(ICOSSpacing.md),
                materialEpoch: materialEpoch
            )
            .fixedSize(horizontal: true, vertical: false)
            .frame(minHeight: scaled(ICOSControlTokens.pickerHeight), alignment: .trailing)
        } else {
            Picker(title, selection: $selection) {
                content()
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .controlSize(.small)
            .frame(minHeight: scaled(ICOSControlTokens.pickerHeight), alignment: .trailing)
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

// MARK: - Option Initializer

extension ICOSPickerRow where Content == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        selection: Binding<Selection>,
        options: [ICOSPickerOption<Selection>]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self._selection = selection
        self.content = { EmptyView() }
    }
}

// MARK: - AppKit Picker

#if os(macOS)
private struct ICOSAppKitPicker<Selection: Hashable>: NSViewRepresentable {
    @Binding var selection: Selection
    let options: [ICOSPickerOption<Selection>]
    let controlSize: CGFloat
    let textChevronSpacing: CGFloat
    let materialEpoch: UInt

    func makeNSView(context: Context) -> NSStackView {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.distribution = .fill
        stack.spacing = textChevronSpacing

        let label = NSTextField(labelWithString: "")
        label.alignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        let control = NSPopUpButton(frame: .zero, pullsDown: false)
        control.bezelStyle = .circular
        control.controlSize = .small
        control.isBordered = true
        control.alignment = .center
        control.title = ""
        if let cell = control.cell as? NSPopUpButtonCell {
            cell.arrowPosition = .arrowAtCenter
        }
        control.target = context.coordinator
        control.action = #selector(Coordinator.selectionChanged(_:))
        control.setContentHuggingPriority(.required, for: .horizontal)
        control.setContentCompressionResistancePriority(.required, for: .horizontal)

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(control)

        context.coordinator.label = label
        context.coordinator.control = control
        context.coordinator.widthConstraint = control.widthAnchor.constraint(equalToConstant: controlSize)
        context.coordinator.heightConstraint = control.heightAnchor.constraint(equalToConstant: controlSize)
        context.coordinator.widthConstraint?.isActive = true
        context.coordinator.heightConstraint?.isActive = true

        return stack
    }

    func updateNSView(_ stack: NSStackView, context: Context) {
        context.coordinator.parent = self
        stack.spacing = textChevronSpacing

        guard let label = context.coordinator.label,
              let control = context.coordinator.control else { return }

        // Apply material-aware colors on every update including epoch changes
        let resolvedTextColor = NSColor(ICOSColors.textPrimary)
        label.textColor = resolvedTextColor
        if let cell = control.cell as? NSPopUpButtonCell {
            cell.arrowPosition = .arrowAtCenter
        }

        let titles = options.map(\.title)
        if control.itemTitles != titles {
            control.removeAllItems()
            control.addItems(withTitles: titles)
        }

        if let selectedIndex = options.firstIndex(where: { $0.value == selection }) {
            if control.indexOfSelectedItem != selectedIndex {
                control.selectItem(at: selectedIndex)
            }
            label.stringValue = options[selectedIndex].title
        }

        control.title = ""
        context.coordinator.widthConstraint?.constant = controlSize
        context.coordinator.heightConstraint?.constant = controlSize
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject {
        var parent: ICOSAppKitPicker
        weak var label: NSTextField?
        weak var control: NSPopUpButton?
        var widthConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?

        init(parent: ICOSAppKitPicker) {
            self.parent = parent
        }

        @objc func selectionChanged(_ sender: NSPopUpButton) {
            let index = sender.indexOfSelectedItem
            guard parent.options.indices.contains(index) else { return }
            parent.selection = parent.options[index].value
            label?.stringValue = parent.options[index].title
            sender.title = ""
        }
    }
}
#endif