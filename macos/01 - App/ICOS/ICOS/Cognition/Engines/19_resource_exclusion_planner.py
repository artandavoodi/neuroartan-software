from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json
import re

BUILD_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "02_xcode_build_state_store.py"
)

PLAN_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "04_resource_exclusion_plan_state.json"
)

EXCLUSION_PATTERNS = [
    ".venv",
    "__pycache__",
    ".pytest_cache",
    "site-packages",
    "pip",
    "setuptools",
    "wheel",
    "dist-info",
    "egg-info"
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



def latest_build_failure():
    builds = load_json(BUILD_STATE, [])

    failures = [
        build for build in builds
        if build.get("success") is False
    ]

    if not failures:
        return None

    return failures[-1]



def extract_duplicate_resource_paths(output: str) -> List[str]:
    produced = re.findall(
        r"produce '([^']+)'",
        output
    )

    sources = re.findall(
        r"copy command from '([^']+)'",
        output
    )

    return sorted(set(produced + sources))



def classify_exclusions(paths: List[str]) -> List[Dict[str, Any]]:
    candidates = []

    for path in paths:
        lowered = path.lower()

        matched = [
            pattern for pattern in EXCLUSION_PATTERNS
            if pattern.lower() in lowered
        ]

        if matched:
            candidates.append({
                "path": path,
                "matched_patterns": matched,
                "recommended_action": "exclude_from_copy_bundle_resources",
                "risk": "safe_to_exclude_runtime_vendor_artifact"
            })

    return candidates



def generate_resource_exclusion_plan() -> Dict[str, Any]:
    failure = latest_build_failure()

    if not failure:
        return {
            "status": "NO_BUILD_FAILURE_AVAILABLE",
            "evaluated_at": datetime.now().isoformat(timespec="seconds")
        }

    output = failure.get("output_preview", "")

    duplicate_paths = extract_duplicate_resource_paths(output)

    exclusion_candidates = classify_exclusions(
        duplicate_paths
    )

    plan = {
        "status": "RESOURCE_EXCLUSION_PLAN_GENERATED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "project_path": failure.get("project_path"),
        "scheme": failure.get("scheme"),
        "classification": failure.get("classification"),
        "duplicate_resource_count": len(duplicate_paths),
        "exclusion_candidate_count": len(exclusion_candidates),
        "duplicate_resource_paths": duplicate_paths[:50],
        "exclusion_candidates": exclusion_candidates[:50],
        "recommended_fix_strategy": [
            "Do not edit source Swift files.",
            "Inspect Xcode Copy Bundle Resources phase.",
            "Remove .venv / Python vendor artifacts from app bundle resources.",
            "Keep PythonRuntime source available only through controlled runtime packaging.",
            "Rebuild after resource exclusions are applied."
        ],
        "autonomous_patch_allowed": False,
        "reason_autonomous_patch_blocked": (
            "Xcode project file mutation requires pbxproj-aware writer; direct text patching is unsafe."
        ),
        "next_required_layer": "pbxproj_resource_phase_editor"
    }

    save_json(PLAN_STATE, plan)

    return plan


if __name__ == "__main__":
    print(json.dumps(
        generate_resource_exclusion_plan(),
        indent=2
    ))
