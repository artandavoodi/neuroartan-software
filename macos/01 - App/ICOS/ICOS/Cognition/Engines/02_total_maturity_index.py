from pathlib import Path
from datetime import datetime
import json

ROOT = Path(__file__).resolve().parent

SYSTEM_FILES = {
    "authority_routing": ROOT / "14_authority_routing_engine.py",
    "lifecycle": ROOT / "15_lifecycle_state_engine.py",
    "document_creation": ROOT / "16_document_creation_protocol.py",
    "governance_escalation": ROOT / "17_governance_escalation_engine.py",
    "agent_bridge": ROOT / "18_agent_registry_bridge.py",
    "continuity": ROOT / "19_task_continuity_ledger.py",
    "scheduler": ROOT / "20_dependency_resource_scheduler.py",
    "strategic": ROOT / "21_strategic_analysis_engine.py",
    "self_development": ROOT / "22_self_development_engine.py",
    "memory": ROOT / "08_persistent_constitutional_memory_engine.py",
    "document_id_governance": ROOT / "12_document_id_governance.py"
}

ADVANCED_ROOT = ROOT.parent / "advanced"

ADVANCED_FILES = {
    "failure_learning": ADVANCED_ROOT / "09_failure_learning.py"
}

MATURITY_WEIGHTS = {
    "authority_routing": 8,
    "lifecycle": 7,
    "document_creation": 10,
    "governance_escalation": 8,
    "agent_bridge": 10,
    "continuity": 9,
    "scheduler": 10,
    "strategic": 10,
    "self_development": 10,
    "memory": 12,
    "document_id_governance": 6,
    "failure_learning": 10
}

THRESHOLDS = {
    10: "Prototype Runtime",
    25: "Structured Assistant",
    40: "Governed Runtime",
    55: "Institutional Cognition",
    70: "Persistent Sovereign Runtime",
    85: "Autonomous Institutional Cognition",
    100: "Sovereign Cognitive Operating System"
}



def file_operational(path):
    return path.exists() and path.stat().st_size > 0



def calculate_score():
    score = 0
    operational = {}

    combined = {
        **SYSTEM_FILES,
        **ADVANCED_FILES
    }

    for key, path in combined.items():
        active = file_operational(path)

        operational[key] = {
            "active": active,
            "path": str(path)
        }

        if active:
            score += MATURITY_WEIGHTS.get(key, 0)

    return score, operational



def maturity_label(score):
    current = "Uninitialized"

    for threshold, label in sorted(THRESHOLDS.items()):
        if score >= threshold:
            current = label

    return current



def missing_layers(operational):
    return [
        key for key, value in operational.items()
        if not value["active"]
    ]



def generate_report():
    score, operational = calculate_score()

    maturity = min(score, 100)

    report = {
        "status": "TOTAL_MATURITY_INDEX_GENERATED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "maturity_score": f"{maturity}/100",
        "maturity_label": maturity_label(maturity),
        "operational_systems": operational,
        "missing_layers": missing_layers(operational),
        "institutional_capabilities": {
            "authority_reasoning": operational["authority_routing"]["active"],
            "persistent_memory": operational["memory"]["active"],
            "strategic_cognition": operational["strategic"]["active"],
            "adaptive_learning": operational["failure_learning"]["active"],
            "multi_agent_cognition": operational["agent_bridge"]["active"],
            "autonomous_execution": operational["scheduler"]["active"],
            "constitutional_governance": operational["governance_escalation"]["active"]
        },
        "next_evolution_targets": [
            "Browser/runtime verification recursion",
            "Autonomous execution loops",
            "Continuous self-optimization",
            "Semantic graph evolution",
            "Live runtime adaptation"
        ]
    }

    return report


if __name__ == "__main__":
    print(json.dumps(
        generate_report(),
        indent=2
    ))