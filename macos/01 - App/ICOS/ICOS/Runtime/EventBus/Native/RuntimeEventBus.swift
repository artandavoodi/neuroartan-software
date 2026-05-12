import Foundation

/* =============================================================================
   00) RUNTIME EVENT TYPES
============================================================================= */
enum RuntimeEventType: String {
    case runtimeBoot
    case runtimeShutdown
    case activeFileChanged
    case terminalOutput
    case patchApplied
    case patchRejected
    case workspaceIndexed
    case modelChanged
}

/* =============================================================================
   01) RUNTIME EVENT
============================================================================= */
struct RuntimeEvent: Identifiable {
    let id: UUID
    let type: RuntimeEventType
    let payload: [String: String]
    let createdAt: Date

    init(
        type: RuntimeEventType,
        payload: [String: String] = [:]
    ) {
        self.id = UUID()
        self.type = type
        self.payload = payload
        self.createdAt = Date()
    }
}

/* =============================================================================
   02) RUNTIME EVENT BUS
============================================================================= */
final class RuntimeEventBus {

    static let shared = RuntimeEventBus()

    private var listeners: [UUID:(RuntimeEvent) -> Void] = [:]
    private let queue = DispatchQueue(
        label: "com.neuroartan.runtime.eventbus",
        qos: .userInitiated
    )

    private init() {}

    @discardableResult
    func subscribe(
        _ listener: @escaping (RuntimeEvent) -> Void
    ) -> UUID {

        let token = UUID()

        queue.async {
            self.listeners[token] = listener
        }

        return token
    }

    func unsubscribe(_ token: UUID) {
        queue.async {
            self.listeners.removeValue(forKey: token)
        }
    }

    func emit(_ event: RuntimeEvent) {
        queue.async {
            self.listeners.values.forEach { listener in
                listener(event)
            }
        }
    }

    func emit(
        type: RuntimeEventType,
        payload: [String: String] = [:]
    ) {
        let event = RuntimeEvent(
            type: type,
            payload: payload
        )

        emit(event)
    }
}