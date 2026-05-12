# ============================================================
# ICOS · Distillation Planner
# ============================================================

from pathlib import Path
from typing import Any
import json
import time
import uuid


# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

FOUNDRY_ROOT = ROOT / "Core" / "ModelFoundry"

DISTILLATION_ROOT = FOUNDRY_ROOT / "Distillation"
TRAINING_ROOT = FOUNDRY_ROOT / "TrainingRuns"
MODEL_ROOT = FOUNDRY_ROOT / "ModelRegistry"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
SAFETY_ROOT = FOUNDRY_ROOT / "Safety"

DISTILLATION_PLAN = (
    DISTILLATION_ROOT / "distillation_plan.json"
)

DISTILLATION_EVENT_LOG = (
    DISTILLATION_ROOT / "distillation_event_log.json"
)

TRAINING_RUN_REGISTRY = (
    TRAINING_ROOT / "training_run_registry.json"
)

NATIVE_MODEL_REGISTRY = (
    MODEL_ROOT / "native_model_registry.json"
)

UNIFIED_DATASET_STORE = (
    DATASET_ROOT / "unified_training_dataset.json"
)

MODEL_TRAINING_SAFETY_POLICY = (
    SAFETY_ROOT / "model_training_safety_policy.json"
)


# ============================================================
# Distillation Planner
# ============================================================

class DistillationPlanner:
    """
    ICOS sovereign distillation orchestration layer.

    Responsibilities:
    - define native model evolution
    - orchestrate distillation phases
    - coordinate training architecture
    - define model capability tiers
    - preserve sovereign training lineage
    - prepare future frontier cognition runtime
    """

    MODEL_FAMILIES = {
        "icos-nano": {
            "parameters": "1B-3B",
            "purpose": "mobile cognition"
        },
        "icos-core": {
            "parameters": "7B-13B",
            "purpose": "general cognition"
        },
        "icos-executive": {
            "parameters": "30B-70B",
            "purpose": "executive cognition"
        },
        "icos-frontier": {
            "parameters": "100B+",
            "purpose": "frontier sovereign cognition"
        },
    }

    def __init__(self) -> None:
        self.distillation_plan = self._load_json(
            DISTILLATION_PLAN,
            fallback=[]
        )

        self.distillation_events = self._load_json(
            DISTILLATION_EVENT_LOG,
            fallback=[]
        )

        self.training_runs = self._load_json(
            TRAINING_RUN_REGISTRY,
            fallback=[]
        )

        self.native_models = self._load_json(
            NATIVE_MODEL_REGISTRY,
            fallback=[]
        )

        self.unified_datasets = self._load_json(
            UNIFIED_DATASET_STORE,
            fallback=[]
        )

        self.safety_policy = self._load_json(
            MODEL_TRAINING_SAFETY_POLICY,
            fallback={
                "training_allowed": False,
                "human_review_required": True,
                "distillation_allowed": True,
            }
        )


    # ========================================================
    # JSON Loading
    # ========================================================

    def _load_json(
        self,
        path: Path,
        fallback: Any = None,
    ) -> Any:

        if not path.exists():
            return fallback

        try:
            content = path.read_text().strip()

            if not content:
                return fallback

            return json.loads(content)

        except Exception:
            return fallback


    # ========================================================
    # Distillation Phase Planning
    # ========================================================

    def create_distillation_phase(
        self,
        model_family: str,
    ) -> dict[str, Any]:

        family = self.MODEL_FAMILIES.get(
            model_family,
            {}
        )

        phase = {
            "phase_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "model_family": model_family,
            "parameter_target": family.get(
                "parameters"
            ),
            "purpose": family.get("purpose"),
            "dataset_count": len(
                self.unified_datasets
            ),
            "training_allowed": self.safety_policy.get(
                "training_allowed",
                False,
            ),
            "human_review_required": self.safety_policy.get(
                "human_review_required",
                True,
            ),
            "status": "planned",
        }

        self.distillation_plan.append(phase)

        DISTILLATION_PLAN.write_text(
            json.dumps(
                self.distillation_plan,
                indent=2,
            )
        )

        return phase


    # ========================================================
    # Training Registry
    # ========================================================

    def register_training_run(
        self,
        phase: dict[str, Any],
    ) -> dict[str, Any]:

        run = {
            "run_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "model_family": phase.get(
                "model_family"
            ),
            "dataset_count": phase.get(
                "dataset_count"
            ),
            "parameter_target": phase.get(
                "parameter_target"
            ),
            "status": "pending_governance",
        }

        self.training_runs.append(run)

        TRAINING_RUN_REGISTRY.write_text(
            json.dumps(
                self.training_runs,
                indent=2,
            )
        )

        return run


    # ========================================================
    # Native Model Roadmap
    # ========================================================

    def register_model_roadmap(
        self,
        phase: dict[str, Any],
    ) -> dict[str, Any]:

        roadmap = {
            "model_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "model_family": phase.get(
                "model_family"
            ),
            "purpose": phase.get("purpose"),
            "parameter_target": phase.get(
                "parameter_target"
            ),
            "status": "roadmap_defined",
            "future_frontier_candidate": (
                phase.get("model_family")
                == "icos-frontier"
            ),
        }

        self.native_models.append(roadmap)

        NATIVE_MODEL_REGISTRY.write_text(
            json.dumps(
                self.native_models,
                indent=2,
            )
        )

        return roadmap


    # ========================================================
    # Distillation Learning Cycle
    # ========================================================

    def learning_cycle(
        self,
        model_family: str,
    ) -> dict[str, Any]:

        phase = self.create_distillation_phase(
            model_family
        )

        run = self.register_training_run(
            phase
        )

        roadmap = self.register_model_roadmap(
            phase
        )

        event = {
            "timestamp": time.time(),
            "phase_id": phase.get("phase_id"),
            "model_family": model_family,
            "distillation_planned": True,
            "training_registered": True,
            "roadmap_registered": True,
        }

        self.distillation_events.append(event)

        DISTILLATION_EVENT_LOG.write_text(
            json.dumps(
                self.distillation_events,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_DISTILLATION_PLANNER",
            "phase": phase,
            "training_run": run,
            "roadmap": roadmap,
            "event": event,
        }


    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS_DISTILLATION_PLANNER",
            "distillation_phases": len(
                self.distillation_plan
            ),
            "training_runs": len(
                self.training_runs
            ),
            "native_models": len(
                self.native_models
            ),
            "datasets": len(
                self.unified_datasets
            ),
            "training_allowed": self.safety_policy.get(
                "training_allowed",
                False,
            ),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    planner = DistillationPlanner()

    result = planner.learning_cycle(
        model_family="icos-core"
    )

    print(json.dumps({
        "status": "ICOS_DISTILLATION_PLANNER_ACTIVE",
        "result": result,
        "runtime": planner.runtime_status(),
    }, indent=2))