from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Any, Dict, List
import hashlib
import json

STATE = Path(__file__).with_name(
    "failure_learning_state.json"
)

ADAPTIVE_STATE = Path(
    "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime/ContinueBridge/PythonRuntime/icos_intelligence/runtime_adaptive_learning.json"
)

SEVERITY_WEIGHTS = {
    "critical": 5,
    "high": 4,
    "medium": 3,
    "low": 2,
    "background": 1
}

FAILURE_PATTERNS = {
    "path_assumption": [
        "wrong directory",
        "missing path",
        "hallucinated path"
    ],
    "runtime_verification": [
        "not applied",
        "ui mismatch",
        "verification failed"
    ],
    "governance": [
        "metadata",
        "document id",
        "routing"
    ],
    "execution": [
        "dependency",
        "scheduler",
        "runtime"
    ]
}

def load_json(path: Path, fallback: Dict[str, Any]) -> Dict[str, Any]:
    if not path.exists():
        return fallback

    try:
        loaded = json.loads(path.read_text())

        if not isinstance(loaded, dict):
            return fallback

        for key, value in fallback.items():
            if key not in loaded:
                loaded[key] = value

        return loaded

    except Exception:
        return fallback

def save_json(path: Path, data: Dict[str, Any]) -> None:
    path.write_text(json.dumps(data, indent=2))

def default_state() -> Dict[str, Any]:
    return {
        "version": 2,
        "failures": [],
        "pattern_frequency": {},
        "adaptive_rules": [],
        "last_update": None
    }

def classify_failure(event: Dict[str, Any]) -> str:
    combined = json.dumps(event).lower()

    scores = {}

    for category, signals in FAILURE_PATTERNS.items():
        scores[category] = sum(
            combined.count(signal)
            for signal in signals
        )

    return max(scores, key=scores.get)

def generate_failure_id(event: Dict[str, Any]) -> str:
    payload = json.dumps(event, sort_keys=True)

    digest = hashlib.sha1(payload.encode()).hexdigest()[:10]

    return f"FAIL-{digest.upper()}"

def derive_adaptive_rule(category: str) -> str:
    rules = {
        "path_assumption": "Always perform live scan before resolving file ownership or path routing.",
        "runtime_verification": "Require browser/runtime verification before confirming execution success.",
        "governance": "Enforce metadata and document-ID governance before autonomous generation.",
        "execution": "Evaluate dependencies before execution sequencing."
    }

    return rules.get(
        category,
        "Increase verification depth before autonomous continuation."
    )

def learn_failure(event: Dict[str, Any]) -> Dict[str, Any]:
    state = load_json(
        STATE,
        default_state()
    )

    adaptive = load_json(
        ADAPTIVE_STATE,
        {
            "adaptive_rules": []
        }
    )

    category = classify_failure(event)

    failure_id = generate_failure_id(event)

    severity = event.get("severity", "medium")

    learned_rule = derive_adaptive_rule(category)

    record = {
        "failure_id": failure_id,
        "recorded_at": datetime.now().isoformat(timespec="seconds"),
        "category": category,
        "severity": severity,
        "severity_score": SEVERITY_WEIGHTS.get(severity, 3),
        "event": event,
        "learned_rule": learned_rule
    }

    state["failures"].append(record)

    state["pattern_frequency"][category] = (
        state["pattern_frequency"].get(category, 0) + 1
    )

    if learned_rule not in adaptive["adaptive_rules"]:
        adaptive["adaptive_rules"].append(learned_rule)

    state["adaptive_rules"] = adaptive["adaptive_rules"]
    state["last_update"] = record["recorded_at"]

    save_json(STATE, state)
    save_json(ADAPTIVE_STATE, adaptive)

    return {
        "status": "FAILURE_LEARNING_RECORDED",
        "failure_id": failure_id,
        "category": category,
        "learned_rule": learned_rule,
        "pattern_frequency": state["pattern_frequency"][category],
        "adaptive_rule_count": len(adaptive["adaptive_rules"]),
        "current_failure_count": len(state["failures"])
    }

def recent_failures(limit: int = 10) -> List[Dict[str, Any]]:
    state = load_json(
        STATE,
        default_state()
    )

    return state["failures"][-limit:]

def failure_summary() -> Dict[str, Any]:
    state = load_json(
        STATE,
        default_state()
    )

    return {
        "status": "FAILURE_LEARNING_ACTIVE",
        "failure_count": len(state["failures"]),
        "pattern_frequency": state["pattern_frequency"],
        "adaptive_rule_count": len(state["adaptive_rules"]),
        "last_update": state["last_update"]
    }

if __name__ == "__main__":
    sample = learn_failure({
        "failure_type": "runtime_verification",
        "severity": "high",
        "lesson": "Static file edit completed but runtime ownership layer still overrode content.",
        "event": "Homepage hero text remained unchanged after HTML mutation.",
        "resolution": "Add runtime/browser verification before confirming completion."
    })

    print(json.dumps({
        "learning_result": sample,
        "summary": failure_summary(),
        "recent_failures": recent_failures(3)
    }, indent=2))
