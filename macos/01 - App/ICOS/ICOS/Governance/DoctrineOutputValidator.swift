import Foundation

/// Doctrine-driven output validator.
/// Enforces identity and boundary rules using Doctrine-derived constraints.
/// No hardcoded phrases; all constraints must be supplied by doctrine-derived patterns.
final class DoctrineOutputValidator {

    static let shared = DoctrineOutputValidator()

    private init() {}

    // MARK: - Public API

    /// Validates and, if necessary, transforms the model output according to doctrine constraints.
    /// - Parameters:
    ///   - output: Raw model output
    ///   - context: Optional context for future extensions
    /// - Returns: Doctrine-compliant output
    func validate(output: String, context: ValidationContext = .init()) -> String {
        let constraints = loadConstraints()

        // 1) Reject if forbidden patterns are present
        if containsForbidden(output, constraints: constraints) {
            return enforceIdentity(constraints: constraints)
        }

        // 2) Basic sanitation (non-destructive)
        let sanitized = sanitize(output)

        // 3) Final guard: ensure identity consistency if explicitly asked
        if context.requiresIdentityAssertion && !matchesIdentity(sanitized, constraints: constraints) {
            return enforceIdentity(constraints: constraints)
        }

        return sanitized
    }

    // MARK: - Constraint Loading (Doctrine-driven)

    /// Extract constraints from compiled doctrine.
    /// Expected to parse structured markers (to be added in doctrine files), e.g.:
    /// [FORBIDDEN] ... [/FORBIDDEN]
    /// [IDENTITY] ... [/IDENTITY]
    private func loadConstraints() -> Constraints {
        let compiled = DoctrineRegistry.shared.compiledDoctrine()

        // Deterministic doctrine-marker parsing strategy.
        let forbidden = extract(tag: "FORBIDDEN", from: compiled)
        let identity = extract(tag: "IDENTITY", from: compiled)

        return Constraints(forbiddenPatterns: forbidden, identityTemplates: identity)
    }

    // MARK: - Enforcement

    private func containsForbidden(_ text: String, constraints: Constraints) -> Bool {
        let normalizedText = normalized(text)
        for pattern in constraints.forbiddenPatterns {
            if normalizedText.contains(normalized(pattern)) {
                return true
            }
        }
        return false
    }

    private func enforceIdentity(constraints: Constraints) -> String {
        // Deterministic selection (first template)
        if let template = constraints.identityTemplates.first, !template.isEmpty {
            return template
        }
        return "I am ICOS, the Neuroartan cognitive runtime."
    }

    private func matchesIdentity(_ text: String, constraints: Constraints) -> Bool {
        for template in constraints.identityTemplates {
            if text.contains(template) {
                return true
            }
        }
        return false
    }

    // MARK: - Helpers

    private func sanitize(_ text: String) -> String {
        var t = text
        t = t.replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)
        return t.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extract(tag: String, from text: String) -> [String] {
        let pattern = "\\[\(tag)\\]([\\s\\S]*?)\\[/\(tag)\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        let nsText = text as NSString
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))

        var results: [String] = []
        for m in matches {
            if m.numberOfRanges > 1 {
                let range = m.range(at: 1)
                if range.location != NSNotFound {
                    let segment = nsText.substring(with: range).trimmingCharacters(in: .whitespacesAndNewlines)
                    if tag == "IDENTITY" {
                        if !segment.isEmpty {
                            results.append(segment)
                        }
                    } else {
                        let lines = segment.components(separatedBy: .newlines)
                            .map { line in
                                line
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                                    .replacingOccurrences(of: "^-\\s*", with: "", options: .regularExpression)
                            }
                            .filter { !$0.isEmpty }
                        results.append(contentsOf: lines)
                    }
                }
            }
        }
        return results
    }

    private func normalized(_ text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Models

struct Constraints {
    let forbiddenPatterns: [String]
    let identityTemplates: [String]
}

struct ValidationContext {
    var requiresIdentityAssertion: Bool = false
}
