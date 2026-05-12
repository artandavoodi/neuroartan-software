from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json

STATE_PATH = (
    Path(__file__).resolve().parents[2]
    / "state"
    / "xcode"
    / "01_xcode_project_state_store.py"
)

SUPPORTED_PROJECT_TYPES = [
    ".xcodeproj",
    ".xcworkspace"
]

SUPPORTED_SOURCE_TYPES = [
    ".swift",
    ".m",
    ".mm",
    ".metal"
]


class XcodeProjectScanner:
    def __init__(self):
        self.scanned_at = datetime.now().isoformat(timespec="seconds")

    def discover_projects(
        self,
        root: str
    ) -> List[Path]:
        root_path = Path(root)

        discovered = []

        for extension in SUPPORTED_PROJECT_TYPES:
            discovered.extend(
                root_path.rglob(f"*{extension}")
            )

        return sorted(set(discovered))

    def discover_source_files(
        self,
        project_root: Path
    ) -> List[Path]:
        files = []

        for extension in SUPPORTED_SOURCE_TYPES:
            files.extend(
                project_root.rglob(f"*{extension}")
            )

        return sorted(set(files))

    def detect_swiftui_presence(
        self,
        files: List[Path]
    ) -> bool:
        for file in files:
            try:
                content = file.read_text(errors="ignore")

                if "import SwiftUI" in content:
                    return True

            except Exception:
                continue

        return False

    def build_project_summary(
        self,
        project_path: Path
    ) -> Dict[str, Any]:
        source_files = self.discover_source_files(
            project_path.parent
        )

        swift_files = [
            str(f)
            for f in source_files
            if f.suffix == ".swift"
        ]

        return {
            "project_name": project_path.stem,
            "project_path": str(project_path),
            "project_type": project_path.suffix,
            "source_file_count": len(source_files),
            "swift_file_count": len(swift_files),
            "swiftui_detected": self.detect_swiftui_presence(source_files),
            "source_root": str(project_path.parent),
            "sample_swift_files": swift_files[:5]
        }

    def scan(
        self,
        root: str
    ) -> Dict[str, Any]:
        projects = self.discover_projects(root)

        summaries = [
            self.build_project_summary(project)
            for project in projects
        ]

        report = {
            "status": "XCODE_PROJECT_SCAN_COMPLETE",
            "scanned_at": self.scanned_at,
            "scan_root": root,
            "project_count": len(projects),
            "projects": summaries,
            "xcode_projects_detected": any(
                p["project_type"] == ".xcodeproj"
                for p in summaries
            ),
            "swiftui_projects_detected": any(
                p["swiftui_detected"]
                for p in summaries
            )
        }

        return report


SCANNER = XcodeProjectScanner()


if __name__ == "__main__":
    result = SCANNER.scan(
        "/Users/artan/Neuroartan-software"
    )

    print(json.dumps(result, indent=2))
