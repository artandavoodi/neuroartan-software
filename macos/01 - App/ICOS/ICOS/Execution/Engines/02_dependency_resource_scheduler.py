from pathlib import Path
from datetime import datetime
import json

LEDGER = Path(__file__).resolve().parent / "task_continuity_ledger.json"
SCHEDULE = Path(__file__).resolve().parent / "dependency_schedule_state.json"

RESOURCE_LIMITS = {
    "execution_slots": 5,
    "high_priority_slots": 2,
    "parallel_projects": 3
}

PRIORITY_WEIGHTS = {
    "critical": 5,
    "high": 4,
    "medium": 3,
    "low": 2,
    "background": 1
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

def normalize_priority(priority):
    return PRIORITY_WEIGHTS.get(priority, 3)

def dependencies_satisfied(task, completed_ids):
    deps = task.get("dependencies", [])

    return all(dep in completed_ids for dep in deps)

def classify_blockers(tasks, completed_ids):
    blocked = []

    for task in tasks:
        if not dependencies_satisfied(task, completed_ids):
            blocked.append({
                "task_id": task.get("task_id"),
                "title": task.get("title"),
                "missing_dependencies": [
                    dep for dep in task.get("dependencies", [])
                    if dep not in completed_ids
                ]
            })

    return blocked

def build_execution_queue(tasks, completed_ids):
    executable = [
        task for task in tasks
        if dependencies_satisfied(task, completed_ids)
    ]

    executable.sort(
        key=lambda t: normalize_priority(
            t.get("priority", "medium")
        ),
        reverse=True
    )

    return executable[:RESOURCE_LIMITS["execution_slots"]]

def project_distribution(tasks):
    distribution = {}

    for task in tasks:
        project = task.get("project", "unknown")

        distribution[project] = distribution.get(project, 0) + 1

    return distribution

def generate_schedule():
    ledger = load_json(LEDGER, {
        "active_tasks": [],
        "completed_tasks": []
    })

    active_tasks = ledger.get("active_tasks", [])

    completed_ids = {
        task.get("task_id")
        for task in ledger.get("completed_tasks", [])
    }

    execution_queue = build_execution_queue(
        active_tasks,
        completed_ids
    )

    blockers = classify_blockers(
        active_tasks,
        completed_ids
    )

    state = {
        "status": "DEPENDENCY_RESOURCE_SCHEDULE_GENERATED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "active_task_count": len(active_tasks),
        "completed_task_count": len(completed_ids),
        "execution_queue": execution_queue,
        "blocked_tasks": blockers,
        "resource_limits": RESOURCE_LIMITS,
        "project_distribution": project_distribution(active_tasks),
        "recommended_next_execution": [
            task.get("title")
            for task in execution_queue[:3]
        ],
        "scheduler_state": {
            "parallel_capacity_remaining": max(
                RESOURCE_LIMITS["parallel_projects"] - len(project_distribution(active_tasks)),
                0
            ),
            "high_priority_utilization": len([
                t for t in execution_queue
                if normalize_priority(t.get("priority")) >= 4
            ])
        }
    }

    save_json(SCHEDULE, state)

    return state

if __name__ == "__main__":
    print(json.dumps(
        generate_schedule(),
        indent=2
    ))