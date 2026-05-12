import Foundation

/* =============================================================================
   00) TERMINAL STREAM EVENT
============================================================================= */
struct TerminalStreamEvent: Identifiable {
    let id: UUID
    let command: String
    let output: String
    let exitCode: Int32?
    let isFinal: Bool
    let createdAt: Date

    init(
        command: String,
        output: String,
        exitCode: Int32? = nil,
        isFinal: Bool = true
    ) {
        self.id = UUID()
        self.command = command
        self.output = output
        self.exitCode = exitCode
        self.isFinal = isFinal
        self.createdAt = Date()
    }
}

enum TerminalExecutionStatus: String {
    case idle = "Idle"
    case running = "Running"
    case completed = "Completed"
    case failed = "Failed"
    case cancelled = "Cancelled"
}

/* =============================================================================
   01) TERMINAL BRIDGE
============================================================================= */
final class TerminalBridge {

    static let shared = TerminalBridge()

    private let queue = DispatchQueue(
        label: "com.neuroartan.runtime.terminal",
        qos: .userInitiated
    )

    private(set) var history: [TerminalStreamEvent] = []
    private var currentProcess: Process?
    private var currentPipe: Pipe?

    private init() {}

    /* -------------------------------------------------------------------------
       COMMAND EXECUTION
    ------------------------------------------------------------------------- */
    func execute(
        command: String,
        workingDirectory: String? = nil,
        onOutput: ((TerminalStreamEvent) -> Void)? = nil,
        completion: @escaping (TerminalStreamEvent) -> Void
    ) {

        queue.async {
            guard self.currentProcess == nil else {
                let event = TerminalStreamEvent(
                    command: command,
                    output: "Another terminal command is already running.",
                    exitCode: -1
                )
                completion(event)
                return
            }

            let process = Process()
            let pipe = Pipe()
            var accumulatedOutput = ""

            process.standardOutput = pipe
            process.standardError = pipe
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")

            process.arguments = [
                "-c",
                command
            ]

            if let workingDirectory {
                process.currentDirectoryURL = URL(
                    fileURLWithPath: workingDirectory
                )
            }

            self.currentProcess = process
            self.currentPipe = pipe

            pipe.fileHandleForReading.readabilityHandler = { handle in
                let data = handle.availableData
                guard !data.isEmpty else { return }
                let chunk = String(data: data, encoding: .utf8) ?? ""
                guard !chunk.isEmpty else { return }

                self.queue.async {
                    accumulatedOutput += chunk
                    let event = TerminalStreamEvent(
                        command: command,
                        output: accumulatedOutput,
                        isFinal: false
                    )
                    RuntimeEventBus.shared.emit(
                        type: .terminalOutput,
                        payload: [
                            "command": command,
                            "output": chunk
                        ]
                    )
                    onOutput?(event)
                }
            }

            process.terminationHandler = { terminatedProcess in
                self.queue.async {
                    pipe.fileHandleForReading.readabilityHandler = nil

                    let remainingData = pipe.fileHandleForReading.readDataToEndOfFile()
                    if !remainingData.isEmpty,
                       let remainingOutput = String(data: remainingData, encoding: .utf8),
                       !remainingOutput.isEmpty {
                        accumulatedOutput += remainingOutput
                    }

                    self.currentProcess = nil
                    self.currentPipe = nil

                    let output = accumulatedOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? "Command completed with no output."
                        : accumulatedOutput

                    let event = TerminalStreamEvent(
                        command: command,
                        output: output,
                        exitCode: terminatedProcess.terminationStatus
                    )

                    self.history.append(event)

                    RuntimeEventBus.shared.emit(
                        type: .terminalOutput,
                        payload: [
                            "command": command,
                            "output": output,
                            "exitCode": "\(terminatedProcess.terminationStatus)"
                        ]
                    )

                    completion(event)
                }
            }

            do {
                try process.run()

            } catch {
                pipe.fileHandleForReading.readabilityHandler = nil
                self.currentProcess = nil
                self.currentPipe = nil

                let event = TerminalStreamEvent(
                    command: command,
                    output: error.localizedDescription,
                    exitCode: -1
                )

                self.history.append(event)

                RuntimeEventBus.shared.emit(
                    type: .terminalOutput,
                    payload: [
                        "command": command,
                        "output": error.localizedDescription
                    ]
                )

                completion(event)
            }
        }
    }

    func cancelCurrentCommand() {
        queue.async {
            guard let currentProcess = self.currentProcess else { return }
            currentProcess.terminate()
            self.currentProcess = nil
            self.currentPipe?.fileHandleForReading.readabilityHandler = nil
            self.currentPipe = nil

            RuntimeEventBus.shared.emit(
                type: .terminalOutput,
                payload: [
                    "command": "cancel",
                    "output": "Terminal command cancelled."
                ]
            )
        }
    }

    /* -------------------------------------------------------------------------
       HISTORY ACCESS
    ------------------------------------------------------------------------- */
    func latestOutput() -> String? {
        history.last?.output
    }

    func latestCommand() -> String? {
        history.last?.command
    }

    func clearHistory() {
        history.removeAll()
    }
}
