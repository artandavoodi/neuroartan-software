from pathlib import Path
from datetime import datetime
import json

LEDGER = Path(__file__).resolve().parent / "task_continuity_ledger.json"
ESCALATION_STATE = Path(__file__).resolve().parent / "governance_escalation_state.json"

ESCALATION_RULES = {
    "legal": {
        "escalate_to": [
            "General Counsel Agent",
            "Governance Synchronization Authority"
        ],
        "severity": "critical"
    },
    "finance": {
        "escalate_to": [
            "Chief Financial Officer Agent",
            "General Counsel Agent"
        ],
        "severity": "high"
    },
    "governance": {
        "escalate_to": [
            "Governance Synchronization Authority"
        ],
        "severity": "high"
    },
    "runtime": {
        "escalate_to": [
            "Website Systems & Development Agent"
        ],
        "severity": "medium"
    },
    "institutional": {
        "escalate_to": [
            "Executive Command Office Agent"
        ],
        "severity": "critical"
    }
}

RISK_SIGNALS = {
    "legal": [
        "contract",
        "policy",
        "privacy",
        "gdpr",
        "compliance"
    ],
    "finance": [
        "financial",
        "valuation",
        "funding",
        "investment"
    ],
    "governance": [
        "authority",
        "constitutional",
        "routing",
        "decision"
    ],
    "runtime": [
        "runtime",
        "memory",
        "scheduler",
        "verification"
    ],
    "institutional": [
        "sovereign",
        "institutional",
        "multi-agent",
        "critical"
    ]
}



def load_json(path, fallback):
    if not path.exists():
        return fallback

    try:
        return json.loads(path.read_text())
    except Exception:
        return fallback



def save_json(path, data):
    path.write_text(json.dumps(data, indent=2))



def classify_risk(text):
    lowered = text.lower()

    scores = {}

    for category, signals in RISK_SIGNALS.items():
        scores[category] = sum(
            lowered.count(signal)
            for signal in signals
        )

    return max(scores, key=scores.get)



def resolve_escalation(category):
    return ESCALATION_RULES.get(category, {
        "escalate_to": [
            "Executive Command Office Agent"
        ],
        "severity": "medium"
    })



def generate_escalation_report(subject, description):
    ledger = load_json(LEDGER, {
        "active_tasks": [],
        "completed_tasks": []
    })

    category = classify_risk(f"{subject} {description}")

    escalation = resolve_escalation(category)

    report = {
        "status": "GOVERNANCE_ESCALATION_GENERATED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "subject": subject,
        "description": description,
        "risk_category": category,
        "severity": escalation["severity"],
        "escalation_targets": escalation["escalate_to"],
        "active_task_count": len(ledger.get("active_tasks", [])),
        "recommended_actions": [
            "Route to escalation targets",
            "Pause autonomous execution if severity is critical",
            "Register escalation event in constitutional memory",
            "Require governance review before continuation"
        ],
        "governance_state": {
            "requires_human_review": escalation["severity"] in [
                "critical",
                "high"
            ],
            "autonomous_execution_allowed": escalation["severity"] not in [
                "critical"
            ]
        }
    }

    save_json(ESCALATION_STATE, report)

    return report


if __name__ == "__main__":
    print(json.dumps(
        generate_escalation_report(
            "Persistent Constitutional Memory Governance",
            "Critical institutional runtime memory system affecting sovereign cognition continuity and governance integrity."
        ),
        indent=2
    ))
