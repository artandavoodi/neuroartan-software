import Foundation

final class ICOSRuntimeBridge {

    static let shared = ICOSRuntimeBridge()

    private let executionController = ICOSExecutionController.shared

    private init() {}

    func execute(_ input: String) async throws -> String {
        return try await executionController.execute(input: input)
    }
}