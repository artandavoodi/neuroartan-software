import Foundation

struct ExecutionValidationError: LocalizedError {
    let message: String

    var errorDescription: String? {
        message
    }
}

final class ExecutionValidator {

    func validate(input: String) throws {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            throw ExecutionValidationError(message: "Input is empty.")
        }

        guard trimmed.count <= 8_000 else {
            throw ExecutionValidationError(message: "Input exceeds execution limit.")
        }
    }
}
