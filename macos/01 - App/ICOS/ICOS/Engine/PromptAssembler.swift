import Foundation

final class PromptAssembler {

    // MARK: - Assemble

    func assemble(context: ExecutionContext, profile: UserProfile) -> String {

        // Production clean prompt
        // Only pass user intent, no visible scaffolding
        return context.input
    }
}