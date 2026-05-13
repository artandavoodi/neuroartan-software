from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import json
import shutil

PLAN_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "04_resource_exclusion_plan_state.json"
)

EDITOR_STATE = (
    Path(__file__).resolve().parents[3]
    / "state"
    / "xcode"
    / "05_pbxproj_editor_state.json"
)

PBXPROJ_NAME = "project.pbxproj"

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

class PBXProjResourcePhaseEditor:
    def __init__(self):
        self.executed_at = datetime.now().isoformat(timespec="seconds")

    def latest_plan(self):
        return load_json(PLAN_STATE, {})

    def locate_pbxproj(self, project_path: str):
        project = Path(project_path)

        if project.suffix != ".xcodeproj":
            return None

        pbxproj = project / PBXPROJ_NAME

        if pbxproj.exists():
            return pbxproj

        return None

    def create_backup(self, pbxproj: Path):
        backup = pbxproj.with_suffix(".pbxproj.backup")

        shutil.copy2(pbxproj, backup)

        return backup

    def generate_exclusion_rules(self, candidates):
        rules = []

        for candidate in candidates:
            path = candidate.get("path", "")

            rules.append({
                "resource_path": path,
                "recommended_operation": "remove_from_copy_bundle_resources",
                "reason": "Python runtime vendor artifact should not be copied into app bundle resources."
            })

        return rules

    def generate_patch_preview(self, exclusions):
        preview = []

        for exclusion in exclusions:
            preview.append({
                "operation": "REMOVE_RESOURCE_REFERENCE",
                "target": exclusion["resource_path"]
            })

        return preview

    def build_plan(self):
        plan = self.latest_plan()

        if not plan:
            return {
                "status": "NO_RESOURCE_PLAN_AVAILABLE",
                "executed_at": self.executed_at
            }

        project_path = plan.get("project_path")

        pbxproj = self.locate_pbxproj(project_path)

        if not pbxproj:
            return {
                "status": "PBXPROJ_NOT_FOUND",
                "executed_at": self.executed_at,
                "project_path": project_path
            }

        backup = self.create_backup(pbxproj)

        exclusions = self.generate_exclusion_rules(
            plan.get("exclusion_candidates", [])
        )

        patch_preview = self.generate_patch_preview(exclusions)

        report = {
            "status": "PBXPROJ_RESOURCE_PHASE_PLAN_READY",
            "executed_at": self.executed_at,
            "project_path": project_path,
            "pbxproj_path": str(pbxproj),
            "backup_created": str(backup),
            "resource_exclusion_count": len(exclusions),
            "resource_exclusions": exclusions[:50],
            "patch_preview": patch_preview[:50],
            "autonomous_mutation_enabled": False,
            "mutation_block_reason": (
                "Safe pbxproj AST mutation engine not yet injected."
            ),
            "required_next_layer": "pbxproj_ast_mutation_engine",
            "institutional_observation": (
                "ICOS is now capable of preparing safe Xcode resource-phase repair plans."
            )
        }

        save_json(EDITOR_STATE, report)

        return report

EDITOR = PBXProjResourcePhaseEditor()

if __name__ == "__main__":
    print(json.dumps(
        EDITOR.build_plan(),
        indent=2
    ))