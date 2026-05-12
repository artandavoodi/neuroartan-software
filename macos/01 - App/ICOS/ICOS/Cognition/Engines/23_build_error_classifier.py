from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any
import json
import re

BUILD_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "02_xcode_build_state_store.py"
)

FAILURE_PATTERNS = {
    "duplicate_resource": {
        "signals": [
            "multiple commands produce",
            "copy command from"
        ],
        "severity": "high",
        "root_cause": "Duplicate files are being copied into the app bundle resources.",
        "recommended_fix": "Exclude duplicated runtime/vendor directories from Xcode Copy Bundle Resources phase."
    },
    "missing_dependency": {
        "signals": [
            "no such module",
            "module not found",
            "cannot find"
        ],
        "severity": "high",
        "root_cause": "Required dependency or framework is missing from build scope.",
        "recommended_fix": "Resolve package dependency or target linkage."
    },
    "swift_compile_error": {
        "signals": [
            "swift compile",
            "compileswift",
            "failed frontend command"
        ],
        "severity": "high",
        "root_cause": "Swift compiler failed during frontend compilation.",
        "recommended_fix": "Inspect compiler diagnostics and resolve syntax/type failures."
    },
    "codesign_error": {
        "signals": [
            "codesign",
            "signing",
            "provisioning profile"
        ],
        "severity": "medium",
        "root_cause": "Apple signing or provisioning configuration is invalid.",
        "recommended_fix": "Verify signing identity and provisioning configuration."
    }
}


class BuildErrorClassifier:
    def __init__(self):
        self.classified_at = datetime.now().isoformat(timespec="seconds")

    def load_build_state(self) -> List[Dict[str, Any]]:
        if not BUILD_STATE.exists():
            return []

        try:
            loaded = json.loads(BUILD_STATE.read_text())

            if isinstance(loaded, list):
                return loaded

            return []

        except Exception:
            return []

    def latest_failure(self) -> Dict[str, Any] | None:
        builds = self.load_build_state()

        failures = [
            build for build in builds
            if build.get("success") is False
        ]

        if not failures:
            return None

        return failures[-1]

    def classify(self, output: str) -> Dict[str, Any]:
        lowered = output.lower()

        for category, pattern in FAILURE_PATTERNS.items():
            if all(signal in lowered for signal in pattern["signals"]):
                return {
                    "category": category,
                    "severity": pattern["severity"],
                    "root_cause": pattern["root_cause"],
                    "recommended_fix": pattern["recommended_fix"]
                }

        return {
            "category": "unknown",
            "severity": "unknown",
            "root_cause": "Unable to classify build failure.",
            "recommended_fix": "Increase diagnostic depth and inspect raw build output."
        }

    def extract_duplicate_files(self, output: str) -> List[str]:
        matches = re.findall(
            r"produce '([^']+)'",
            output
        )

        return sorted(set(matches))

    def extract_copy_sources(self, output: str) -> List[str]:
        matches = re.findall(
            r"copy command from '([^']+)'",
            output
        )

        return sorted(set(matches))

    def generate_report(self) -> Dict[str, Any]:
        latest = self.latest_failure()

        if not latest:
            return {
                "status": "NO_BUILD_FAILURES_FOUND",
                "classified_at": self.classified_at
            }

        output = latest.get("output_preview", "")

        classification = self.classify(output)

        duplicate_outputs = self.extract_duplicate_files(output)
        copy_sources = self.extract_copy_sources(output)

        report = {
            "status": "BUILD_ERROR_CLASSIFIED",
            "classified_at": self.classified_at,
            "project_path": latest.get("project_path"),
            "scheme": latest.get("scheme"),
            "classification": classification,
            "duplicate_outputs": duplicate_outputs,
            "copy_sources": copy_sources[:20],
            "adaptive_learning_candidate": latest.get("success") is False,
            "institutional_observation": (
                "Runtime packaging is recursively ingesting the Python virtual environment into the macOS app bundle."
            ),
            "recommended_next_action": (
                "Create resource exclusion layer for .venv and Python vendor artifacts before bundle copy phase."
            )
        }

        return report


CLASSIFIER = BuildErrorClassifier()


if __name__ == "__main__":
    print(json.dumps(
        CLASSIFIER.generate_report(),
        indent=2
    ))
