# ============================================================
# ICOS · Model Foundry Controller
# ============================================================

from pathlib import Path
from typing import Any
import json
import time


# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

FOUNDRY_ROOT = ROOT / "Core" / "ModelFoundry"

DATA_ROOT = FOUNDRY_ROOT / "Data"
TOKEN_ROOT = FOUNDRY_ROOT / "Tokens"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
FEEDBACK_ROOT = FOUNDRY_ROOT / "Feedback"
EMOTION_ROOT = FOUNDRY_ROOT / "EmotionalSignals"
TRAINING_ROOT = FOUNDRY_ROOT / "TrainingRuns"
EVALUATION_ROOT = FOUNDRY_ROOT / "Evaluation"
DISTILLATION_ROOT = FOUNDRY_ROOT / "Distillation"
MODEL_REGISTRY_ROOT = FOUNDRY_ROOT / "ModelRegistry"
SAFETY_ROOT = FOUNDRY_ROOT / "Safety"

RAW_INTERACTION_LOG = (
    DATA_ROOT / "raw_interaction_log.json"
)

TOKEN_EVENT_LOG = (
    TOKEN_ROOT / "token_event_log.json"
)

LEARNING_EVENT_STORE = (
    LEARNING_ROOT / "learning_event_store.json"
)

DATASET_MANIFEST = (
    DATASET_ROOT / "dataset_manifest.json"
)

FAILURE_LESSON_STORE = (
    FEEDBACK_ROOT / "failure_lesson_store.json"
)

EMOTIONAL_SIGNAL_STORE = (
    EMOTION_ROOT / "emotional_signal_store.json"
)

TRAINING_RUN_REGISTRY = (
    TRAINING_ROOT / "training_run_registry.json"
)

MODEL_EVALUATION_REGISTRY = (
    EVALUATION_ROOT / "model_evaluation_registry.json"
)

DISTILLATION_PLAN = (
    DISTILLATION_ROOT / "distillation_plan.json"
)

NATIVE_MODEL_REGISTRY = (
    MODEL_REGISTRY_ROOT / "native_model_registry.json"
)

MODEL_TRAINING_SAFETY_POLICY = (
    SAFETY_ROOT / "model_training_safety_policy.json"
)


# ============================================================
# Model Foundry Controller
# ============================================================

class ModelFoundryController:
    """
    ICOS sovereign model-foundry orchestration layer.

    Responsibilities:
    - ingest runtime interactions
    - capture token intelligence
    - extract learning signals
    - build future training datasets
    - map emotional cognition patterns
    - preserve sovereign training lineage
    - coordinate native model evolution
    """

    def __init__(self) -> None:
        self.raw_interactions = self._load_json(
            RAW_INTERACTION_LOG,
            fallback=[]
        )

        self.token_events = self._load_json(
            TOKEN_EVENT_LOG,
            fallback=[]
        )

        self.learning_events = self._load_json(
            LEARNING_EVENT_STORE,
            fallback=[]
        )

        self.dataset_manifest = self._load_json(
            DATASET_MANIFEST,
            fallback=[]
        )

        self.failure_lessons = self._load_json(
            FAILURE_LESSON_STORE,
            fallback=[]
        )

        self.emotional_signals = self._load_json(
            EMOTIONAL_SIGNAL_STORE,
            fallback=[]
        )

        self.training_runs = self._load_json(
            TRAINING_RUN_REGISTRY,
            fallback=[]
        )

        self.evaluations = self._load_json(
            MODEL_EVALUATION_REGISTRY,
            fallback=[]
        )

        self.distillation_plan = self._load_json(
            DISTILLATION_PLAN,
            fallback={}
        )

        self.native_models = self._load_json(
            NATIVE_MODEL_REGISTRY,
            fallback=[]
        )

        self.safety_policy = self._load_json(
            MODEL_TRAINING_SAFETY_POLICY,
            fallback={
                "training_allowed": False,
                "human_review_required": True,
                "emotion_modeling_allowed": True,
                "external_data_requires_review": True,
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
    # Interaction Ingestion
    # ========================================================

    def ingest_interaction(
        self,
        user_input: str,
        model_output: str,
        provider: str,
    ) -> dict[str, Any]:

        interaction = {
            "timestamp": time.time(),
            "provider": provider,
            "user_input": user_input,
            "model_output": model_output,
            "token_estimate": len(
                user_input.split()
            ) + len(model_output.split()),
        }

        self.raw_interactions.append(interaction)

        RAW_INTERACTION_LOG.write_text(
            json.dumps(
                self.raw_interactions,
                indent=2,
            )
        )

        return interaction


    # ========================================================
    # Token Intelligence
    # ========================================================

    def capture_token_event(
        self,
        interaction: dict[str, Any],
    ) -> dict[str, Any]:

        token_event = {
            "timestamp": time.time(),
            "provider": interaction.get("provider"),
            "token_estimate": interaction.get(
                "token_estimate"
            ),
            "semantic_density": "medium",
            "learning_value": "high",
        }

        self.token_events.append(token_event)

        TOKEN_EVENT_LOG.write_text(
            json.dumps(
                self.token_events,
                indent=2,
            )
        )

        return token_event


    # ========================================================
    # Emotional Signal Mapping
    # ========================================================

    def map_emotional_signal(
        self,
        user_input: str,
    ) -> dict[str, Any]:

        lowered = user_input.lower()

        emotion = "neutral"

        if any(x in lowered for x in [
            "fear",
            "anxious",
            "worry",
        ]):
            emotion = "anxiety"

        elif any(x in lowered for x in [
            "happy",
            "joy",
            "love",
        ]):
            emotion = "positive"

        elif any(x in lowered for x in [
            "sad",
            "pain",
            "loss",
        ]):
            emotion = "grief"

        signal = {
            "timestamp": time.time(),
            "emotion": emotion,
            "input_length": len(user_input),
            "confidence": "low",
        }

        self.emotional_signals.append(signal)

        EMOTIONAL_SIGNAL_STORE.write_text(
            json.dumps(
                self.emotional_signals,
                indent=2,
            )
        )

        return signal


    # ========================================================
    # Dataset Evolution
    # ========================================================

    def generate_dataset_entry(
        self,
        interaction: dict[str, Any],
        emotion: dict[str, Any],
    ) -> dict[str, Any]:

        dataset_entry = {
            "timestamp": time.time(),
            "provider": interaction.get("provider"),
            "input": interaction.get("user_input"),
            "output": interaction.get("model_output"),
            "emotion": emotion.get("emotion"),
            "training_candidate": True,
        }

        self.dataset_manifest.append(dataset_entry)

        DATASET_MANIFEST.write_text(
            json.dumps(
                self.dataset_manifest,
                indent=2,
            )
        )

        return dataset_entry


    # ========================================================
    # Runtime Overview
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS_MODEL_FOUNDRY",
            "interactions": len(self.raw_interactions),
            "token_events": len(self.token_events),
            "learning_events": len(self.learning_events),
            "datasets": len(self.dataset_manifest),
            "emotional_signals": len(self.emotional_signals),
            "native_models": len(self.native_models),
            "training_allowed": self.safety_policy.get(
                "training_allowed",
                False,
            ),
            "human_review_required": self.safety_policy.get(
                "human_review_required",
                True,
            ),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    foundry = ModelFoundryController()

    interaction = foundry.ingest_interaction(
        user_input="I want ICOS to evolve into a sovereign cognition system.",
        model_output="ICOS architecture roadmap generated.",
        provider="OpenAI",
    )

    foundry.capture_token_event(interaction)

    emotion = foundry.map_emotional_signal(
        interaction["user_input"]
    )

    foundry.generate_dataset_entry(
        interaction,
        emotion,
    )

    print(json.dumps({
        "status": "ICOS_MODEL_FOUNDRY_ACTIVE",
        "runtime": foundry.runtime_status(),
    }, indent=2))