# ============================================================
# ICOS · Failure Lesson Extractor
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

FEEDBACK_ROOT = FOUNDRY_ROOT / "Feedback"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"

FAILURE_LESSON_STORE = (
    FEEDBACK_ROOT / "failure_lesson_store.json"
)

FAILURE_EVENT_LOG = (
    FEEDBACK_ROOT / "failure_event_log.json"
)

LEARNING_EVENT_STORE = (
    LEARNING_ROOT / "learning_event_store.json"
)

FAILURE_DATASET_STORE = (
    DATASET_ROOT / "failure_dataset_store.json"
)

# ============================================================
# Failure Lesson Extractor
# ============================================================

class FailureLessonExtractor:
    """
    ICOS failure-intelligence extraction engine.

    Responsibilities:
    - extract lessons from failed cognition
    - classify reasoning weaknesses
    - preserve alignment corrections
    - generate corrective learning data
    - improve future orchestration quality
    - convert failures into intelligence assets
    """

    def __init__(self) -> None:
        self.failure_lessons = self._load_json(
            FAILURE_LESSON_STORE,
            fallback=[]
        )

        self.failure_events = self._load_json(
            FAILURE_EVENT_LOG,
            fallback=[]
        )

        self.learning_events = self._load_json(
            LEARNING_EVENT_STORE,
            fallback=[]
        )

        self.failure_dataset = self._load_json(
            FAILURE_DATASET_STORE,
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
    # Failure Classification
    # ========================================================

    def classify_failure(
        self,
        failure_text: str,
    ) -> str:

        lowered = failure_text.lower()

        if any(x in lowered for x in [
            "hallucination",
            "fabricated",
            "invented",
        ]):
            return "hallucination"

        if any(x in lowered for x in [
            "memory",
            "forgot",
            "continuity",
        ]):
            return "continuity_failure"

        if any(x in lowered for x in [
            "emotion",
            "tone",
            "feeling",
        ]):
            return "emotional_failure"

        if any(x in lowered for x in [
            "routing",
            "provider",
            "model",
        ]):
            return "routing_failure"

        return "general_failure"

    # ========================================================
    # Lesson Extraction
    # ========================================================

    def extract_lesson(
        self,
        failure_text: str,
        correction: str,
    ) -> dict[str, Any]:

        category = self.classify_failure(
            failure_text
        )

        lesson = {
            "lesson_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "failure_category": category,
            "failure_text": failure_text,
            "correction": correction,
            "future_prevention": True,
            "learning_priority": "high",
        }

        self.failure_lessons.append(lesson)

        FAILURE_LESSON_STORE.write_text(
            json.dumps(
                self.failure_lessons,
                indent=2,
            )
        )

        return lesson

    # ========================================================
    # Failure Dataset Generation
    # ========================================================

    def generate_failure_dataset(
        self,
        lesson: dict[str, Any],
    ) -> dict[str, Any]:

        dataset_entry = {
            "timestamp": time.time(),
            "lesson_id": lesson.get("lesson_id"),
            "category": lesson.get(
                "failure_category"
            ),
            "input": lesson.get("failure_text"),
            "target": lesson.get("correction"),
            "alignment_training": True,
        }

        self.failure_dataset.append(
            dataset_entry
        )

        FAILURE_DATASET_STORE.write_text(
            json.dumps(
                self.failure_dataset,
                indent=2,
            )
        )

        return dataset_entry

    # ========================================================
    # Failure Learning Cycle
    # ========================================================

    def learning_cycle(
        self,
        failure_text: str,
        correction: str,
    ) -> dict[str, Any]:

        lesson = self.extract_lesson(
            failure_text,
            correction,
        )

        dataset = self.generate_failure_dataset(
            lesson
        )

        event = {
            "timestamp": time.time(),
            "lesson_id": lesson.get("lesson_id"),
            "category": lesson.get(
                "failure_category"
            ),
            "dataset_generated": True,
            "future_alignment": True,
        }

        self.failure_events.append(event)

        FAILURE_EVENT_LOG.write_text(
            json.dumps(
                self.failure_events,
                indent=2,
            )
        )

        self.learning_events.append(event)

        LEARNING_EVENT_STORE.write_text(
            json.dumps(
                self.learning_events,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_FAILURE_LEARNING",
            "lesson": lesson,
            "dataset": dataset,
            "event": event,
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = FailureLessonExtractor()

    result = engine.learning_cycle(
        failure_text=(
            "The model fabricated continuity memory and "
            "invented architectural details."
        ),
        correction=(
            "Require verified continuity retrieval before "
            "architectural synthesis."
        ),
    )

    print(json.dumps({
        "status": "ICOS_FAILURE_LESSON_EXTRACTOR_ACTIVE",
        "result": result,
    }, indent=2))