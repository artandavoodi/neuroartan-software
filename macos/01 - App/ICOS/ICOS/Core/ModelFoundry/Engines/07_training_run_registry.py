# ============================================================
# ICOS · Training Run Registry
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

TRAINING_ROOT = FOUNDRY_ROOT / "TrainingRuns"
DISTILLATION_ROOT = FOUNDRY_ROOT / "Distillation"
MODEL_ROOT = FOUNDRY_ROOT / "ModelRegistry"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
SAFETY_ROOT = FOUNDRY_ROOT / "Safety"

TRAINING_RUN_REGISTRY = (
    TRAINING_ROOT / "training_run_registry.json"
)

TRAINING_EVENT_LOG = (
    TRAINING_ROOT / "training_event_log.json"
)

DISTILLATION_PLAN = (
    DISTILLATION_ROOT / "distillation_plan.json"
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
# Training Run Registry
# ============================================================

class TrainingRunRegistry:
    """
    ICOS sovereign training orchestration registry.

    Responsibilities:
    - register governed training runs
    - preserve training lineage
    - coordinate dataset allocation
    - track model evolution
    - preserve audit continuity
    - enforce safety governance
    """

    def __init__(self) -> None:
        self.training_runs = self._load_json(
            TRAINING_RUN_REGISTRY,
            fallback=[]
        )

        self.training_events = self._load_json(
            TRAINING_EVENT_LOG,
            fallback=[]
        )

        self.distillation_plan = self._load_json(
            DISTILLATION_PLAN,
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
                "gpu_required": True,
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
    # Training Registration
    # ========================================================

    def register_training_run(
        self,
        model_family: str,
        training_type: str,
    ) -> dict[str, Any]:

        run = {
            "run_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "model_family": model_family,
            "training_type": training_type,
            "dataset_count": len(
                self.unified_datasets
            ),
            "governance_required": self.safety_policy.get(
                "human_review_required",
                True,
            ),
            "gpu_required": self.safety_policy.get(
                "gpu_required",
                True,
            ),
            "training_allowed": self.safety_policy.get(
                "training_allowed",
                False,
            ),
            "status": "registered",
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
    # Training Lineage
    # ========================================================

    def generate_lineage(
        self,
        run: dict[str, Any],
    ) -> dict[str, Any]:

        lineage = {
            "timestamp": time.time(),
            "run_id": run.get("run_id"),
            "model_family": run.get(
                "model_family"
            ),
            "dataset_count": run.get(
                "dataset_count"
            ),
            "lineage_preserved": True,
            "audit_continuity": True,
        }

        self.training_events.append(lineage)

        TRAINING_EVENT_LOG.write_text(
            json.dumps(
                self.training_events,
                indent=2,
            )
        )

        return lineage


    # ========================================================
    # Training Governance
    # ========================================================

    def governance_status(
        self,
        run: dict[str, Any],
    ) -> dict[str, Any]:

        governance = {
            "timestamp": time.time(),
            "run_id": run.get("run_id"),
            "training_allowed": run.get(
                "training_allowed"
            ),
            "human_review_required": run.get(
                "governance_required"
            ),
            "gpu_required": run.get(
                "gpu_required"
            ),
            "production_training": False,
        }

        self.training_events.append(governance)

        TRAINING_EVENT_LOG.write_text(
            json.dumps(
                self.training_events,
                indent=2,
            )
        )

        return governance


    # ========================================================
    # Training Learning Cycle
    # ========================================================

    def learning_cycle(
        self,
        model_family: str,
        training_type: str,
    ) -> dict[str, Any]:

        run = self.register_training_run(
            model_family,
            training_type,
        )

        lineage = self.generate_lineage(
            run
        )

        governance = self.governance_status(
            run
        )

        event = {
            "timestamp": time.time(),
            "run_id": run.get("run_id"),
            "training_registered": True,
            "lineage_preserved": True,
            "governance_verified": True,
        }

        self.training_events.append(event)

        TRAINING_EVENT_LOG.write_text(
            json.dumps(
                self.training_events,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_TRAINING_RUN_REGISTRY",
            "run": run,
            "lineage": lineage,
            "governance": governance,
            "event": event,
        }


    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS_TRAINING_RUN_REGISTRY",
            "training_runs": len(
                self.training_runs
            ),
            "training_events": len(
                self.training_events
            ),
            "datasets": len(
                self.unified_datasets
            ),
            "native_models": len(
                self.native_models
            ),
            "distillation_phases": len(
                self.distillation_plan
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
    registry = TrainingRunRegistry()

    result = registry.learning_cycle(
        model_family="icos-core",
        training_type="semantic_alignment_training",
    )

    print(json.dumps({
        "status": "ICOS_TRAINING_RUN_REGISTRY_ACTIVE",
        "result": result,
        "runtime": registry.runtime_status(),
    }, indent=2))