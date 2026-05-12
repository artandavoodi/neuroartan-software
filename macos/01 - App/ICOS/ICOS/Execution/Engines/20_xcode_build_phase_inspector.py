from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json
import re

MUTATION_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "06_pbxproj_ast_mutation_state.json"
)

INSPECTION_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "07_build_phase_inspection_state.json"
)

PBXPROJ_NAME = "project.pbxproj"

SUSPICIOUS_PATTERNS = [
    ".venv",
    "site-packages",
    "PythonRuntime",
    "rsync",
    "cp -R",
    "copy bundle resources",
    "wheel.py",
    "pip",
    "setuptools"
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


class XcodeBuildPhaseInspector:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def latest_mutation_state(self):
        return load_json(MUTATION_STATE, {})

    def load_pbxproj(self, pbxproj_path: str):
        path = Path(pbxproj_path)

        if not path.exists():
            raise FileNotFoundError(
                f"Missing pbxproj: {path}"
            )

        return path.read_text(errors="ignore")

    def extract_shell_script_phases(self, content: str):
        pattern = re.compile(
            r"shellScript = \"(.*?)\";",
            re.DOTALL
        )

        matches = pattern.findall(content)

        cleaned = []

        for match in matches:
            cleaned.append(
                match.encode("utf-8").decode("unicode_escape")
            )

        return cleaned

    def detect_suspicious_scripts(self, scripts: List[str]):
        suspicious = []

        for script in scripts:
            lowered = script.lower()

            matched = [
                pattern for pattern in SUSPICIOUS_PATTERNS
                if pattern.lower() in lowered
            ]

            if matched:
                suspicious.append({
                    "matched_patterns": matched,
                    "script_preview": script[:1200],
                    "risk": "recursive_runtime_resource_ingestion"
                })

        return suspicious

    def inspect_copy_bundle_references(self, content: str):
        lines = content.splitlines()

        findings = []

        for line in lines:
            lowered = line.lower()

            matched = [
                pattern for pattern in SUSPICIOUS_PATTERNS
                if pattern.lower() in lowered
            ]

            if matched:
                findings.append({
                    "matched_patterns": matched,
                    "line": line.strip()
                })

        return findings

    def inspect(self):
        state = self.latest_mutation_state()

        pbxproj_path = state.get("pbxproj_path")

        if not pbxproj_path:
            return {
                "status": "NO_PBXPROJ_AVAILABLE",
                "executed_at": self.executed_at
            }

        content = self.load_pbxproj(pbxproj_path)

        shell_scripts = self.extract_shell_script_phases(content)

        suspicious_scripts = self.detect_suspicious_scripts(
            shell_scripts
        )

        bundle_findings = self.inspect_copy_bundle_references(
            content
        )

        report = {
            "status": "XCODE_BUILD_PHASE_INSPECTION_COMPLETE",
            "executed_at": self.executed_at,
            "pbxproj_path": pbxproj_path,
            "shell_script_phase_count": len(shell_scripts),
            "suspicious_shell_scripts": suspicious_scripts,
            "copy_bundle_findings": bundle_findings[:100],
            "recursive_ingestion_detected": bool(
                suspicious_scripts or bundle_findings
            ),
            "institutional_observation": (
                "ICOS inspected build phases and recursive runtime ingestion vectors."
            ),
            "recommended_next_action": (
                "Generate autonomous exclusion patch for recursive PythonRuntime resource ingestion."
            ),
            "next_required_layer": "xcode_recursive_resource_exclusion_engine"
        }

        save_json(INSPECTION_STATE, report)

        return report


INSPECTOR = XcodeBuildPhaseInspector()


if __name__ == "__main__":
    print(json.dumps(
        INSPECTOR.inspect(),
        indent=2
    ))