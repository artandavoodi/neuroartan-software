from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, Any, Optional
import subprocess
import json

STATE_PATH = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "02_xcode_build_state_store.py"
)

DEFAULT_DERIVED_DATA = (
    Path.home()
    / "Library"
    / "Developer"
    / "Xcode"
    / "DerivedData"
)

class XcodeBuildRunner:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def detect_project_flag(
        self,
        project_path: str
    ):
        path = Path(project_path)

        if path.suffix == ".xcworkspace":
            return ["-workspace", str(path)]

        return ["-project", str(path)]

    def build_command(
        self,
        project_path: str,
        scheme: str,
        configuration: str = "Debug",
        destination: Optional[str] = None
    ):
        command = [
            "xcodebuild"
        ]

        command.extend(
            self.detect_project_flag(project_path)
        )

        command.extend([
            "-scheme",
            scheme,
            "-configuration",
            configuration,
            "build"
        ])

        if destination:
            command.extend([
                "-destination",
                destination
            ])

        return command

    def locate_app_bundle(
        self,
        scheme: str
    ):
        apps = list(
            DEFAULT_DERIVED_DATA.rglob(f"{scheme}.app")
        )

        if not apps:
            return None

        apps.sort(
            key=lambda p: p.stat().st_mtime,
            reverse=True
        )

        return str(apps[0])

    def classify_build_output(
        self,
        output: str
    ):
        lowered = output.lower()

        if "build succeeded" in lowered:
            return "success"

        if "error:" in lowered:
            return "build_error"

        if "warning:" in lowered:
            return "warning"

        return "unknown"

    def execute(
        self,
        project_path: str,
        scheme: str,
        configuration: str = "Debug",
        destination: Optional[str] = None
    ) -> Dict[str, Any]:
        command = self.build_command(
            project_path,
            scheme,
            configuration,
            destination
        )

        try:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=300
            )

            output = result.stdout + result.stderr

            app_bundle = self.locate_app_bundle(
                scheme
            )

            report = {
                "status": "XCODE_BUILD_EXECUTED",
                "executed_at": self.executed_at,
                "command": " ".join(command),
                "project_path": project_path,
                "scheme": scheme,
                "configuration": configuration,
                "success": result.returncode == 0,
                "return_code": result.returncode,
                "classification": self.classify_build_output(output),
                "app_bundle": app_bundle,
                "output_preview": output[-4000:],
                "runtime_ready": app_bundle is not None
            }

            self.persist(report)

            return report

        except subprocess.TimeoutExpired:
            report = {
                "status": "XCODE_BUILD_TIMEOUT",
                "executed_at": self.executed_at,
                "command": " ".join(command),
                "scheme": scheme,
                "success": False
            }

            self.persist(report)

            return report

        except Exception as error:
            report = {
                "status": "XCODE_BUILD_FAILED",
                "executed_at": self.executed_at,
                "command": " ".join(command),
                "scheme": scheme,
                "success": False,
                "error": str(error)
            }

            self.persist(report)

            return report

    def persist(self, report):
        existing = []

        if STATE_PATH.exists():
            try:
                existing = json.loads(
                    STATE_PATH.read_text()
                )
            except Exception:
                existing = []

        existing.append(report)

        STATE_PATH.parent.mkdir(
            parents=True,
            exist_ok=True
        )

        STATE_PATH.write_text(
            json.dumps(existing, indent=2)
        )

RUNNER = XcodeBuildRunner()

if __name__ == "__main__":
    result = RUNNER.execute(
        project_path="/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS.xcodeproj",
        scheme="ICOS",
        configuration="Debug"
    )

    print(json.dumps(result, indent=2))
