from pathlib import Path
from datetime import datetime
import json

LEDGER = Path(__file__).resolve().parent / "task_continuity_ledger.json"
GRAPH = Path(__file__).resolve().parent / "constitutional_memory_graph.json"

PRIORITY_WEIGHTS = {
    "critical": 5,
    "high": 4,
    "medium": 3,
    "low": 2,
    "background": 1
}

STRATEGIC_SIGNALS = {
    "governance": [
        "policy",
        "authority",
        "constitutional",
        "routing"
    ],
    "infrastructure": [
        "runtime",
        "memory",
        "graph",
        "verification",
        "playwright"
    ],
    "product": [
        "icos",
        "product",
        "platform",
        "cognition"
    ],
    "risk": [
        "duplicate",
        "failure",
        "unsafe",
        "missing"
    ]
}

def load_json(path, fallback):
    if not path.exists():
        return fallback

    try:
        return json.loads(path.read_text())
    except Exception:
        return fallback

def classify_task(task):
    combined = f"{task.get('title', '')} {task.get('project', '')}".lower()

    matches = {}

    for domain, keywords in STRATEGIC_SIGNALS.items():
        matches[domain] = sum(
            combined.count(keyword)
            for keyword in keywords
        )

    return max(matches, key=matches.get)

def evaluate_priority(task):
    priority = task.get("priority", "medium")

    return PRIORITY_WEIGHTS.get(priority, 3)

def strategic_risk_analysis(tasks):
    risks = []

    for task in tasks:
        combined = f"{task.get('title', '')} {task.get('project', '')}".lower()

        if "duplicate" in combined:
            risks.append({
                "risk": "Institutional identity collision",
                "task": task.get("title")
            })

        if "memory" in combined:
            risks.append({
                "risk": "Persistent cognition dependency",
                "task": task.get("title")
            })

        if "runtime" in combined:
            risks.append({
                "risk": "Execution-layer instability",
                "task": task.get("title")
            })

    return risks

def generate_recommendations(tasks):
    recommendations = []

    if any("memory" in t.get("title", "").lower() for t in tasks):
        recommendations.append(
            "Prioritize persistent constitutional memory before expanding multi-agent cognition."
        )

    if any("duplicate" in t.get("title", "").lower() for t in tasks):
        recommendations.append(
            "Resolve document identity governance before autonomous document generation."
        )

    if len(tasks) > 5:
        recommendations.append(
            "Introduce dependency-aware scheduling before scaling execution breadth."
        )

    return recommendations

def strategic_analysis():
    ledger = load_json(LEDGER, {
        "active_tasks": [],
        "completed_tasks": []
    })

    graph = load_json(GRAPH, {
        "nodes": [],
        "edges": []
    })

    active_tasks = ledger.get("active_tasks", [])

    classified = [
        {
            "task_id": task.get("task_id"),
            "title": task.get("title"),
            "project": task.get("project"),
            "classification": classify_task(task),
            "priority_score": evaluate_priority(task)
        }
        for task in active_tasks
    ]

    highest_priority = sorted(
        classified,
        key=lambda x: x["priority_score"],
        reverse=True
    )[:5]

    return {
        "status": "STRATEGIC_ANALYSIS_COMPLETE",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "institutional_graph_nodes": len(graph.get("nodes", [])),
        "institutional_graph_edges": len(graph.get("edges", [])),
        "active_task_count": len(active_tasks),
        "highest_priority_tasks": highest_priority,
        "strategic_risks": strategic_risk_analysis(active_tasks),
        "recommendations": generate_recommendations(active_tasks),
        "current_maturity_estimate": "61/100",
        "next_strategic_focus": [
            "Persistent constitutional memory engine",
            "Dependency-aware runtime planner",
            "Autonomous correction recursion",
            "Multi-agent cognition mesh"
        ]
    }

if __name__ == "__main__":
    print(json.dumps(
        strategic_analysis(),
        indent=2
    ))