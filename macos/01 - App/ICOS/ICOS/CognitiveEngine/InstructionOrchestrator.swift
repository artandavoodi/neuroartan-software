import Foundation

// MARK: - Instruction Orchestrator (RR-002)

final class InstructionOrchestrator {
    
    private let executionController = ICOSExecutionController.shared
    private let webSearchTool = WebSearchTool()
    private let responseShaper = ResponseShaper()
    
    func process(input: String, appState: ICOSAppState) async {
        
        // Step 1: Normalize Input
        let normalized = normalize(input)
        
        // Step 3: Web search decision
        var enrichedInput = normalized
        
        if needsWebSearch(normalized) {
            let results = await webSearchTool.search(query: normalized)
            
            if !results.isEmpty {
                let formatted = results.map { r in
                    "- \(r.title): \(r.snippet)"
                }.joined(separator: "\n")
                
                enrichedInput = normalized + "\n\nWeb Context:\n" + formatted
            }
        }
        
        // Step 4: Execute through the single execution controller.
        do {
            let rawResponse = try await executionController.execute(input: enrichedInput)
            let response = responseShaper.shape(rawResponse, for: normalized)
            
            // Step 5: Commit assistant response to active session
            await MainActor.run {
                appState.activeSession.appendAssistant(response)
            }
            MemoryManager.shared.recordInteraction(
                userInput: normalized,
                assistantOutput: response,
                profile: ProfileManager.shared.current()
            )
        } catch {
            await MainActor.run {
                appState.activeSession.appendAssistant("Execution failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Normalization
    
    private func normalize(_ input: String) -> String {
        input.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func needsWebSearch(_ input: String) -> Bool {
        let lower = input.lowercased()
        let localMarkers = [
            "website",
            "homepage",
            "platform",
            "software",
            "repo",
            "repository",
            "codebase",
            "file",
            "fix",
            "change",
            "replace",
            "debug",
            "audit",
            "scan",
        ]

        if localMarkers.contains(where: { lower.contains($0) }) {
            return false
        }

        let explicitWebMarkers = [
            "search the web",
            "browse the web",
            "web search",
            "look up online",
            "internet search",
            "current news",
            "latest online",
        ]

        return explicitWebMarkers.contains(where: { lower.contains($0) })
    }
}
