from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json

TARGET_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "08_target_membership_state.json"
)

TRAVERSAL_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "09_runtime_packaging_traversal_state.json"
)

DERIVED_DATA = (
    Path.home()
    / "Library"
    / "Developer"
    / "Xcode"
    / "DerivedData"
)

SUSPICIOUS_PATTERNS = [
    ".venv",
    "site-packages",
    "wheel.py",
    "pip",
    "setuptools",
    "dist-info",
    "PythonRuntime"
]

def load_json(path: Path, fallback):
    if not path.exists():
        return fallback

    try:
        return json.loads(path.read_text())
    except Exception:
        return fallback

def save_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2))

class RuntimePackagingTraversalInspector:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def latest_state(self):
        return load_json(TARGET_STATE, {})

    def locate_runtime_bundles(self):
        bundles = list(
            DERIVED_DATA.rglob("*.app")
        )

        bundles.sort(
            key=lambda p: p.stat().st_mtime,
            reverse=True
        )

        return bundles[:10]

    def inspect_bundle(self, bundle: Path):
        suspicious = []

        try:
            for path in bundle.rglob("*"):
                lowered = str(path).lower()

                matched = [
                    pattern for pattern in SUSPICIOUS_PATTERNS
                    if pattern.lower() in lowered
                ]

                if matched:
                    suspicious.append({
                        "path": str(path),
                        "matched_patterns": matched,
                        "is_directory": path.is_dir(),
                        "size_bytes": (
                            path.stat().st_size
                            if path.exists() and path.is_file()
                            else None
                        )
                    })

        except Exception as error:
            return {
                "bundle": str(bundle),
                "inspection_failed": True,
                "error": str(error)
            }

        return {
            "bundle": str(bundle),
            "inspection_failed": False,
            "suspicious_resource_count": len(suspicious),
            "suspicious_resources": suspicious[:200]
        }

    def derive_root_cause(self, inspections):
        for inspection in inspections:
            resources = inspection.get(
                "suspicious_resources",
                []
            )

            for resource in resources:
                path = resource.get("path", "").lower()

                if ".venv" in path:
                    return {
                        "root_cause": "Embedded Python virtual environment traversal into app bundle.",
                        "severity": "critical",
                        "repair_strategy": (
                            "Exclude PythonRuntime/.venv from runtime packaging and folder synchronization."
                        )
                    }

        return {
            "root_cause": "No runtime traversal contamination confirmed.",
            "severity": "unknown",
            "repair_strategy": "Increase packaging inspection depth."
        }

    def inspect(self):
        state = self.latest_state()

        bundles = self.locate_runtime_bundles()

        inspections = [
            self.inspect_bundle(bundle)
            for bundle in bundles
        ]

        contaminated = [
            item for item in inspections
            if item.get("suspicious_resource_count", 0) > 0
        ]

        root_cause = self.derive_root_cause(
            contaminated
        )

        report = {
            "status": "RUNTIME_PACKAGING_TRAVERSAL_INSPECTION_COMPLETE",
            "executed_at": self.executed_at,
            "derived_data_root": str(DERIVED_DATA),
            "bundle_count": len(bundles),
            "contaminated_bundle_count": len(contaminated),
            "bundle_inspections": contaminated[:20],
            "runtime_contamination_confirmed": len(contaminated) > 0,
            "root_cause_analysis": root_cause,
            "institutional_observation": (
                "ICOS inspected live app bundle traversal and runtime packaging contamination."
            ),
            "recommended_next_action": (
                "Generate autonomous runtime packaging exclusion engine for PythonRuntime virtual environments."
            ),
            "next_required_layer": "runtime_packaging_exclusion_engine"
        }

        save_json(TRAVERSAL_STATE, report)

        return report

INSPECTOR = RuntimePackagingTraversalInspector()

if __name__ == "__main__":
    print(json.dumps(
        INSPECTOR.inspect(),
        indent=2
    ))