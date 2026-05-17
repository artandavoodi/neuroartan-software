import SwiftUI

// MARK: - Settings Category Shell

struct SettingsCategoryTabItem: Identifiable {
    let id: String
    let title: String
    let content: () -> AnyView

    init<V: View>(id: String, title: String, @ViewBuilder content: @escaping () -> V) {
        self.id = id
        self.title = title
        self.content = { AnyView(content()) }
    }
}

struct SettingsCategoryShell: View {
    let title: String
    let subtitle: String
    let tabs: [SettingsCategoryTabItem]

    @State private var selectedTabID: String

    init(title: String, subtitle: String, tabs: [SettingsCategoryTabItem]) {
        self.title = title
        self.subtitle = subtitle
        self.tabs = tabs
        _selectedTabID = State(initialValue: tabs.first?.id ?? "")
    }

    var body: some View {
        VStack(alignment: .center, spacing: ICOSSpacing.lg) {
            if tabs.isEmpty {
                Text("No tabs configured.")
                    .font(.system(size: ICOSControlTokens.rowSubtitleFontSize, weight: .regular))
                    .foregroundStyle(ICOSColors.textSecondary)
            } else {
                Picker("", selection: $selectedTabID) {
                    ForEach(tabs) { tab in
                        Text(tab.title).tag(tab.id)
                    }
                }
                .pickerStyle(.segmented)
               .frame(maxWidth: .infinity, alignment: .center)
 .frame(maxWidth: .infinity, alignment: .center)

                activeTabView
            }
        }
        .padding(.vertical, ICOSSpacing.sm)
    }

    @ViewBuilder
    private var activeTabView: some View {
        if let selectedTab = tabs.first(where: { $0.id == selectedTabID }) {
            selectedTab.content()
        }
    }
}
