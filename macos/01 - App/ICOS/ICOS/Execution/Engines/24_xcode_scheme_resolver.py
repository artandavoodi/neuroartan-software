from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import subprocess
import json

SUPPORTED_PROJECT_TYPES = [
    ".xcodeproj",
    ".xcworkspace"
]


class XcodeSchemeResolver:
    def __init__(self):
        self.resolved_at = datetime.now().isoformat(timespec="seconds")

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

    def run_xcodebuild_list(
        self,
        project_path: Path
    ) -> Dict[str, Any]:
        command = [
            "xcodebuild",
            "-list"
        ]

        if project_path.suffix == ".xcworkspace":
            command.extend([
                "-workspace",
                str(project_path)
            ])
        else:
            command.extend([
                "-project",
                str(project_path)
            ])

        try:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=20
            )

            output = result.stdout + result.stderr

            return {
                "success": result.returncode == 0,
                "command": " ".join(command),
                "output": output
            }

        except Exception as error:
            return {
                "success": False,
                "command": " ".join(command),
                "error": str(error),
                "output": ""
            }

    def extract_section(
        self,
        output: str,
        section_name: str
    ) -> List[str]:
        lines = output.splitlines()

        collected = []
        active = False

        for line in lines:
            stripped = line.strip()

            if stripped == f"{section_name}:":
                active = True
                continue

            if active:
                if stripped.endswith(":"):
                    break

                if stripped:
                    collected.append(stripped)

        return collected

    def resolve_project(
        self,
        project_path: Path
    ) -> Dict[str, Any]:
        listing = self.run_xcodebuild_list(project_path)

        output = listing.get("output", "")

        targets = self.extract_section(
            output,
            "Targets"
        )

        build_configs = self.extract_section(
            output,
            "Build Configurations"
        )

        schemes = self.extract_section(
            output,
            "Schemes"
        )

        return {
            "project_name": project_path.stem,
            "project_path": str(project_path),
            "project_type": project_path.suffix,
            "resolution_success": listing["success"],
            "targets": targets,
            "build_configurations": build_configs,
            "schemes": schemes,
            "default_scheme": schemes[0] if schemes else None,
            "command": listing.get("command"),
            "raw_output_available": bool(output)
        }

    def resolve(
        self,
        root: str
    ) -> Dict[str, Any]:
        projects = self.discover_projects(root)

        resolved = [
            self.resolve_project(project)
            for project in projects
        ]

        successful = [
            project for project in resolved
            if project["resolution_success"]
        ]

        return {
            "status": "XCODE_SCHEME_RESOLUTION_COMPLETE",
            "resolved_at": self.resolved_at,
            "scan_root": root,
            "project_count": len(projects),
            "successful_resolutions": len(successful),
            "projects": resolved,
            "detected_schemes": [
                {
                    "project": project["project_name"],
                    "schemes": project["schemes"]
                }
                for project in successful
            ]
        }


RESOLVER = XcodeSchemeResolver()


if __name__ == "__main__":
    result = RESOLVER.resolve(
        "/Users/artan/Neuroartan-software"
    )

    print(json.dumps(result, indent=2))
