from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json
import re

INSPECTION_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "07_build_phase_inspection_state.json"
)

TARGET_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "08_target_membership_state.json"
)

SUSPICIOUS_PATTERNS = [
    ".venv",
    "site-packages",
    "wheel.py",
    "pip",
    "setuptools",
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

class XcodeTargetMembershipInspector:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def latest_state(self):
        return load_json(INSPECTION_STATE, {})

    def load_pbxproj(self, pbxproj_path: str):
        path = Path(pbxproj_path)

        if not path.exists():
            raise FileNotFoundError(
                f"Missing pbxproj: {path}"
            )

        return path.read_text(errors="ignore")

    def extract_suspicious_references(self, content: str):
        findings = []

        lines = content.splitlines()

        for index, line in enumerate(lines):
            lowered = line.lower()

            matched = [
                pattern for pattern in SUSPICIOUS_PATTERNS
                if pattern.lower() in lowered
            ]

            if matched:
                findings.append({
                    "line_number": index + 1,
                    "matched_patterns": matched,
                    "line": line.strip()
                })

        return findings

    def classify_reference_type(self, line: str):
        lowered = line.lower()

        if "pbxgroup" in lowered:
            return "group_reference"

        if "pbxbuildfile" in lowered:
            return "build_membership"

        if "pbxfilereference" in lowered:
            return "file_reference"

        if "folder" in lowered:
            return "folder_reference"

        return "unknown"

    def derive_risk(self, line: str):
        lowered = line.lower()

        if ".venv" in lowered:
            return "critical_recursive_runtime_ingestion"

        if "site-packages" in lowered:
            return "python_vendor_resource_ingestion"

        if "pythonruntime" in lowered:
            return "runtime_root_recursive_reference"

        return "moderate"

    def inspect(self):
        state = self.latest_state()

        pbxproj_path = state.get("pbxproj_path")

        if not pbxproj_path:
            return {
                "status": "NO_PBXPROJ_AVAILABLE",
                "executed_at": self.executed_at
            }

        content = self.load_pbxproj(pbxproj_path)

        suspicious = self.extract_suspicious_references(content)

        classified = []

        for item in suspicious:
            classified.append({
                **item,
                "reference_type": self.classify_reference_type(
                    item["line"]
                ),
                "risk": self.derive_risk(
                    item["line"]
                )
            })

        critical = [
            item for item in classified
            if item["risk"] == "critical_recursive_runtime_ingestion"
        ]

        report = {
            "status": "XCODE_TARGET_MEMBERSHIP_INSPECTION_COMPLETE",
            "executed_at": self.executed_at,
            "pbxproj_path": pbxproj_path,
            "suspicious_reference_count": len(classified),
            "critical_reference_count": len(critical),
            "classified_references": classified[:200],
            "recursive_runtime_ingestion_confirmed": bool(critical),
            "institutional_observation": (
                "ICOS inspected target membership propagation and recursive runtime references."
            ),
            "recommended_next_action": (
                "Generate autonomous membership exclusion mutation for recursive PythonRuntime propagation."
            ),
            "next_required_layer": "xcode_recursive_membership_exclusion_engine"
        }

        save_json(TARGET_STATE, report)

        return report

INSPECTOR = XcodeTargetMembershipInspector()

if __name__ == "__main__":
    print(json.dumps(
        INSPECTOR.inspect(),
        indent=2
    ))
