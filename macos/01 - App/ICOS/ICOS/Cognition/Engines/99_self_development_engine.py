from pathlib import Path
from datetime import datetime
import json

STRATEGIC_ENGINE = Path(__file__).resolve().parent / "21_strategic_analysis_engine.py"
LEDGER = Path(__file__).resolve().parent / "task_continuity_ledger.json"
SELF_DEV_PLAN = Path(__file__).resolve().parent / "self_development_plan.json"

SELF_DEVELOPMENT_PRIORITIES = [
    {
        "priority": 1,
        "title": "Persistent Constitutional Memory Engine",
        "reason": "Required for long-term institutional cognition and cross-session continuity.",
        "target_maturity": "72/100"
    },
    {
        "priority": 2,
        "title": "Dependency-Aware Runtime Planner",
        "reason": "Required for autonomous execution sequencing and roadmap cognition.",
        "target_maturity": "78/100"
    },
    {
        "priority": 3,
        "title": "Autonomous Correction Recursion",
        "reason": "Required for self-correcting runtime cognition.",
        "target_maturity": "84/100"
    },
    {
        "priority": 4,
        "title": "Multi-Agent Cognition Mesh",
        "reason": "Required for institutional delegation and shared cognition.",
        "target_maturity": "90/100"
    },
    {
        "priority": 5,
        "title": "Self-Improving Runtime Intelligence",
        "reason": "Required for sovereign adaptive cognition.",
        "target_maturity": "100/100"
    }
]

def load_json(path, fallback):
    if not path.exists():
        return fallback

    try:
        return json.loads(path.read_text())
    except Exception:
        return fallback

def save_json(path, data):
    path.write_text(json.dumps(data, indent=2))

def evaluate_current_state():
    ledger = load_json(LEDGER, {
        "active_tasks": [],
        "completed_tasks": []
    })

    active_tasks = ledger.get("active_tasks", [])
    completed_tasks = ledger.get("completed_tasks", [])

    return {
        "active_task_count": len(active_tasks),
        "completed_task_count": len(completed_tasks),
        "institutional_continuity_established": LEDGER.exists(),
        "strategic_engine_exists": STRATEGIC_ENGINE.exists()
    }

def determine_next_priority(active_titles):
    for priority in SELF_DEVELOPMENT_PRIORITIES:
        if priority["title"] not in active_titles:
            return priority

    return SELF_DEVELOPMENT_PRIORITIES[-1]

def generate_self_development_plan():
    state = evaluate_current_state()

    ledger = load_json(LEDGER, {
        "active_tasks": []
    })

    active_titles = [
        t.get("title")
        for t in ledger.get("active_tasks", [])
    ]

    next_priority = determine_next_priority(active_titles)

    plan = {
        "status": "SELF_DEVELOPMENT_PLAN_GENERATED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "current_state": state,
        "current_maturity_estimate": "66/100",
        "next_priority": next_priority,
        "full_priority_chain": SELF_DEVELOPMENT_PRIORITIES,
        "strategic_goal": "Develop ICOS into a sovereign cognitive operating system with autonomous institutional reasoning.",
        "critical_missing_layers": [
            "Persistent semantic memory",
            "Delta-based graph synchronization",
            "Autonomous dependency reasoning",
            "Failure learning",
            "Adaptive execution cognition",
            "Multi-agent constitutional governance"
        ]
    }

    save_json(SELF_DEV_PLAN, plan)

    return plan

if __name__ == "__main__":
    print(json.dumps(
        generate_self_development_plan(),
        indent=2
    ))
