import Foundation

final class ICOSExecutionController {

    static let shared = ICOSExecutionController()

    private let profileManager = ProfileManager.shared
    private let validator = ExecutionValidator()
    private let router = ExecutionRouter()

    private init() {}

    // MARK: - Public Entry

    func execute(input: String) async throws -> String {

        // 1. Validate
        try validator.validate(input: input)

        // 2. Resolve Profile
        let profile = profileManager.current()

        // 3. Route Execution
        let result = try await router.route(
            input: input,
            profile: profile
        )

        return result
    }
}