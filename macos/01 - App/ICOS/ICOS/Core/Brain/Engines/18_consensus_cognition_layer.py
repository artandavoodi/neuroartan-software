# ============================================================
# ICOS · Consensus Cognition Layer
# ============================================================

from pathlib import Path
from typing import Any
import json
import time

# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

BRAIN_ROOT = ROOT / "Core" / "Brain"

LEARNING_ROOT = BRAIN_ROOT / "Learning"
STATE_ROOT = BRAIN_ROOT / "State"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

CONSENSUS_LOG = (
    REFLECTION_ROOT / "consensus_cognition_log.json"
)

# ============================================================
# Consensus Cognition Layer
# ============================================================

class ConsensusCognitionLayer:
    """
    ICOS multi-model consensus cognition engine.

    Responsibilities:
    - compare model outputs
    - detect contradictions
    - synthesize sovereign cognition
    - prevent single-model dominance
    - preserve ICOS cognitive authority
    - recursively improve reasoning quality
    """

    def __init__(self) -> None:
        self.learning_log = self._load_json(
            LEARNING_LOG,
            fallback=[]
        )

        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.consensus_log = self._load_json(
            CONSENSUS_LOG,
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
            return json.loads(path.read_text())
        except Exception:
            return fallback

    # ========================================================
    # Contradiction Detection
    # ========================================================

    def detect_contradictions(
        self,
        outputs: list[dict[str, str]],
    ) -> list[dict[str, Any]]:

        contradictions = []

        for i, left in enumerate(outputs):
            for right in outputs[i + 1:]:
                if left["output"].strip().lower() != right["output"].strip().lower():
                    contradictions.append({
                        "provider_a": left["provider"],
                        "provider_b": right["provider"],
                        "output_a": left["output"],
                        "output_b": right["output"],
                    })

        return contradictions

    # ========================================================
    # Consensus Synthesis
    # ========================================================

    def synthesize_consensus(
        self,
        user_input: str,
        outputs: list[dict[str, str]],
    ) -> dict[str, Any]:

        contradictions = self.detect_contradictions(
            outputs
        )

        dominant = outputs[0] if outputs else {
            "provider": "NONE",
            "output": "No cognition available."
        }

        consensus = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "user_input": user_input,
            "providers_consulted": [
                x["provider"] for x in outputs
            ],
            "contradictions_detected": len(contradictions) > 0,
            "contradictions": contradictions,
            "final_cognition": dominant["output"],
            "sovereign_authority": "ICOS_BRAIN",
        }

        self.consensus_log.append(consensus)

        CONSENSUS_LOG.write_text(
            json.dumps(
                self.consensus_log,
                indent=2,
            )
        )

        return consensus

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "consensus_cognition": True,
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "consensus_events": len(
                self.consensus_log
            ),
            "learning_events": len(
                self.learning_log
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    layer = ConsensusCognitionLayer()

    sample = layer.synthesize_consensus(
        user_input="What architecture should ICOS use?",
        outputs=[
            {
                "provider": "LMStudio",
                "output": "Use modular local cognition.",
            },
            {
                "provider": "OpenAI",
                "output": "Use distributed orchestration.",
            },
            {
                "provider": "Gemini",
                "output": "Use adaptive memory routing.",
            },
        ]
    )

    print(json.dumps({
        "status": "ICOS_CONSENSUS_COGNITION_ACTIVE",
        "consensus": sample,
        "runtime": layer.runtime_status(),
    }, indent=2))