import SwiftUI
import Combine

// MARK: - Browser Use View

struct BrowserUseView: View {
    @Environment(\.icosTypographyScale) private var typographyScale
    @StateObject private var viewModel = BrowserUseViewModel()
    @State private var webSearchEnabled = true
    @State private var browserAgentEnabled = false

    init(shellState: Any? = nil) {}

    var body: some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.md)) {
            sectionCard(title: "Browser Agent") {
                ICOSToggleRow("Built-in web search", isOn: $webSearchEnabled)
                ICOSToggleRow("Agent browsing tools", isOn: $browserAgentEnabled)
            }

            sectionCard(title: "Search Execution") {
                HStack(spacing: scaled(ICOSSpacing.sm)) {
                    SVGImageView(icon: .search)
                        .frame(width: ICOSControlTokens.buttonIconSize, height: ICOSControlTokens.buttonIconSize)
                        .foregroundStyle(ICOSColors.textSecondary)

                    ICOSTextInput("", placeholder: "Search the web", text: $viewModel.query, showBorder: false, compact: true)
                        .onSubmit { Task { await viewModel.search() } }

                    ICOSButton(
                        viewModel.isSearching ? "Searching" : "Search",
                        icon: .search,
                        role: .primary
                    ) {
                        Task { await viewModel.search() }
                    }
                    .disabled(
                        viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        viewModel.isSearching
                    )
                }

                if viewModel.results.isEmpty && !viewModel.statusText.isEmpty {
                    Text(viewModel.statusText)
                        .font(.system(size: scaled(ICOSBrowserUseTokens.statusFontSize)))
                        .foregroundStyle(ICOSSidebarColors.textSecondary)
                }

                ForEach(viewModel.results) { result in
                    VStack(alignment: .leading, spacing: scaled(ICOSSpacing.xs)) {
                        Text(result.title)
                            .font(.system(size: scaled(ICOSBrowserUseTokens.resultTitleFontSize), weight: .semibold))
                            .foregroundStyle(ICOSColors.textPrimary)

                        Text(result.snippet)
                            .font(.system(size: scaled(ICOSBrowserUseTokens.resultSnippetFontSize)))
                            .foregroundStyle(ICOSColors.textSecondary)

                        if !result.url.isEmpty {
                            Text(result.url)
                                .font(.system(size: scaled(ICOSBrowserUseTokens.resultURLFontSize), design: .monospaced))
                                .foregroundStyle(ICOSSidebarColors.textSecondary.opacity(ICOSBrowserUseTokens.resultURLTextOpacity))
                                .lineLimit(ICOSBrowserUseTokens.resultURLLineLimit)
                        }
                    }
                    .padding(scaled(ICOSSpacing.sm))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        if ICOSMaterials.showsLayeredSurfaces {
                            RoundedRectangle(cornerRadius: ICOSControlTokens.fieldCornerRadius, style: .continuous)
                                .fill(ICOSMaterials.floatingSurface)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Scaling

    private func scaled(_ value: CGFloat) -> CGFloat {
        value * typographyScale
    }

    // MARK: - Section Card

    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: scaled(ICOSSpacing.sm)) {
            Text(title)
                .font(.system(size: scaled(ICOSBrowserUseTokens.sectionTitleFontSize), weight: .semibold))
                .foregroundStyle(ICOSColors.textPrimary)

            content()
        }
        .padding(.horizontal, scaled(ICOSSidebarTokens.contentHorizontalPadding))
        .padding(.vertical, scaled(ICOSSpacing.md))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if ICOSMaterials.showsLayeredSurfaces {
                RoundedRectangle(cornerRadius: ICOSPanelTokens.cornerRadius, style: .continuous)
                    .fill(ICOSMaterials.panelBackground)
            }
        }
    }
}

// MARK: - Browser Search Result

struct BrowserSearchResult: Identifiable {
    let id = UUID()
    let title: String
    let snippet: String
    let url: String
}

// MARK: - Browser Use View Model

@MainActor
final class BrowserUseViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [BrowserSearchResult] = []
    @Published var statusText = ""
    @Published var isSearching = false

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isSearching = true
        defer { isSearching = false }

        results = []
        statusText = "Searching…"

        guard let encodedQuery = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://duckduckgo.com/html/?q=\(encodedQuery)") else {
            statusText = "Invalid search query."
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let html = String(decoding: data, as: UTF8.self)
            let parsedResults = parseSearchResults(from: html)

            if parsedResults.isEmpty {
                statusText = "No results returned."
            } else {
                results = parsedResults
                statusText = ""
            }
        } catch {
            statusText = "Search failed: \(error.localizedDescription)"
        }
    }

    private func parseSearchResults(from html: String) -> [BrowserSearchResult] {
        let blocks = html.components(separatedBy: "result__title")
        var parsed: [BrowserSearchResult] = []

        for block in blocks.dropFirst().prefix(8) {
            let title = extractText(
                from: block,
                startMarker: ">",
                endMarker: "</a>"
            )

            let snippet = extractText(
                from: block,
                startMarker: "result__snippet",
                endMarker: "</a>"
            )

            let url = extractURL(from: block)

            if !title.isEmpty {
                parsed.append(
                    BrowserSearchResult(
                        title: cleanHTML(title),
                        snippet: cleanHTML(snippet),
                        url: url
                    )
                )
            }
        }

        return parsed
    }

    private func extractURL(from block: String) -> String {
        guard let hrefRange = block.range(of: "href=\"") else { return "" }
        let remaining = block[hrefRange.upperBound...]
        guard let endRange = remaining.range(of: "\"") else { return "" }
        return cleanHTML(String(remaining[..<endRange.lowerBound]))
    }

    private func extractText(
        from source: String,
        startMarker: String,
        endMarker: String
    ) -> String {
        guard let startRange = source.range(of: startMarker) else { return "" }
        let remaining = source[startRange.upperBound...]
        guard let endRange = remaining.range(of: endMarker) else { return "" }
        return String(remaining[..<endRange.lowerBound])
    }

    private func cleanHTML(_ value: String) -> String {
        value
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#x27;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
