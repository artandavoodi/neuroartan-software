from pathlib import Path
import json
from datetime import datetime

QUALITY_FILE = Path(__file__).resolve().parent / "execution_intelligence_quality.json"

def evaluate(context):
    checks = {
        "memory_loaded": bool(context.get("memory_loaded")),
        "semantic_graph_built": bool(context.get("semantic_graph_built")),
        "language_symbols_indexed": context.get("symbol_count", 0) > 0,
        "runtime_verified": context.get("runtime_verified") is True,
        "visual_diff_verified": context.get("visual_diff_verified") is True,
        "primary_owner_verified": bool(context.get("primary_owner")),
        "owner_chain_present": context.get("owner_chain_count", 0) > 0,
        "patch_plan_ready": context.get("patch_status") == "PATCH_PLAN_READY",
        "no_hallucinated_paths": context.get("hallucinated_paths", 0) == 0,
        "source_grounded": context.get("source_grounded") is True,
    }

    score = round((sum(1 for value in checks.values() if value) / len(checks)) * 100)

    result = {
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "status": "QUALITY_EVALUATED",
        "score": score,
        "checks": checks,
        "context": context,
    }

    QUALITY_FILE.write_text(json.dumps(result, indent=2))
    return result

if __name__ == "__main__":
    sample = {
        "memory_loaded": True,
        "semantic_graph_built": True,
        "symbol_count": 28541,
        "runtime_verified": True,
        "visual_diff_verified": True,
        "primary_owner": "/verified/file.css",
        "owner_chain_count": 7,
        "patch_status": "PATCH_PLAN_READY",
        "hallucinated_paths": 0,
        "source_grounded": True
    }

    print(json.dumps(evaluate(sample), indent=2))
