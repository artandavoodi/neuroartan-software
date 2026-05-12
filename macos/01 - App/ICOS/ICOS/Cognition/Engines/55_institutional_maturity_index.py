import json
from pathlib import Path

BASE = Path(__file__).resolve().parent

def score():
    checks = {
        "constitutional_memory_graph": (BASE / "constitutional_memory_graph.json").exists(),
        "document_cognition_engine": (BASE / "02_document_cognition_engine.py").exists(),
        "document_id_resolver": (BASE / "03_document_id_resolver.py").exists(),
        "placement_resolver": (BASE / "04_placement_resolver.py").exists(),
        "doctrine_retrieval_engine": (BASE / "05_doctrine_retrieval_engine.py").exists(),
        "institutional_task_planner": (BASE / "06_institutional_task_planner.py").exists()
    }

    value = round(sum(checks.values()) / len(checks) * 100)

    return {
        "status": "INSTITUTIONAL_MATURITY_INDEX",
        "score": value,
        "checks": checks
    }

if __name__ == "__main__":
    print(json.dumps(score(), indent=2))
