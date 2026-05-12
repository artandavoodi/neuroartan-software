import json
from datetime import datetime

def create_plan(goal):
    return {
        "status": "PLAN_CREATED",
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "goal": goal,
        "phases": [
            "scan",
            "resolve owners",
            "build owner chain",
            "plan patch",
            "apply safely",
            "verify",
            "retry if needed"
        ]
    }

if __name__ == "__main__":
    import sys
    print(json.dumps(create_plan(" ".join(sys.argv[1:])), indent=2))
