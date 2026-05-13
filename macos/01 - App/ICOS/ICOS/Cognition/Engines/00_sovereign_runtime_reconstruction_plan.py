from __future__ import annotations

from pathlib import Path
from datetime import datetime
from collections import defaultdict
from typing import Dict, List, Any
import json

RUNTIME_ROOT = Path(
    "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime"
)

DEPENDENCY_GRAPH_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "08_runtime_dependency_graph_output.json"
)

SAFE_MOVE_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "09_runtime_safe_move_candidates.json"
)

TARGET_MAP_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "07_runtime_sovereign_target_map.json"
)

OUTPUT_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "10_sovereign_runtime_reconstruction_plan_output.json"
)

PHASES = [
    "foundation_extraction",
    "interface_detachment",
    "provider_normalization",
    "memory_sovereignization",
    "governance_extraction",
    "adapter_consolidation",
    "model_runtime_normalization",
    "legacy_quarantine",
    "runtime_relinking",
    "verification_and_boot_validation"
]

class SovereignRuntimeReconstructionPlanner:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def load_json(self, path: Path, fallback):
        if not path.exists():
            return fallback

        try:
            return json.loads(path.read_text())
        except Exception:
            return fallback

    def load_dependency_graph(self):
        return self.load_json(
            DEPENDENCY_GRAPH_PATH,
            {}
        )

    def load_safe_moves(self):
        return self.load_json(
            SAFE_MOVE_PATH,
            {}
        )

    def load_target_map(self):
        return self.load_json(
            TARGET_MAP_PATH,
            {}
        )

    def identify_continuebridge_modules(self, graph):
        modules = []

        dependency_graph = graph.get(
            "dependency_graph",
            {}
        )

        for module, data in dependency_graph.items():
            path = data.get("path", "")

            if "continuebridge" in path.lower():
                modules.append({
                    "module": module,
                    "path": path,
                    "import_count": data.get(
                        "import_count",
                        0
                    )
                })

        return modules

    def classify_reconstruction_phase(self, path: str):
        lowered = path.lower()

        if "memory" in lowered:
            return "memory_sovereignization"

        if "provider" in lowered:
            return "provider_normalization"

        if "governance" in lowered:
            return "governance_extraction"

        if "adapter" in lowered or "xcode" in lowered:
            return "adapter_consolidation"

        if "model" in lowered or "llama" in lowered:
            return "model_runtime_normalization"

        if "continuebridge" in lowered:
            return "interface_detachment"

        return "foundation_extraction"

    def build_phase_groups(self, safe_moves):
        grouped = defaultdict(list)

        candidates = safe_moves.get(
            "candidates",
            {}
        )

        for level in [
            "safe",
            "moderate",
            "critical"
        ]:
            for item in candidates.get(level, []):
                phase = self.classify_reconstruction_phase(
                    item["path"]
                )

                grouped[phase].append({
                    **item,
                    "safety_level": level
                })

        return grouped

    def build_execution_plan(self, grouped):
        execution = []

        for phase in PHASES:
            items = grouped.get(phase, [])

            execution.append({
                "phase": phase,
                "module_count": len(items),
                "safe_candidates": len([
                    x for x in items
                    if x["safety_level"] == "safe"
                ]),
                "moderate_candidates": len([
                    x for x in items
                    if x["safety_level"] == "moderate"
                ]),
                "critical_candidates": len([
                    x for x in items
                    if x["safety_level"] == "critical"
                ]),
                "autonomous_execution_allowed": False,
                "requires_runtime_validation": True
            })

        return execution

    def execute(self):
        graph = self.load_dependency_graph()
        safe_moves = self.load_safe_moves()
        target_map = self.load_target_map()

        continuebridge_modules = (
            self.identify_continuebridge_modules(graph)
        )

        grouped = self.build_phase_groups(
            safe_moves
        )

        execution_plan = self.build_execution_plan(
            grouped
        )

        report = {
            "status": "SOVEREIGN_RUNTIME_RECONSTRUCTION_PLAN_COMPLETE",
            "executed_at": self.executed_at,
            "runtime_root": str(RUNTIME_ROOT),
            "continuebridge_module_count": len(
                continuebridge_modules
            ),
            "phase_count": len(PHASES),
            "execution_plan": execution_plan,
            "continuebridge_modules": continuebridge_modules[:200],
            "architectural_conclusion": (
                "ContinueBridge evolved into the accidental runtime core and must be reduced into a thin interface layer."
            ),
            "target_architecture": {
                "Core": "Runtime/Core",
                "Interfaces": "Runtime/interfaces",
                "Models": "Runtime/models",
                "Providers": "Runtime/Providers",
                "Memory": "Runtime/memory",
                "Governance": "Runtime/Governance",
                "Adapters": "Runtime/adapters"
            },
            "migration_constraints": [
                "Do not delete achieved cognition.",
                "Do not mutate imports before dependency remapping.",
                "Do not move high-dependency modules first.",
                "Always preserve runtime bootability.",
                "Quarantine legacy topology before removal."
            ],
            "next_required_layer": (
                "autonomous_runtime_relinking_engine"
            )
        }

        OUTPUT_PATH.write_text(
            json.dumps(report, indent=2)
        )

        return report

PLANNER = SovereignRuntimeReconstructionPlanner()

if __name__ == "__main__":
    result = PLANNER.execute()

    print(json.dumps({
        "status": result["status"],
        "continuebridge_module_count": result[
            "continuebridge_module_count"
        ],
        "phase_count": result[
            "phase_count"
        ]
    }, indent=2))