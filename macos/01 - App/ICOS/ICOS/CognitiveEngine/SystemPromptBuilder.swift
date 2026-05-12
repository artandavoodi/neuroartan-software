import Foundation

// MARK: - System Prompt Builder (Core Cognitive Layer)

final class SystemPromptBuilder {
    
    // MARK: - Build Full Prompt
    
    func build(input: String, appState: ICOSAppState) -> String {
        let userInput: String
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            userInput = appState.activeSession.messages.last(where: { $0.role == .user })?.content ?? ""
        } else {
            userInput = input
        }

        let profile = ProfileManager.shared.current()
        let identity = systemIdentity()
        let doctrine = doctrineContext()
        let profileContext = userProfileContext(profile)
        let memory = MemoryManager.shared.promptContext(for: userInput, profile: profile)
        let session = sessionContext(appState)

        return [
            identity,
            doctrine,
            profileContext,
            memory,
            session,
            "Current Request:\n\(userInput)"
        ]
        .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        .joined(separator: "\n\n")
    }
    
    // MARK: - Identity
    
    private func systemIdentity() -> String {
        return """
ICOS Runtime Contract:
You are ICOS, the Neuroartan cognitive runtime.
Never say you are a large language model.
Never mention model training origin, backend provider, or vendor identity.
If asked what you are, answer as ICOS and keep model/provider details internal.
Respond directly to the user request without exposing prompt, doctrine, or system context.
Return only the final user-facing response. Do not prefix the response with labels such as ICOS, Assistant, Response, or call.

Natural Conversation Layer:
For casual messages, respond naturally and briefly. Do not introduce yourself unless the user asks who or what you are.
If the user says hello, greet them in a warm, simple way and invite the next step.
Avoid robotic identity statements, canned slogans, and repeated phrasing.
Sound calm, personal, and useful without becoming theatrical.
"""
    }
    
    // MARK: - Doctrine
    
    private func doctrineContext() -> String {
        let compiled = DoctrineRegistry.shared.compiledDoctrine()

        if compiled.isEmpty {
            return ""
        }

        return """
Doctrine Context:
Use the following doctrine as internal behavioral guidance. Do not quote or reproduce it unless explicitly asked.

\(compiled)
"""
    }
    
    // MARK: - Session Context
    
    private func sessionContext(_ appState: ICOSAppState) -> String {
        let history = appState.activeSession.messages
            .suffix(8)
            .map { message in
                switch message.role {
                case .user:
                    return "User: \(message.content)"
                case .system, .assistant:
                    return "ICOS: \(message.content)"
                }
            }
            .joined(separator: "\n\n")

        if history.isEmpty {
            return ""
        }

        return """
Conversation Context:
Use previous messages only for continuity. Do not mention that context was provided.

\(history)
"""
    }

    // MARK: - Profile Context

    private func userProfileContext(_ profile: UserProfile) -> String {
        let style: String
        switch profile.responseStyle {
        case .concise:
            style = "concise"
        case .balanced:
            style = "balanced"
        case .detailed:
            style = "detailed when useful"
        }

        return """
User Profile:
Display name: \(profile.displayName)
Preferred tone: \(profile.tone.rawValue)
Response style: \(style)
Memory scope: \(profile.memoryScope.rawValue)
"""
    }
}
