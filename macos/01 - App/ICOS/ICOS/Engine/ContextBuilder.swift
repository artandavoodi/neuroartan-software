import Foundation

struct ExecutionContext {
    let input: String
    let profile: UserProfile
    let timestamp: Date
}

final class ContextBuilder {

    // MARK: - Build Context

    func buildContext(input: String, profile: UserProfile) -> ExecutionContext {
        return ExecutionContext(
            input: input,
            profile: profile,
            timestamp: Date()
        )
    }
}