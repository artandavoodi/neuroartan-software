from pathlib import Path
import json
import re
from datetime import datetime

LIFECYCLE_STATES = {
    "Draft": {
        "allowed_transitions": [
            "Review",
            "Archived"
        ],
        "requires_approval": False
    },
    "Review": {
        "allowed_transitions": [
            "Approved",
            "Revision Required",
            "Archived"
        ],
        "requires_approval": True
    },
    "Revision Required": {
        "allowed_transitions": [
            "Draft",
            "Review",
            "Archived"
        ],
        "requires_approval": False
    },
    "Approved": {
        "allowed_transitions": [
            "Superseded",
            "Archived"
        ],
        "requires_approval": True
    },
    "Superseded": {
        "allowed_transitions": [
            "Archived"
        ],
        "requires_approval": True
    },
    "Archived": {
        "allowed_transitions": [],
        "requires_approval": True
    }
}

REQUIRED_GOVERNANCE_SECTIONS = [
    "Change Log",
    "Document Control",
    "END OF DOCUMENT"
]


def extract_status(text):
    match = re.search(r'status:\s*["\']?([^"\'\n]+)', text, re.I)

    if match:
        return match.group(1).strip()

    return "Draft"



def evaluate_governance_completeness(text):
    return {
        section: section in text
        for section in REQUIRED_GOVERNANCE_SECTIONS
    }



def determine_next_states(current_state):
    return LIFECYCLE_STATES.get(current_state, {}).get(
        "allowed_transitions",
        []
    )



def evaluate_document(path):
    p = Path(path)

    if not p.exists():
        return {
            "status": "FILE_NOT_FOUND",
            "path": path
        }

    text = p.read_text(errors="ignore")

    lifecycle_state = extract_status(text)

    governance = evaluate_governance_completeness(text)

    governance_complete = all(governance.values())

    return {
        "status": "LIFECYCLE_STATE_RESOLVED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "path": str(p),
        "current_lifecycle_state": lifecycle_state,
        "allowed_next_states": determine_next_states(lifecycle_state),
        "requires_approval": LIFECYCLE_STATES.get(
            lifecycle_state,
            {}
        ).get("requires_approval", False),
        "governance_sections": governance,
        "governance_complete": governance_complete,
        "recommended_transition": (
            "Review"
            if lifecycle_state == "Draft" and governance_complete
            else "Revision Required"
            if not governance_complete
            else lifecycle_state
        )
    }


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print(json.dumps({
            "status": "INVALID_ARGUMENTS",
            "usage": "15_lifecycle_state_engine.py <document_path>"
        }, indent=2))
        raise SystemExit(1)

    print(json.dumps(
        evaluate_document(sys.argv[1]),
        indent=2
    ))