import sys
from pathlib import Path

RUNTIME = Path(__file__).parent
sys.path.append(str(RUNTIME))

import scanner
import verifier
import resolver
import ranker
import memory_manager
import editor
import owner_chain
import dependency_graph
import patch_planner
sys.path.append(str(RUNTIME / "advanced"))
sys.path.append(str(RUNTIME / "quality"))
sys.path.append(str(RUNTIME / "icos_intelligence"))
sys.path.append(str(RUNTIME / "intelligence"))

import repository_semantic_memory_graph
import language_server_intelligence
import browser_runtime_verifier
import autonomous_visual_diff
import repository_reasoning_memory
import execution_policy_intelligence
import streaming_execution_engine
import long_horizon_engine

def inject_memory():
    memory = memory_manager.load_memory()
    print("\n=== MEMORY ===")
    for m in memory[-5:]:
        print("-", m["memory"])

def inject_execution_policy():
    print("\n=== EXECUTION POLICY ===")

    policy = execution_policy_intelligence.decide(
        "code_edit",
        95
    )

    print(policy)


def inject_streaming_pipeline():
    print("\n=== STREAM PIPELINE ===")

    streaming_execution_engine.stream_pipeline([
        "SCAN",
        "SEMANTIC_GRAPH",
        "OWNER_CHAIN",
        "PATCH_PLAN",
        "RUNTIME_VERIFY",
        "VISUAL_DIFF",
        "MEMORY_UPDATE"
    ])


def inject_long_horizon_plan():
    print("\n=== LONG HORIZON PLAN ===")

    plan = long_horizon_engine.create(
        "ICOS unified execution brain"
    )

    print(plan["goal"])
    print(plan["status"])


def inject_semantic_repository_graph():
    print("\n=== SEMANTIC GRAPH ===")

    graph_path = repository_semantic_memory_graph.build_graph()

    print(graph_path)


def inject_language_intelligence():
    print("\n=== LANGUAGE INTELLIGENCE ===")

    intelligence = language_server_intelligence.inspect_project()

    print("Files:", intelligence["file_count"])
    print("Symbols:", intelligence["symbol_count"])


def inject_runtime_verification():
    print("\n=== RUNTIME VERIFICATION ===")

    runtime = browser_runtime_verifier.verify_runtime()

    print(runtime["server"]["status"])

    playwright = runtime.get("playwright")

    if playwright:
        print(playwright["status"])


def inject_visual_diff():
    print("\n=== VISUAL DIFF ===")

    result = autonomous_visual_diff.visual_diff()

    print(result["status"])


def inject_reasoning_memory(event_type, payload):
    print("\n=== REASONING MEMORY ===")

    event = repository_reasoning_memory.record(
        event_type,
        payload
    )

    print(event["event_type"])

def run():
    inject_memory()
    inject_execution_policy()
    inject_streaming_pipeline()
    inject_long_horizon_plan()
    inject_semantic_repository_graph()
    inject_language_intelligence()
    inject_runtime_verification()
    inject_visual_diff()

    print("\n=== SCAN ===")
    data = scanner.scan()
    print("Folders:", len(data["folders"]))
    print("Files:", len(data["files"]))

    print("\n=== RESOLVE ===")
    candidates = verifier.filter_existing(resolver.resolve())

    print("\n=== RANK ===")
    ranked = ranker.rank(candidates)
    for c in ranked[:20]:
        print(c)

    if ranked:
        primary = ranked[0]
        print("\n=== PRIMARY OWNER ===")
        print(primary)

        print("\n=== OWNER CHAIN ===")
        chain = owner_chain.resolve_owner_chain(primary)
        print("PRIMARY:")
        print(chain["primary"])
        print("\nADJACENT:")
        for item in chain["adjacent"]:
            print(item)
        print("\nIMPORTS:")
        for item in chain["imports"]:
            print(item)

        print("\n=== DEPENDENCY GRAPH ===")
        graph = dependency_graph.build_graph(primary)
        for k, deps in graph.items():
            print(k)
            for d in deps:
                print("  ->", d)

        print("\n=== FILE PREVIEW ===")
        preview = editor.read_file(primary)
        print(preview[:2000])

        print("\n=== PATCH PLAN ===")
        plan = patch_planner.plan_patch(primary, "homepage navigation alignment")
        print(plan["status"])
        print(plan["file"])

        inject_reasoning_memory(
            "execution_run",
            {
                "primary": primary,
                "patch_status": plan["status"]
            }
        )

    print("\n=== DONE ===")

if __name__ == "__main__":
    run()
