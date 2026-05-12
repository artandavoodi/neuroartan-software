import Foundation

// MARK: - Runtime Engine (Execution Mode)
// Canonical runtime selector used across ICOS.

enum RuntimeEngine {
    case icos
    case local
    case cloud
}
