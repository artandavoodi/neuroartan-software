def decide(task_type, confidence):
    if confidence < 60:
        return {"action": "STOP", "reason": "confidence too low"}
    if task_type in ["code_edit", "layout_fix", "runtime_change"]:
        return {"action": "SCAN_READ_VERIFY_PATCH", "reason": "technical task"}
    return {"action": "ANSWER_WITH_SOURCE", "reason": "informational task"}
