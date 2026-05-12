import json
from datetime import datetime

def plan(goal):
    return {
        "status": "INSTITUTIONAL_PLAN_CREATED",
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "goal": goal,
        "sequence": [
            "retrieve relevant doctrine",
            "resolve authority domain",
            "resolve placement",
            "audit document IDs",
            "draft or edit under global metadata standard",
            "route to required agent/reviewer",
            "record change log",
            "verify document control",
            "update memory graph"
        ]
    }

if __name__ == "__main__":
    import sys
    print(json.dumps(plan(" ".join(sys.argv[1:])), indent=2))
