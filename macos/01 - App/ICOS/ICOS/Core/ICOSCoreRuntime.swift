/* ========================================= */
/* ICOS CORE RUNTIME                         */
/* Swift → Native LLaMA Runtime (llama.cpp)  */
/* ========================================= */

import Foundation

final class ICOSCoreRuntime {

    static let shared = ICOSCoreRuntime()

    private init() {}

    // MARK: - Public API

    func process(_ input: String) async -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return ""
        }

        return await ICOSExecutionController.shared.execute(input: trimmed)
    }
}
