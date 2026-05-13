from __future__ import annotations

from pathlib import Path
from datetime import datetime
from collections import defaultdict
from typing import Dict, List, Any
import json

RUNTIME_ROOT = Path(
    "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime"
)

INVENTORY_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "02_runtime_file_inventory.json"
)

OUTPUT_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "06_runtime_migration_recommendations.json"
)

TARGET_MAP_PATH = (
    RUNTIME_ROOT
    / "migration"
    / "07_runtime_sovereign_target_map.json"
)

CLASSIFICATION_RULES = {
    "Core": [
        "registry",
        "router",
        "core",
        "runtime_engine",
        "execution"
    ],
    "Memory": [
        "memory",
        "state",
        "cache",
        "context",
        "retrieval"
    ],
    "Governance": [
        "governance",
        "policy",
        "verification",
        "audit",
        "compliance"
    ],
    "Providers": [
        "provider",
        "openai",
        "anthropic",
        "ollama",
        "api"
    ],
    "Models": [
        "model",
        "gguf",
        "llama",
        "lmstudio"
    ],
    "Interfaces": [
        "continue",
        "mcp",
        "cli",
        "interface",
        "bridge"
    ],
    "Planning": [
        "planner",
        "planning",
        "schedule",
        "dependency"
    ],
    "Learning": [
        "learning",
        "adapt",
        "feedback",
        "optimization"
    ],
    "Verification": [
        "verifier",
        "verification",
        "validator",
        "inspector"
    ],
    "Adapters": [
        "adapter",
        "xcode",
        "swift",
        "build"
    ],
    "Experimental": [
        "experimental",
        "prototype",
        "sandbox",
        "temp"
    ]
}

SOVEREIGN_TARGETS = {
    "Core": "Runtime/Core",
    "Memory": "Runtime/memory",
    "Governance": "Runtime/Governance",
    "Providers": "Runtime/Providers",
    "Models": "Runtime/models",
    "Interfaces": "Runtime/interfaces",
    "Planning": "Runtime/planning",
    "Learning": "Runtime/learning",
    "Verification": "Runtime/verification",
    "Adapters": "Runtime/adapters",
    "Experimental": "Runtime/experimental"
}

class RuntimeSemanticClassifier:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def load_inventory(self):
        if not INVENTORY_PATH.exists():
            raise FileNotFoundError(
                f"Missing inventory: {INVENTORY_PATH}"
            )

        return json.loads(INVENTORY_PATH.read_text())

    def classify_file(self, relative_path: str):
        lowered = relative_path.lower()

        matches = []

        for classification, rules in CLASSIFICATION_RULES.items():
            for rule in rules:
                if rule in lowered:
                    matches.append(classification)
                    break

        if not matches:
            return "Unclassified"

        return matches[0]

    def build_target_path(self, classification: str):
        return SOVEREIGN_TARGETS.get(
            classification,
            "Runtime/legacy"
        )

    def generate_recommendation(
        self,
        file_record,
        classification
    ):
        relative_path = file_record["relative_path"]

        return {
            "source": relative_path,
            "classification": classification,
            "recommended_target": self.build_target_path(classification),
            "safe_to_move": False,
            "migration_phase": "semantic_review_required"
        }

    def execute(self):
        inventory = self.load_inventory()

        classified = []

        grouped = defaultdict(list)

        sovereign_map = {}

        for file_record in inventory:
            relative_path = file_record["relative_path"]

            classification = self.classify_file(
                relative_path
            )

            recommendation = self.generate_recommendation(
                file_record,
                classification
            )

            classified.append(recommendation)

            grouped[classification].append(relative_path)

            sovereign_map[relative_path] = {
                "classification": classification,
                "target": recommendation[
                    "recommended_target"
                ]
            }

        recommendations = {
            "status": "RUNTIME_SEMANTIC_CLASSIFICATION_COMPLETE",
            "executed_at": self.executed_at,
            "runtime_root": str(RUNTIME_ROOT),
            "classified_file_count": len(classified),
            "classification_summary": {
                key: len(value)
                for key, value in grouped.items()
            },
            "recommendations": classified
        }

        INVENTORY_PATH.parent.mkdir(
            parents=True,
            exist_ok=True
        )

        OUTPUT_PATH.write_text(
            json.dumps(recommendations, indent=2)
        )

        TARGET_MAP_PATH.write_text(
            json.dumps({
                "status": "SOVEREIGN_TARGET_MAP_GENERATED",
                "executed_at": self.executed_at,
                "targets": sovereign_map
            }, indent=2)
        )

        return recommendations

CLASSIFIER = RuntimeSemanticClassifier()

if __name__ == "__main__":
    result = CLASSIFIER.execute()

    print(json.dumps({
        "status": result["status"],
        "classified_file_count": result[
            "classified_file_count"
        ],
        "classification_summary": result[
            "classification_summary"
        ]
    }, indent=2))