import SwiftUI

// MARK: - Developer Runtime Sidebar

struct DeveloperRuntimeSidebar: View {
    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale
    @State private var selectedItem: DeveloperRuntimeSidebarItem = .workspace

    var body: some View {
        VStack(spacing: 0) {
            sidebarHeader

            sections

            Spacer()
        }
        .frame(width: scaled(ICOSSidebarTokens.runtimeSidebarWidth))
        .background(ICOSMaterials.sidebarGlass)
    }

    // MARK: - Sidebar Header

    private var sidebarHeader: some View {
        HStack(spacing: scaled(ICOSSpacing.md)) {
            SVGImageView(icon: .terminal)
                .frame(
                    width: scaled(ICOSSidebarTokens.iconLG),
                    height: scaled(ICOSSidebarTokens.iconLG)
                )

            VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                Text("Developer")
                    .font(.system(size: scaledFont(14), weight: .semibold))
                    .foregroundStyle(ICOSSidebarColors.textPrimary)

                Text("Runtime Environment")
                    .font(.system(size: scaledFont(11), weight: .medium))
                    .foregroundStyle(ICOSSidebarColors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, scaled(ICOSSidebarTokens.headerHorizontalPadding))
        .padding(.top, scaled(ICOSSidebarTokens.accountOuterPadding))
        .padding(.bottom, scaled(ICOSSidebarTokens.sectionGroupSpacing))
    }

    // MARK: - Sections

    private var sections: some View {
        ICOSScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.sectionSpacing)) {
                DeveloperRuntimeSidebarSection(
                    title: "Workspace",
                    items: DeveloperRuntimeSidebarItem.workspaceItems,
                    selectedItem: selectedItem,
                    onSelect: { selectedItem = $0 }
                )

                DeveloperRuntimeSidebarSection(
                    title: "Runtime",
                    items: DeveloperRuntimeSidebarItem.runtimeItems,
                    selectedItem: selectedItem,
                    onSelect: { selectedItem = $0 }
                )

                DeveloperRuntimeSidebarSection(
                    title: "Review",
                    items: DeveloperRuntimeSidebarItem.reviewItems,
                    selectedItem: selectedItem,
                    onSelect: { selectedItem = $0 }
                )
            }
            .padding(.horizontal, scaled(ICOSSidebarTokens.accountOuterPadding))
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

// MARK: - Developer Runtime Sidebar Item

enum DeveloperRuntimeSidebarItem: String, CaseIterable, Identifiable {
    case workspace
    case files
    case terminal
    case problems
    case sessions
    case agents
    case models
    case changes
    case history

    var id: String { rawValue }

    var title: String {
        switch self {
        case .workspace:
            "Workspace"
        case .files:
            "Files"
        case .terminal:
            "Terminal"
        case .problems:
            "Problems"
        case .sessions:
            "Sessions"
        case .agents:
            "Agents"
        case .models:
            "Models"
        case .changes:
            "Changes"
        case .history:
            "History"
        }
    }

    var icon: ICOSIcon {
        switch self {
        case .workspace:
            .workspace
        case .files:
            .fileManager
        case .terminal:
            .terminal
        case .problems:
            .bug
        case .sessions:
            .session
        case .agents:
            .agent
        case .models:
            .model
        case .changes:
            .branch
        case .history:
            .log
        }
    }

    static let workspaceItems: [DeveloperRuntimeSidebarItem] = [
        .workspace,
        .files,
        .terminal,
        .problems
    ]

    static let runtimeItems: [DeveloperRuntimeSidebarItem] = [
        .sessions,
        .agents,
        .models
    ]

    static let reviewItems: [DeveloperRuntimeSidebarItem] = [
        .changes,
        .history
    ]
}

// MARK: - Developer Runtime Sidebar Section

struct DeveloperRuntimeSidebarSection: View {
    let title: String
    let items: [DeveloperRuntimeSidebarItem]
    let selectedItem: DeveloperRuntimeSidebarItem
    let onSelect: (DeveloperRuntimeSidebarItem) -> Void

    @Environment(\.icosThemeDensity) private var density
    @Environment(\.icosTypographyScale) private var typographyScale

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSidebarTokens.rowSpacing)) {
            Text(title.uppercased())
                .font(.system(size: scaledFont(11), weight: .semibold))
                .foregroundStyle(ICOSSidebarColors.textSecondary)
                .tracking(0.8)

            VStack(spacing: scaled(ICOSSpacing.xs)) {
                ForEach(items) { item in
                    Button {
                        onSelect(item)
                    } label: {
                        HStack(spacing: scaled(ICOSSpacing.sm)) {
                            SVGImageView(icon: item.icon)
                                .frame(
                                    width: scaled(ICOSSidebarTokens.iconSM),
                                    height: scaled(ICOSSidebarTokens.iconSM)
                                )

                            Text(item.title)
                                .font(.system(size: scaledFont(12), weight: .medium))
                                .foregroundStyle(
                                    selectedItem == item
                                    ? ICOSSidebarColors.textPrimary
                                    : ICOSSidebarColors.textSecondary
                                )

                            Spacer()
                        }
                        .padding(.horizontal, scaled(ICOSSidebarTokens.rowHorizontalPadding))
                        .padding(.vertical, scaled(ICOSSidebarTokens.rowVerticalPadding))
                        .background(
                            RoundedRectangle(
                                cornerRadius: scaled(ICOSSidebarTokens.rowCornerRadius),
                                style: .continuous
                            )
                            .fill(
                                selectedItem == item
                                ? ICOSSidebarColors.rowActiveFill
                                : ICOSSidebarColors.rowPassiveFill
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
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