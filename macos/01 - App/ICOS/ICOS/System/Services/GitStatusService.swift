import Foundation
import Combine

// MARK: - Git Status Service
// Minimal repository status owner for developer review, problems, and composer context.

@MainActor
final class GitStatusService: ObservableObject {
    @Published private(set) var changedFiles: [GitChangedFile] = []
    @Published private(set) var branchName = "No repository"
    @Published private(set) var statusText = "Git status has not run."
    @Published private(set) var isRefreshing = false
    @Published private(set) var lastRefreshedAt: Date?

    func refresh(rootURL: URL?) {
        guard let rootURL else {
            changedFiles = []
            branchName = "No workspace"
            statusText = "Import a workspace before reading Git status."
            return
        }

        isRefreshing = true
        statusText = "Reading Git status..."

        Task.detached { [rootURL] in
            let branch = Self.runGit(arguments: ["branch", "--show-current"], rootURL: rootURL)
            let status = Self.runGit(arguments: ["status", "--short"], rootURL: rootURL)

            await MainActor.run {
                self.branchName = branch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? "Detached or unavailable"
                    : branch.trimmingCharacters(in: .whitespacesAndNewlines)
                self.changedFiles = Self.parseStatus(status)
                self.statusText = self.changedFiles.isEmpty
                    ? "Working tree clean."
                    : "\(self.changedFiles.count) changed file\(self.changedFiles.count == 1 ? "" : "s")."
                self.lastRefreshedAt = Date()
                self.isRefreshing = false
            }
        }
    }

    nonisolated private static func runGit(arguments: [String], rootURL: URL) -> String {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["git", "-C", rootURL.path] + arguments
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return error.localizedDescription
        }
    }

    nonisolated private static func parseStatus(_ output: String) -> [GitChangedFile] {
        output
            .split(separator: "\n")
            .compactMap { line in
                guard line.count >= 4 else { return nil }
                let status = String(line.prefix(2)).trimmingCharacters(in: .whitespaces)
                let pathStart = line.index(line.startIndex, offsetBy: 3)
                let path = String(line[pathStart...])
                return GitChangedFile(path: path, status: status.isEmpty ? "?" : status)
            }
    }
}

struct GitChangedFile: Identifiable, Hashable {
    var id: String { "\(status):\(path)" }
    let path: String
    let status: String
}
