from __future__ import annotations

from pathlib import Path
from datetime import datetime
from collections import defaultdict
from typing import Dict, List, Set, Any
import ast
import json

RUNTIME_ROOT = Path(
    "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime"
)

TARGET_MAP_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "07_runtime_sovereign_target_map.json"
)

OUTPUT_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "08_runtime_dependency_graph_output.json"
)

SAFE_MOVE_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "09_runtime_safe_move_candidates.json"
)


class RuntimeDependencyGraph:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def load_target_map(self):
        if not TARGET_MAP_PATH.exists():
            raise FileNotFoundError(
                f"Missing target map: {TARGET_MAP_PATH}"
            )

        loaded = json.loads(
            TARGET_MAP_PATH.read_text()
        )

        return loaded.get("targets", {})

    def discover_python_files(self):
        return sorted(
            RUNTIME_ROOT.rglob("*.py")
        )

    def module_name(self, path: Path):
        relative = path.relative_to(RUNTIME_ROOT)

        return str(relative).replace("/", ".").replace(".py", "")

    def extract_imports(self, path: Path):
        imports = set()

        try:
            source = path.read_text(errors="ignore")
            tree = ast.parse(source)

            for node in ast.walk(tree):
                if isinstance(node, ast.Import):
                    for alias in node.names:
                        imports.add(alias.name)

                elif isinstance(node, ast.ImportFrom):
                    if node.module:
                        imports.add(node.module)

        except Exception:
            return []

        return sorted(imports)

    def build_dependency_graph(self):
        graph = {}

        files = self.discover_python_files()

        for file in files:
            module = self.module_name(file)
            imports = self.extract_imports(file)

            graph[module] = {
                "path": str(file),
                "imports": imports,
                "import_count": len(imports)
            }

        return graph

    def reverse_dependencies(self, graph):
        reverse = defaultdict(set)

        for module, data in graph.items():
            for imported in data["imports"]:
                reverse[imported].add(module)

        return {
            key: sorted(value)
            for key, value in reverse.items()
        }

    def classify_move_safety(self, graph, reverse_graph):
        candidates = {
            "safe": [],
            "moderate": [],
            "critical": []
        }

        for module, data in graph.items():
            inbound = len(
                reverse_graph.get(module, [])
            )

            outbound = data["import_count"]

            item = {
                "module": module,
                "path": data["path"],
                "inbound_dependencies": inbound,
                "outbound_dependencies": outbound
            }

            if inbound == 0 and outbound <= 2:
                candidates["safe"].append(item)

            elif inbound <= 5:
                candidates["moderate"].append(item)

            else:
                candidates["critical"].append(item)

        return candidates

    def execute(self):
        target_map = self.load_target_map()

        graph = self.build_dependency_graph()

        reverse_graph = self.reverse_dependencies(graph)

        safety = self.classify_move_safety(
            graph,
            reverse_graph
        )

        report = {
            "status": "RUNTIME_DEPENDENCY_GRAPH_COMPLETE",
            "executed_at": self.executed_at,
            "runtime_root": str(RUNTIME_ROOT),
            "python_module_count": len(graph),
            "dependency_graph": graph,
            "reverse_dependency_graph": reverse_graph,
            "sovereign_target_count": len(target_map),
            "safe_move_candidates": len(safety["safe"]),
            "moderate_move_candidates": len(safety["moderate"]),
            "critical_modules": len(safety["critical"])
        }

        OUTPUT_PATH.write_text(
            json.dumps(report, indent=2)
        )

        SAFE_MOVE_PATH.write_text(
            json.dumps({
                "status": "RUNTIME_MOVE_SAFETY_CLASSIFICATION_COMPLETE",
                "executed_at": self.executed_at,
                "candidates": safety
            }, indent=2)
        )

        return report


GRAPH = RuntimeDependencyGraph()


if __name__ == "__main__":
    result = GRAPH.execute()

    print(json.dumps({
        "status": result["status"],
        "python_module_count": result[
            "python_module_count"
        ],
        "safe_move_candidates": result[
            "safe_move_candidates"
        ],
        "moderate_move_candidates": result[
            "moderate_move_candidates"
        ],
        "critical_modules": result[
            "critical_modules"
        ]
    }, indent=2))