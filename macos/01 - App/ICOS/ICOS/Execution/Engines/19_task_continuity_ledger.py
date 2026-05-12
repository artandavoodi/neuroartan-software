from pathlib import Path
from datetime import datetime
import json
import hashlib

LEDGER = Path(__file__).resolve().parent / "task_continuity_ledger.json"

DEFAULT_STATE = {
    "active_tasks": [],
    "completed_tasks": [],
    "projects": {},
    "sessions": [],
    "dependencies": {}
}



def load_ledger():
    if not LEDGER.exists():
        return DEFAULT_STATE.copy()

    try:
        return json.loads(LEDGER.read_text())
    except Exception:
        return DEFAULT_STATE.copy()



def save_ledger(data):
    LEDGER.write_text(json.dumps(data, indent=2))



def generate_task_id(title):
    digest = hashlib.sha1(title.encode()).hexdigest()[:8]

    return f"TASK-{datetime.now().year}-{digest.upper()}"



def create_task(
    title,
    project,
    priority="medium",
    dependencies=None,
    owner="ICOS"
):
    ledger = load_ledger()

    dependencies = dependencies or []

    task = {
        "task_id": generate_task_id(title),
        "title": title,
        "project": project,
        "priority": priority,
        "owner": owner,
        "dependencies": dependencies,
        "status": "active",
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "updated_at": datetime.now().isoformat(timespec="seconds")
    }

    ledger["active_tasks"].append(task)

    if project not in ledger["projects"]:
        ledger["projects"][project] = {
            "active_task_count": 0,
            "completed_task_count": 0,
            "last_updated": datetime.now().isoformat(timespec="seconds")
        }

    ledger["projects"][project]["active_task_count"] += 1
    ledger["projects"][project]["last_updated"] = datetime.now().isoformat(timespec="seconds")

    ledger["dependencies"][task["task_id"]] = dependencies

    save_ledger(ledger)

    return {
        "status": "TASK_CREATED",
        "task": task
    }



def complete_task(task_id):
    ledger = load_ledger()

    remaining = []
    completed_task = None

    for task in ledger["active_tasks"]:
        if task["task_id"] == task_id:
            task["status"] = "completed"
            task["completed_at"] = datetime.now().isoformat(timespec="seconds")
            completed_task = task
        else:
            remaining.append(task)

    ledger["active_tasks"] = remaining

    if completed_task:
        ledger["completed_tasks"].append(completed_task)

        project = completed_task["project"]

        if project in ledger["projects"]:
            ledger["projects"][project]["active_task_count"] -= 1
            ledger["projects"][project]["completed_task_count"] += 1
            ledger["projects"][project]["last_updated"] = datetime.now().isoformat(timespec="seconds")

    save_ledger(ledger)

    return {
        "status": "TASK_COMPLETION_RECORDED",
        "completed_task": completed_task
    }



def register_session(session_name, summary):
    ledger = load_ledger()

    session = {
        "session_name": session_name,
        "summary": summary,
        "recorded_at": datetime.now().isoformat(timespec="seconds")
    }

    ledger["sessions"].append(session)

    save_ledger(ledger)

    return {
        "status": "SESSION_REGISTERED",
        "session": session
    }



def continuity_report():
    ledger = load_ledger()

    return {
        "status": "TASK_CONTINUITY_REPORT",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "active_tasks": len(ledger["active_tasks"]),
        "completed_tasks": len(ledger["completed_tasks"]),
        "projects": ledger["projects"],
        "recent_sessions": ledger["sessions"][-5:],
        "dependency_graph_size": len(ledger["dependencies"])
    }


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print(json.dumps({
            "status": "INVALID_ARGUMENTS"
        }, indent=2))
        raise SystemExit(1)

    command = sys.argv[1]

    if command == "report":
        print(json.dumps(
            continuity_report(),
            indent=2
        ))

    elif command == "session":
        print(json.dumps(
            register_session(sys.argv[2], " ".join(sys.argv[3:])),
            indent=2
        ))

    elif command == "create":
        print(json.dumps(
            create_task(
                title=sys.argv[2],
                project=sys.argv[3]
            ),
            indent=2
        ))

    elif command == "complete":
        print(json.dumps(
            complete_task(sys.argv[2]),
            indent=2
        ))