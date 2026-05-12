# ============================================================
# ICOS · Emotional Signal Mapper
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

EMOTION_ROOT = FOUNDRY_ROOT / "EmotionalSignals"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
FEEDBACK_ROOT = FOUNDRY_ROOT / "Feedback"

EMOTIONAL_SIGNAL_STORE = (
    EMOTION_ROOT / "emotional_signal_store.json"
)

EMOTIONAL_PROFILE_STORE = (
    EMOTION_ROOT / "emotional_profile_store.json"
)

EMOTIONAL_RELATIONSHIP_GRAPH = (
    EMOTION_ROOT / "emotional_relationship_graph.json"
)

LEARNING_EVENT_STORE = (
    LEARNING_ROOT / "learning_event_store.json"
)

EMOTIONAL_DATASET_STORE = (
    DATASET_ROOT / "emotional_dataset_store.json"
)

FAILURE_LESSON_STORE = (
    FEEDBACK_ROOT / "failure_lesson_store.json"
)


# ============================================================
# Emotional Signal Mapper
# ============================================================

class EmotionalSignalMapper:
    """
    ICOS emotional cognition engine.

    Responsibilities:
    - map emotional patterns
    - preserve emotional continuity
    - construct emotional cognition profiles
    - bind emotion to reasoning
    - generate adaptive emotional datasets
    - improve human-responsive cognition
    """

    EMOTIONAL_VECTORS = {
        "anxiety": ["fear", "worry", "panic", "uncertainty"],
        "positive": ["joy", "love", "hope", "trust"],
        "grief": ["loss", "pain", "sad", "mourning"],
        "anger": ["rage", "frustration", "hate", "resentment"],
        "neutral": []
    }

    def __init__(self) -> None:
        self.emotional_signals = self._load_json(
            EMOTIONAL_SIGNAL_STORE,
            fallback=[]
        )

        self.emotional_profiles = self._load_json(
            EMOTIONAL_PROFILE_STORE,
            fallback=[]
        )

        self.relationship_graph = self._load_json(
            EMOTIONAL_RELATIONSHIP_GRAPH,
            fallback=[]
        )

        self.learning_events = self._load_json(
            LEARNING_EVENT_STORE,
            fallback=[]
        )

        self.emotional_dataset = self._load_json(
            EMOTIONAL_DATASET_STORE,
            fallback=[]
        )

        self.failure_lessons = self._load_json(
            FAILURE_LESSON_STORE,
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
    # Emotional Detection
    # ========================================================

    def detect_emotion(
        self,
        text: str,
    ) -> tuple[str, float]:

        lowered = text.lower()

        best_match = "neutral"
        best_score = 0

        for emotion, words in self.EMOTIONAL_VECTORS.items():
            score = sum(
                1 for word in words
                if word in lowered
            )

            if score > best_score:
                best_match = emotion
                best_score = score

        confidence = (
            min(best_score / 4, 1.0)
            if best_score > 0
            else 0.25
        )

        return best_match, confidence


    # ========================================================
    # Emotional Signal Encoding
    # ========================================================

    def encode_signal(
        self,
        text: str,
    ) -> dict[str, Any]:

        emotion, confidence = self.detect_emotion(
            text
        )

        signal = {
            "signal_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "emotion": emotion,
            "confidence": confidence,
            "input_length": len(text),
            "adaptive_weight": (
                "high" if confidence > 0.7 else "medium"
            ),
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
    # Emotional Profile Construction
    # ========================================================

    def construct_profile(
        self,
        signal: dict[str, Any],
    ) -> dict[str, Any]:

        profile = {
            "profile_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "emotion": signal.get("emotion"),
            "confidence": signal.get("confidence"),
            "adaptive_weight": signal.get(
                "adaptive_weight"
            ),
            "continuity_binding": True,
        }

        self.emotional_profiles.append(profile)

        EMOTIONAL_PROFILE_STORE.write_text(
            json.dumps(
                self.emotional_profiles,
                indent=2,
            )
        )

        return profile


    # ========================================================
    # Emotional Relationship Graph
    # ========================================================

    def build_relationship_graph(
        self,
        profile: dict[str, Any],
    ) -> dict[str, Any]:

        relationship = {
            "timestamp": time.time(),
            "emotion": profile.get("emotion"),
            "adaptive_weight": profile.get(
                "adaptive_weight"
            ),
            "relationship_type": (
                "emotional_continuity"
            ),
        }

        self.relationship_graph.append(
            relationship
        )

        EMOTIONAL_RELATIONSHIP_GRAPH.write_text(
            json.dumps(
                self.relationship_graph,
                indent=2,
            )
        )

        return relationship


    # ========================================================
    # Emotional Dataset Generation
    # ========================================================

    def generate_dataset(
        self,
        text: str,
        profile: dict[str, Any],
    ) -> dict[str, Any]:

        dataset_entry = {
            "timestamp": time.time(),
            "emotion": profile.get("emotion"),
            "confidence": profile.get("confidence"),
            "text": text,
            "adaptive_training": True,
        }

        self.emotional_dataset.append(
            dataset_entry
        )

        EMOTIONAL_DATASET_STORE.write_text(
            json.dumps(
                self.emotional_dataset,
                indent=2,
            )
        )

        return dataset_entry


    # ========================================================
    # Emotional Learning Cycle
    # ========================================================

    def learning_cycle(
        self,
        text: str,
    ) -> dict[str, Any]:

        signal = self.encode_signal(text)

        profile = self.construct_profile(
            signal
        )

        relationship = self.build_relationship_graph(
            profile
        )

        dataset = self.generate_dataset(
            text,
            profile,
        )

        learning_event = {
            "timestamp": time.time(),
            "signal_id": signal.get("signal_id"),
            "emotion": signal.get("emotion"),
            "confidence": signal.get("confidence"),
            "adaptive_learning": True,
        }

        self.learning_events.append(
            learning_event
        )

        LEARNING_EVENT_STORE.write_text(
            json.dumps(
                self.learning_events,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_EMOTIONAL_COGNITION",
            "signal": signal,
            "profile": profile,
            "relationship": relationship,
            "dataset": dataset,
            "learning_event": learning_event,
            "failure_lessons_loaded": len(
                self.failure_lessons
            ),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = EmotionalSignalMapper()

    result = engine.learning_cycle(
        text=(
            "I feel uncertainty and worry about whether "
            "ICOS can evolve safely and preserve continuity."
        )
    )

    print(json.dumps({
        "status": "ICOS_EMOTIONAL_SIGNAL_MAPPER_ACTIVE",
        "result": result,
    }, indent=2))