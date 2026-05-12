def reason(goal, evidence):
    return {
        "status": "BEHAVIORAL_REASONING_READY",
        "goal": goal,
        "decision": "verify evidence before acting",
        "evidence_count": len(evidence),
        "required_next_steps": [
            "confirm owner chain",
            "confirm runtime behavior",
            "plan minimal patch",
            "verify after patch"
        ]
    }
