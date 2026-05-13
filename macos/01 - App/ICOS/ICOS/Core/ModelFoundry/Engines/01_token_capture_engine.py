# ============================================================
# ICOS · Token Capture Engine
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

DATA_ROOT = FOUNDRY_ROOT / "Data"
TOKEN_ROOT = FOUNDRY_ROOT / "Tokens"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
EMOTION_ROOT = FOUNDRY_ROOT / "EmotionalSignals"

RAW_INTERACTION_LOG = (
    DATA_ROOT / "raw_interaction_log.json"
)

TOKEN_EVENT_LOG = (
    TOKEN_ROOT / "token_event_log.json"
)

LEARNING_EVENT_STORE = (
    LEARNING_ROOT / "learning_event_store.json"
)

EMOTIONAL_SIGNAL_STORE = (
    EMOTION_ROOT / "emotional_signal_store.json"
)

# ============================================================
# Token Capture Engine
# ============================================================

class TokenCaptureEngine:
    """
    ICOS token-intelligence ingestion layer.

    Responsibilities:
    - capture token streams
    - classify semantic density
    - estimate learning value
    - bind emotional context
    - generate learning signals
    - preserve cognition lineage
    """

    def __init__(self) -> None:
        self.interactions = self._load_json(
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
    # Semantic Density
    # ========================================================

    def semantic_density(
        self,
        text: str,
    ) -> str:

        words = len(text.split())

        if words > 120:
            return "high"

        if words > 40:
            return "medium"

        return "low"

    # ========================================================
    # Emotional Context
    # ========================================================

    def emotional_context(
        self,
        text: str,
    ) -> str:

        lowered = text.lower()

        if any(x in lowered for x in [
            "fear",
            "anxiety",
            "worry",
            "panic",
        ]):
            return "anxiety"

        if any(x in lowered for x in [
            "love",
            "joy",
            "hope",
            "happy",
        ]):
            return "positive"

        if any(x in lowered for x in [
            "sad",
            "loss",
            "pain",
            "grief",
        ]):
            return "grief"

        return "neutral"

    # ========================================================
    # Learning Value
    # ========================================================

    def learning_value(
        self,
        text: str,
    ) -> str:

        density = self.semantic_density(text)

        if density == "high":
            return "high"

        if density == "medium":
            return "medium"

        return "low"

    # ========================================================
    # Token Event Capture
    # ========================================================

    def capture(
        self,
        provider: str,
        user_input: str,
        model_output: str,
    ) -> dict[str, Any]:

        combined = (
            user_input + "\n" + model_output
        )

        event = {
            "event_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "provider": provider,
            "token_estimate": len(
                combined.split()
            ),
            "semantic_density": self.semantic_density(
                combined
            ),
            "learning_value": self.learning_value(
                combined
            ),
            "emotional_context": self.emotional_context(
                user_input
            ),
            "input_length": len(user_input),
            "output_length": len(model_output),
        }

        self.token_events.append(event)

        TOKEN_EVENT_LOG.write_text(
            json.dumps(
                self.token_events,
                indent=2,
            )
        )

        learning_event = {
            "timestamp": time.time(),
            "event_id": event["event_id"],
            "provider": provider,
            "learning_candidate": True,
            "semantic_density": event[
                "semantic_density"
            ],
            "learning_value": event[
                "learning_value"
            ],
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

        return event

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS_TOKEN_CAPTURE",
            "interactions": len(self.interactions),
            "token_events": len(self.token_events),
            "learning_events": len(self.learning_events),
            "emotional_signals": len(
                self.emotional_signals
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = TokenCaptureEngine()

    event = engine.capture(
        provider="OpenAI",
        user_input=(
            "I want ICOS to evolve into a sovereign "
            "cognitive operating system."
        ),
        model_output=(
            "ICOS architecture evolution path generated."
        ),
    )

    print(json.dumps({
        "status": "ICOS_TOKEN_CAPTURE_ENGINE_ACTIVE",
        "event": event,
        "runtime": engine.runtime_status(),
    }, indent=2))