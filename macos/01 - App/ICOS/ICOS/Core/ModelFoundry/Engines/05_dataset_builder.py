# ============================================================
# ICOS · Dataset Builder
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

DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
EMOTION_ROOT = FOUNDRY_ROOT / "EmotionalSignals"
FEEDBACK_ROOT = FOUNDRY_ROOT / "Feedback"
TOKEN_ROOT = FOUNDRY_ROOT / "Tokens"

DATASET_MANIFEST = (
    DATASET_ROOT / "dataset_manifest.json"
)

UNIFIED_DATASET_STORE = (
    DATASET_ROOT / "unified_training_dataset.json"
)

FAILURE_DATASET_STORE = (
    DATASET_ROOT / "failure_dataset_store.json"
)

EMOTIONAL_DATASET_STORE = (
    DATASET_ROOT / "emotional_dataset_store.json"
)

SEMANTIC_MEMORY_STORE = (
    LEARNING_ROOT / "semantic_memory_store.json"
)

RELATIONSHIP_GRAPH_STORE = (
    LEARNING_ROOT / "relationship_graph_store.json"
)

TOKEN_EVENT_LOG = (
    TOKEN_ROOT / "token_event_log.json"
)

FAILURE_LESSON_STORE = (
    FEEDBACK_ROOT / "failure_lesson_store.json"
)

EMOTIONAL_SIGNAL_STORE = (
    EMOTION_ROOT / "emotional_signal_store.json"
)

# ============================================================
# Dataset Builder
# ============================================================

class DatasetBuilder:
    """
    ICOS unified cognition dataset engine.

    Responsibilities:
    - merge semantic cognition
    - merge emotional cognition
    - merge token intelligence
    - merge failure intelligence
    - synthesize unified training corpora
    - prepare sovereign model datasets
    """

    def __init__(self) -> None:
        self.dataset_manifest = self._load_json(
            DATASET_MANIFEST,
            fallback=[]
        )

        self.unified_dataset = self._load_json(
            UNIFIED_DATASET_STORE,
            fallback=[]
        )

        self.failure_dataset = self._load_json(
            FAILURE_DATASET_STORE,
            fallback=[]
        )

        self.emotional_dataset = self._load_json(
            EMOTIONAL_DATASET_STORE,
            fallback=[]
        )

        self.semantic_memory = self._load_json(
            SEMANTIC_MEMORY_STORE,
            fallback=[]
        )

        self.relationship_graph = self._load_json(
            RELATIONSHIP_GRAPH_STORE,
            fallback=[]
        )

        self.token_events = self._load_json(
            TOKEN_EVENT_LOG,
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
    # Unified Dataset Entry
    # ========================================================

    def build_entry(self) -> dict[str, Any]:

        semantic = (
            self.semantic_memory[-1]
            if self.semantic_memory
            else {}
        )

        emotional = (
            self.emotional_dataset[-1]
            if self.emotional_dataset
            else {}
        )

        failure = (
            self.failure_dataset[-1]
            if self.failure_dataset
            else {}
        )

        token = (
            self.token_events[-1]
            if self.token_events
            else {}
        )

        entry = {
            "dataset_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "semantic_concepts": semantic.get(
                "concepts",
                []
            ),
            "semantic_density": semantic.get(
                "semantic_density"
            ),
            "emotion": emotional.get("emotion"),
            "emotion_confidence": emotional.get(
                "confidence"
            ),
            "failure_category": failure.get(
                "category"
            ),
            "alignment_training": failure.get(
                "alignment_training",
                False,
            ),
            "token_estimate": token.get(
                "token_estimate"
            ),
            "learning_value": token.get(
                "learning_value"
            ),
            "relationship_graph_size": len(
                self.relationship_graph
            ),
            "training_ready": True,
        }

        return entry

    # ========================================================
    # Dataset Synthesis
    # ========================================================

    def synthesize_dataset(self) -> dict[str, Any]:

        entry = self.build_entry()

        self.unified_dataset.append(entry)

        UNIFIED_DATASET_STORE.write_text(
            json.dumps(
                self.unified_dataset,
                indent=2,
            )
        )

        manifest_entry = {
            "timestamp": time.time(),
            "dataset_id": entry.get("dataset_id"),
            "training_ready": True,
            "semantic_learning": True,
            "emotional_learning": True,
            "alignment_learning": True,
        }

        self.dataset_manifest.append(
            manifest_entry
        )

        DATASET_MANIFEST.write_text(
            json.dumps(
                self.dataset_manifest,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_DATASET_BUILDER",
            "dataset_entry": entry,
            "manifest_entry": manifest_entry,
        }

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS_DATASET_BUILDER",
            "unified_datasets": len(
                self.unified_dataset
            ),
            "semantic_memories": len(
                self.semantic_memory
            ),
            "relationship_graph_size": len(
                self.relationship_graph
            ),
            "token_events": len(
                self.token_events
            ),
            "failure_lessons": len(
                self.failure_lessons
            ),
            "emotional_signals": len(
                self.emotional_signals
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    builder = DatasetBuilder()

    result = builder.synthesize_dataset()

    print(json.dumps({
        "status": "ICOS_DATASET_BUILDER_ACTIVE",
        "result": result,
        "runtime": builder.runtime_status(),
    }, indent=2))