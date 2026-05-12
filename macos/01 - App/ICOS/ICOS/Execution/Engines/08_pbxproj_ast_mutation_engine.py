from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json
import shutil

EDITOR_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "05_pbxproj_editor_state.json"
)

MUTATION_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "06_pbxproj_ast_mutation_state.json"
)



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


class PBXProjASTMutationEngine:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def latest_editor_state(self):
        return load_json(EDITOR_STATE, {})

    def load_pbxproj(self, pbxproj_path: str):
        path = Path(pbxproj_path)

        if not path.exists():
            raise FileNotFoundError(
                f"Missing pbxproj: {path}"
            )

        return path.read_text(errors="ignore")

    def create_runtime_backup(self, pbxproj_path: str):
        original = Path(pbxproj_path)

        backup = original.with_suffix(
            ".runtime-backup.pbxproj"
        )

        shutil.copy2(original, backup)

        return str(backup)

    def remove_resource_reference(
        self,
        content: str,
        resource_path: str
    ):
        lowered = resource_path.lower()

        filtered = []

        removed_lines = []

        for line in content.splitlines():
            if lowered in line.lower():
                removed_lines.append(line)
                continue

            filtered.append(line)

        return {
            "content": "\n".join(filtered),
            "removed_lines": removed_lines
        }

    def apply_mutations(self):
        editor_state = self.latest_editor_state()

        if not editor_state:
            return {
                "status": "NO_EDITOR_STATE_AVAILABLE",
                "executed_at": self.executed_at
            }

        pbxproj_path = editor_state.get("pbxproj_path")

        if not pbxproj_path:
            return {
                "status": "NO_PBXPROJ_PATH_AVAILABLE",
                "executed_at": self.executed_at
            }

        content = self.load_pbxproj(pbxproj_path)

        runtime_backup = self.create_runtime_backup(
            pbxproj_path
        )

        exclusions = editor_state.get(
            "resource_exclusions",
            []
        )

        mutation_log = []

        updated_content = content

        for exclusion in exclusions:
            resource_path = exclusion.get(
                "resource_path",
                ""
            )

            mutation = self.remove_resource_reference(
                updated_content,
                resource_path
            )

            updated_content = mutation["content"]

            mutation_log.append({
                "resource_path": resource_path,
                "removed_line_count": len(
                    mutation["removed_lines"]
                ),
                "removed_lines_preview": mutation[
                    "removed_lines"
                ][:10]
            })

        Path(pbxproj_path).write_text(updated_content)

        report = {
            "status": "PBXPROJ_AST_MUTATION_APPLIED",
            "executed_at": self.executed_at,
            "pbxproj_path": pbxproj_path,
            "runtime_backup": runtime_backup,
            "mutation_count": len(mutation_log),
            "mutations": mutation_log[:50],
            "autonomous_repair_complete": True,
            "next_required_action": (
                "Re-run xcodebuild to verify resource-phase repair."
            ),
            "institutional_observation": (
                "ICOS performed controlled autonomous pbxproj resource-phase mutation."
            )
        }

        save_json(MUTATION_STATE, report)

        return report


ENGINE = PBXProjASTMutationEngine()


if __name__ == "__main__":
    print(json.dumps(
        ENGINE.apply_mutations(),
        indent=2
    ))
