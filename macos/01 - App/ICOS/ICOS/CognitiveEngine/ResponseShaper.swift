import Foundation

final class ResponseShaper {
    func shape(_ response: String, for input: String) -> String {
        let inputText = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var cleaned = response
            .replacingOccurrences(of: "\r\n", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        cleaned = stripRolePrefixes(cleaned)
        cleaned = stripIdentityOverAnswer(cleaned, input: inputText)
        cleaned = collapseRepeatedLines(cleaned)

        if isCasualGreeting(inputText), isIdentityHeavy(cleaned) {
            cleaned = "Hey. What do you want to work on?"
        }

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func stripRolePrefixes(_ text: String) -> String {
        var result = text
        let prefixes = [
            "ICOS:",
            "Assistant:",
            "Response:",
            "Answer:",
            "call:",
            "Call:"
        ]

        for prefix in prefixes {
            if result.lowercased().hasPrefix(prefix.lowercased()) {
                result = String(result.dropFirst(prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return result
    }

    private func stripIdentityOverAnswer(_ text: String, input: String) -> String {
        guard !asksForIdentity(input) else { return text }

        let blockedOpeners = [
            "i am icos",
            "i'm icos",
            "i am the icos",
            "i'm the icos",
            "as icos",
            "icos is"
        ]

        let lower = text.lowercased()
        guard blockedOpeners.contains(where: { lower.hasPrefix($0) }) else { return text }

        let sentences = text
            .split(whereSeparator: { ".!?".contains($0) })
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let nonIdentity = sentences.dropFirst().joined(separator: ". ")
        return nonIdentity.isEmpty ? text : nonIdentity + "."
    }

    private func collapseRepeatedLines(_ text: String) -> String {
        var seen = Set<String>()
        var lines: [String] = []

        for line in text.components(separatedBy: "\n") {
            let normalized = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if normalized.isEmpty {
                lines.append(line)
                continue
            }
            if seen.insert(normalized.lowercased()).inserted {
                lines.append(line)
            }
        }

        return lines.joined(separator: "\n")
    }

    private func isCasualGreeting(_ input: String) -> Bool {
        ["hi", "hey", "hello", "yo", "sup"].contains(input)
    }

    private func asksForIdentity(_ input: String) -> Bool {
        input.contains("who are you") || input.contains("what are you") || input.contains("your identity")
    }

    private func isIdentityHeavy(_ response: String) -> Bool {
        let lower = response.lowercased()
        return lower.contains("cognitive runtime") ||
            lower.contains("large language model") ||
            lower.contains("trained by") ||
            lower.contains("backend provider")
    }
}
