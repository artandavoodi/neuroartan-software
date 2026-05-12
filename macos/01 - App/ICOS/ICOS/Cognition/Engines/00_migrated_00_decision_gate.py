def decide_next_action(quality_score, patch_status, runtime_status):
    if quality_score < 85:
        return {
            "action": "STOP",
            "reason": "quality score below execution threshold"
        }

    if runtime_status not in ["SERVER_OK", "PLAYWRIGHT_CAPTURE_OK"]:
        return {
            "action": "VERIFY_RUNTIME",
            "reason": "runtime verification incomplete"
        }

    if patch_status == "PATCH_PLAN_READY":
        return {
            "action": "PREPARE_PATCH",
            "reason": "all gates passed"
        }

    if patch_status == "NO_CHANGE_REQUIRED":
        return {
            "action": "REPORT_NO_CHANGE",
            "reason": "target already satisfies intended state"
        }

    return {
        "action": "REVIEW",
        "reason": "unclassified execution state"
    }
