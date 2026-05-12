# ============================================================
# ICOS · Recursive Reflection Engine
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

STATE_ROOT = BRAIN_ROOT / "State"
LEARNING_ROOT = BRAIN_ROOT / "Learning"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"
POLICY_ROOT = BRAIN_ROOT / "Policies"

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

REFLECTION_LOG = (
    REFLECTION_ROOT / "runtime_reflection_log.json"
)

BOUNDARY_POLICY = (
    POLICY_ROOT / "llm_boundary_policy.json"
)


# ============================================================
# Recursive Reflection Engine
# ============================================================

class RecursiveReflectionEngine:
    """
    ICOS recursive self-reflection system.

    Responsibilities:
    - inspect provider behavior
    - detect identity drift
    - analyze cognition quality
    - monitor runtime coherence
    - observe learning patterns
    - generate recursive runtime reflection
    """

    def __init__(self) -> None:
        self.brain_state = self._load_json(
            BRAIN_STATE
        )

        self.learning_log = self._load_json(
            LEARNING_LOG,
            fallback=[]
        )

        self.reflection_log = self._load_json(
            REFLECTION_LOG,
            fallback=[]
        )

        self.boundary_policy = self._load_json(
            BOUNDARY_POLICY
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
            return fallback if fallback is not None else {}

        try:
            return json.loads(path.read_text())
        except Exception:
            return fallback if fallback is not None else {}


    # ========================================================
    # Identity Drift Detection
    # ========================================================

    def detect_identity_drift(self) -> dict[str, Any]:
        forbidden = self.boundary_policy.get(
            "forbidden_model_identities",
            []
        )

        drift_events = []

        for item in self.reflection_log:
            output = item.get("llm_output", "")

            for forbidden_identity in forbidden:
                if forbidden_identity.lower() in output.lower():
                    drift_events.append({
                        "forbidden_identity": forbidden_identity,
                        "output": output,
                    })

        return {
            "identity_drift_detected": len(drift_events) > 0,
            "drift_events": drift_events,
            "total_events": len(drift_events),
        }


    # ========================================================
    # Learning Quality
    # ========================================================

    def learning_quality(self) -> dict[str, Any]:
        providers = {}

        for item in self.learning_log:
            provider = item.get("provider")

            if provider is None:
                continue

            providers.setdefault(provider, 0)
            providers[provider] += 1

        return {
            "providers_observed": providers,
            "learning_events": len(self.learning_log),
        }


    # ========================================================
    # Runtime Reflection
    # ========================================================

    def recursive_reflection(self) -> dict[str, Any]:
        drift = self.detect_identity_drift()
        learning = self.learning_quality()

        coherence = (
            not drift["identity_drift_detected"]
        )

        reflection = {
            "runtime": "ICOS",
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "recursive_reflection": True,
            "identity_coherence": coherence,
            "identity_drift": drift,
            "learning": learning,
            "timestamp": time.time(),
        }

        self.reflection_log.append(reflection)

        REFLECTION_LOG.write_text(
            json.dumps(
                self.reflection_log,
                indent=2,
            )
        )

        return reflection


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = RecursiveReflectionEngine()

    reflection = engine.recursive_reflection()

    print(json.dumps({
        "status": "ICOS_RECURSIVE_REFLECTION_ACTIVE",
        "reflection": reflection,
    }, indent=2))