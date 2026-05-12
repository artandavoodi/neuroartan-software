import Foundation

// MARK: - Web Search Tool (Cognitive Extension Layer)
// External retrieval capability for ICOS

final class WebSearchTool {

    struct SearchResult: Codable {
        let title: String
        let snippet: String
        let url: String
    }

    func search(query: String) async -> [SearchResult] {

        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.duckduckgo.com/?q=\(encoded)&format=json&no_redirect=1") else {
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Lightweight parsing fallback (DuckDuckGo instant answer is limited)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            let abstract = json?["AbstractText"] as? String ?? ""
            let heading = json?["Heading"] as? String ?? ""

            if !abstract.isEmpty {
                return [
                    SearchResult(
                        title: heading.isEmpty ? query : heading,
                        snippet: abstract,
                        url: json?["AbstractURL"] as? String ?? ""
                    )
                ]
            }

            return []

        } catch {
            return []
        }
    }
}