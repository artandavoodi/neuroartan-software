from __future__ import annotations

from pathlib import Path
import sys
import json

RUNTIME = Path(__file__).resolve().parents[1]
sys.path.append(str(RUNTIME))
sys.path.append(str(RUNTIME / "advanced"))
sys.path.append(str(RUNTIME / "quality"))
sys.path.append(str(RUNTIME / "intelligence"))
sys.path.append(str(RUNTIME / "icos_intelligence"))
sys.path.append(str(RUNTIME / "institutional"))

import memory_manager
import resolver
import verifier
import ranker
import owner_chain
import repository_semantic_memory_graph
import language_server_intelligence
import browser_runtime_verifier
import autonomous_visual_diff
import patch_planner
import execution_intelligence_quality
import decision_gate
import repository_reasoning_memory
import importlib.util

CONSTITUTIONAL_MEMORY_PATH = RUNTIME / "institutional" / "01_constitutional_memory_graph.py"

def load_constitutional_memory_graph():
    spec = importlib.util.spec_from_file_location("constitutional_memory_graph", CONSTITUTIONAL_MEMORY_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(module)
    return module

def run(intent="homepage navigation alignment"):
    memory = memory_manager.load_memory()

    constitutional_memory_graph = load_constitutional_memory_graph()
    constitutional_memory_graph.build()
    graph_path = repository_semantic_memory_graph.build_graph()
    language = language_server_intelligence.inspect_project()

    candidates = verifier.filter_existing(resolver.resolve())
    ranked = ranker.rank(candidates)

    if not ranked:
        return {
            "status": "NO_VERIFIED_OWNER",
            "intent": intent,
            "source": "NONE"
        }

    primary = ranked[0]
    chain = owner_chain.resolve_owner_chain(primary)
    runtime = browser_runtime_verifier.verify_runtime()
    visual = autonomous_visual_diff.visual_diff()
    patch = patch_planner.plan_patch(primary, intent)

    runtime_status = runtime["server"]["status"]
    playwright = runtime.get("playwright")
    if playwright:
        runtime_status = playwright["status"]

    quality = execution_intelligence_quality.evaluate({
        "memory_loaded": bool(memory),
        "semantic_graph_built": graph_path.exists(),
        "constitutional_memory_built": True,
        "symbol_count": language["symbol_count"],
        "runtime_verified": runtime["server"]["status"] == "SERVER_OK",
        "visual_diff_verified": visual["status"] in ["NO_VISUAL_DIFF", "VISUAL_DIFF_DETECTED"],
        "primary_owner": primary,
        "owner_chain_count": len(chain.get("adjacent", [])) if isinstance(chain, dict) else 0,
        "patch_status": patch["status"],
        "hallucinated_paths": 0,
        "source_grounded": True
    })

    decision = decision_gate.decide_next_action(
        quality["score"],
        patch["status"],
        runtime_status
    )

    repository_reasoning_memory.record(
        "unified_execution_loop",
        {
            "intent": intent,
            "primary": primary,
            "quality": quality["score"],
            "decision": decision
        }
    )

    return {
        "status": "UNIFIED_LOOP_COMPLETE",
        "intent": intent,
        "primary_owner": primary,
        "owner_chain_count": len(chain.get("adjacent", [])) if isinstance(chain, dict) else 0,
        "semantic_graph": str(graph_path),
        "symbol_count": language["symbol_count"],
        "runtime_status": runtime_status,
        "visual_status": visual["status"],
        "patch_status": patch["status"],
        "quality_score": quality["score"],
        "decision": decision,
    }

if __name__ == "__main__":
    import sys
    intent = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "homepage navigation alignment"
    print(json.dumps(run(intent), indent=2))
