import AppKit
import SwiftUI

// MARK: - ICOS Primary Shell Split View

struct ICOSPrimaryShellSplitView<Sidebar: View, Content: View>: NSViewRepresentable {
    @Binding var isSidebarVisible: Bool

    let sidebarWidth: CGFloat
    let sectionSpacing: CGFloat
    let sidebar: () -> Sidebar
    let content: () -> Content

    init(
        isSidebarVisible: Binding<Bool>,
        sidebarWidth: CGFloat,
        sectionSpacing: CGFloat,
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isSidebarVisible = isSidebarVisible
        self.sidebarWidth = sidebarWidth
        self.sectionSpacing = sectionSpacing
        self.sidebar = sidebar
        self.content = content
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> ICOSPrimaryShellSplitContainerView {
        let container = ICOSPrimaryShellSplitContainerView(
            sidebarWidth: sidebarWidth,
            sectionSpacing: sectionSpacing
        )

        container.configure(
            sidebar: sidebar(),
            content: content(),
            isSidebarVisible: isSidebarVisible
        )

        context.coordinator.container = container
        return container
    }

    func updateNSView(_ container: ICOSPrimaryShellSplitContainerView, context: Context) {
        container.sidebarWidth = sidebarWidth
        container.sectionSpacing = sectionSpacing
        container.update(
            sidebar: sidebar(),
            content: content(),
            isSidebarVisible: isSidebarVisible
        )

        context.coordinator.container = container
    }

    final class Coordinator {
        weak var container: ICOSPrimaryShellSplitContainerView?
    }
}

// MARK: - ICOS Primary Shell Split Container

final class ICOSPrimaryShellSplitContainerView: NSView {
    var sidebarWidth: CGFloat {
        didSet {
            splitView.sidebarWidth = sidebarWidth
            applyLayout(animated: false)
        }
    }

    var sectionSpacing: CGFloat {
        didSet {
            splitView.shellDividerThickness = isSidebarVisible ? sectionSpacing : 0
            splitView.adjustSubviews()
        }
    }

    private let splitView: ICOSPrimaryShellNSSplitView
    private let sidebarHostingView: NSHostingView<AnyView>
    private let contentHostingView: NSHostingView<AnyView>
    private var isSidebarVisible = true

    init(sidebarWidth: CGFloat, sectionSpacing: CGFloat) {
        self.sidebarWidth = sidebarWidth
        self.sectionSpacing = sectionSpacing
        self.splitView = ICOSPrimaryShellNSSplitView(
            sidebarWidth: sidebarWidth,
            shellDividerThickness: sectionSpacing
        )
        self.sidebarHostingView = NSHostingView(rootView: AnyView(EmptyView()))
        self.contentHostingView = NSHostingView(rootView: AnyView(EmptyView()))

        super.init(frame: .zero)

        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor

        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.wantsLayer = true
        splitView.layer?.backgroundColor = NSColor.clear.cgColor

        sidebarHostingView.translatesAutoresizingMaskIntoConstraints = false
        contentHostingView.translatesAutoresizingMaskIntoConstraints = false

        splitView.addArrangedSubview(sidebarHostingView)
        splitView.addArrangedSubview(contentHostingView)

        addSubview(splitView)

        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: topAnchor),
            splitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            splitView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure<Sidebar: View, Content: View>(
        sidebar: Sidebar,
        content: Content,
        isSidebarVisible: Bool
    ) {
        sidebarHostingView.rootView = AnyView(sidebar)
        contentHostingView.rootView = AnyView(content)
        self.isSidebarVisible = isSidebarVisible
        applyLayout(animated: false)
    }

    func update<Sidebar: View, Content: View>(
        sidebar: Sidebar,
        content: Content,
        isSidebarVisible: Bool
    ) {
        sidebarHostingView.rootView = AnyView(sidebar)
        contentHostingView.rootView = AnyView(content)

        guard self.isSidebarVisible != isSidebarVisible else {
            applyLayout(animated: false)
            return
        }

        self.isSidebarVisible = isSidebarVisible
        applyLayout(animated: true)
    }

    override func layout() {
        super.layout()
        applyLayout(animated: false)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        guard window != nil else {
            return
        }

        NotificationCenter.default.post(
            name: .icosPrimaryShellSplitViewDidAttach,
            object: splitView
        )
    }

    private func applyLayout(animated: Bool) {
        guard splitView.subviews.count >= 2 else {
            return
        }

        let targetSidebarWidth = isSidebarVisible ? sidebarWidth : 0
        splitView.sidebarWidth = sidebarWidth
        splitView.shellDividerThickness = isSidebarVisible ? sectionSpacing : 0
        splitView.setSidebarVisibility(isSidebarVisible)

        let layoutChanges = {
            self.splitView.setPosition(targetSidebarWidth, ofDividerAt: 0)
            self.splitView.layoutSubtreeIfNeeded()
        }

        if animated, window != nil {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.15
                context.allowsImplicitAnimation = true
                layoutChanges()
            }
        } else {
            layoutChanges()
        }
    }
}

// MARK: - ICOS Primary Shell NSSplitView

final class ICOSPrimaryShellNSSplitView: NSSplitView {
    var sidebarWidth: CGFloat
    var shellDividerThickness: CGFloat

    init(sidebarWidth: CGFloat, shellDividerThickness: CGFloat) {
        self.sidebarWidth = sidebarWidth
        self.shellDividerThickness = shellDividerThickness
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var dividerThickness: CGFloat {
        shellDividerThickness
    }

    override func drawDivider(in rect: NSRect) {
        NSColor.clear.setFill()
        rect.fill()
    }

    func setSidebarVisibility(_ isVisible: Bool) {
        guard let sidebarView = subviews.first else {
            return
        }

        sidebarView.isHidden = !isVisible
    }
}