from pathlib import Path
import json
from datetime import datetime

PLAN_FILE = Path(__file__).resolve().parent / "long_horizon_plan.json"

def create(goal):
    plan = {
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "goal": goal,
        "phases": [
            "system scan",
            "semantic graph build",
            "owner resolution",
            "dependency mapping",
            "patch planning",
            "safe apply",
            "browser verification",
            "visual diff",
            "memory update"
        ],
        "status": "ACTIVE"
    }
    PLAN_FILE.write_text(json.dumps(plan, indent=2))
    return plan

if __name__ == "__main__":
    import sys
    print(json.dumps(create(" ".join(sys.argv[1:])), indent=2))
