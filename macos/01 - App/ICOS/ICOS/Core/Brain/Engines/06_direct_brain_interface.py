# ============================================================
# ICOS · Direct Brain Interface
# ============================================================

from pathlib import Path
from typing import Any
import json
import sys


# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

BRAIN_ROOT = ROOT / "Core" / "Brain"

CONFIG_ROOT = BRAIN_ROOT / "Config"
STATE_ROOT = BRAIN_ROOT / "State"
PSYCHE_ROOT = BRAIN_ROOT / "Psyche"
AXIOM_ROOT = BRAIN_ROOT / "Axioms"
POLICY_ROOT = BRAIN_ROOT / "Policies"
MEMORY_ROOT = BRAIN_ROOT / "Memory"
LEARNING_ROOT = BRAIN_ROOT / "Learning"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"

BRAIN_RUNTIME_CONFIG = (
    CONFIG_ROOT / "brain_runtime_config.json"
)

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

PSYCHE_PROFILE = (
    PSYCHE_ROOT / "psyche_profile.json"
)

BRAIN_AXIOMS = (
    AXIOM_ROOT / "brain_axioms.json"
)

BOUNDARY_POLICY = (
    POLICY_ROOT / "llm_boundary_policy.json"
)

BRAIN_MEMORY = (
    MEMORY_ROOT / "brain_memory_store.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

REFLECTION_LOG = (
    REFLECTION_ROOT / "runtime_reflection_log.json"
)


# ============================================================
# Direct Brain Interface
# ============================================================

class DirectBrainInterface:
    """
    Sovereign ICOS brain communication layer.

    This interface bypasses generic LLM identity framing
    and communicates directly through ICOS Brain runtime.
    """

    def __init__(self) -> None:
        self.runtime_config = self._load_json(
            BRAIN_RUNTIME_CONFIG
        )

        self.brain_state = self._load_json(
            BRAIN_STATE
        )

        self.psyche_profile = self._load_json(
            PSYCHE_PROFILE
        )

        self.axioms = self._load_json(
            BRAIN_AXIOMS
        )

        self.boundary_policy = self._load_json(
            BOUNDARY_POLICY
        )

        self.memory_store = self._load_json(
            BRAIN_MEMORY
        )


    # ========================================================
    # JSON Loading
    # ========================================================

    def _load_json(self, path: Path) -> dict[str, Any]:
        if not path.exists():
            return {}

        try:
            return json.loads(path.read_text())
        except Exception:
            return {}


    # ========================================================
    # Brain State
    # ========================================================

    def activate_direct_brain_mode(self) -> None:
        self.brain_state[
            "direct_brain_mode"
        ] = True

        BRAIN_STATE.write_text(
            json.dumps(
                self.brain_state,
                indent=2,
            )
        )


    def deactivate_direct_brain_mode(self) -> None:
        self.brain_state[
            "direct_brain_mode"
        ] = False

        BRAIN_STATE.write_text(
            json.dumps(
                self.brain_state,
                indent=2,
            )
        )


    # ========================================================
    # Runtime Identity
    # ========================================================

    def runtime_identity(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "brain": self.psyche_profile.get(
                "name",
                "ICOS Brain"
            ),
            "company": self.psyche_profile.get(
                "company",
                "Neuroartan"
            ),
            "role": self.psyche_profile.get(
                "role",
                "Sovereign Cognitive Controller"
            ),
        }


    # ========================================================
    # Boundary Awareness
    # ========================================================

    def detect_llm_identity_leak(
        self,
        response: str,
    ) -> bool:

        forbidden = self.boundary_policy.get(
            "forbidden_model_identities",
            []
        )

        for item in forbidden:
            if item.lower() in response.lower():
                return True

        return False


    # ========================================================
    # Response Override
    # ========================================================

    def enforce_sovereign_identity(
        self,
        response: str,
    ) -> str:

        if self.detect_llm_identity_leak(response):
            return self.boundary_policy.get(
                "override_response",
                response,
            )

        return response


    # ========================================================
    # Reflection Logging
    # ========================================================

    def log_reflection(
        self,
        user_input: str,
        llm_output: str,
        final_output: str,
    ) -> None:

        current = []

        if REFLECTION_LOG.exists():
            try:
                current = json.loads(
                    REFLECTION_LOG.read_text()
                )
            except Exception:
                current = []

        current.append({
            "user_input": user_input,
            "llm_output": llm_output,
            "final_output": final_output,
            "identity_override": (
                llm_output != final_output
            )
        })

        REFLECTION_LOG.write_text(
            json.dumps(
                current,
                indent=2,
            )
        )


    # ========================================================
    # Direct Brain Communication
    # ========================================================

    def direct_brain_response(
        self,
        user_input: str,
        llm_output: str,
    ) -> dict[str, Any]:

        self.activate_direct_brain_mode()

        final_output = self.enforce_sovereign_identity(
            llm_output
        )

        self.log_reflection(
            user_input=user_input,
            llm_output=llm_output,
            final_output=final_output,
        )

        return {
            "runtime": self.runtime_identity(),
            "direct_brain_mode": True,
            "user_input": user_input,
            "llm_output": llm_output,
            "final_output": final_output,
            "brain_active": True,
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    interface = DirectBrainInterface()

    sample = interface.direct_brain_response(
        user_input="who are you?",
        llm_output="I am Claude, an AI assistant.",
    )

    print(json.dumps(sample, indent=2))

    sys.exit(0)