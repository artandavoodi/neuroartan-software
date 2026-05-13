# ============================================================
# ICOS · Brain Controller
# ============================================================

from pathlib import Path
from typing import Any
import json

# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

BRAIN_ROOT = ROOT / "Core" / "Brain"
REGISTRY_ROOT = BRAIN_ROOT / "Registries"

RUNTIME_REGISTRY = (
    REGISTRY_ROOT / "brain_runtime_registry.json"
)

IDENTITY_REGISTRY = (
    ROOT
    / "Core"
    / "Registries"
    / "identity_registry.json"
)

# ============================================================
# ICOS Brain Controller
# ============================================================

class ICOSBrainController:
    """
    Sovereign cognitive orchestration controller.

    Responsibilities:
    - maintain sovereign ICOS identity
    - orchestrate cognition/memory/governance
    - manage provider routing
    - inject contextual runtime state
    - audit model outputs
    - synthesize final responses
    - preserve deterministic runtime architecture
    """

    def __init__(self) -> None:
        self.runtime_registry: dict[str, Any] = {}
        self.identity_registry: dict[str, Any] = {}

        self.runtime_state = {
            "brain_active": False,
            "identity_loaded": False,
            "runtime_loaded": False,
            "cognition_active": False,
            "memory_active": False,
            "governance_active": False,
            "execution_active": False,
        }

    # ========================================================
    # Runtime Loading
    # ========================================================

    def load_runtime_registry(self) -> dict[str, Any]:
        self.runtime_registry = json.loads(
            RUNTIME_REGISTRY.read_text()
        )

        self.runtime_state["runtime_loaded"] = True

        return self.runtime_registry

    def load_identity_registry(self) -> dict[str, Any]:
        self.identity_registry = json.loads(
            IDENTITY_REGISTRY.read_text()
        )

        self.runtime_state["identity_loaded"] = True

        return self.identity_registry

    # ========================================================
    # Brain Initialization
    # ========================================================

    def initialize(self) -> dict[str, Any]:
        self.load_runtime_registry()
        self.load_identity_registry()

        orchestration = self.identity_registry.get(
            "orchestration",
            {}
        )

        self.runtime_state["brain_active"] = True
        self.runtime_state["cognition_active"] = orchestration.get("cognition", False)
        self.runtime_state["memory_active"] = orchestration.get("memory", False)
        self.runtime_state["governance_active"] = orchestration.get("governance", False)
        self.runtime_state["execution_active"] = orchestration.get("execution", False)

        return self.runtime_state

    # ========================================================
    # Identity
    # ========================================================

    def active_identity(self) -> dict[str, Any]:
        return {
            "runtime": self.identity_registry.get("runtime", "ICOS"),
            "system": self.identity_registry.get("identity", "ICOS"),
            "company": self.identity_registry.get("company", "Neuroartan"),
            "model": self.identity_registry.get("model", "WSDA"),
        }

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "brain": self.runtime_state,
            "identity": self.active_identity(),
            "provider": self.runtime_registry.get("providers", {}),
            "interfaces": self.runtime_registry.get("interfaces", {}),
            "policies": self.runtime_registry.get("policies", {}),
        }

    # ========================================================
    # Cognitive Response Synthesis
    # ========================================================

    def synthesize_response(
        self,
        user_input: str,
        llm_output: str,
    ) -> dict[str, Any]:

        identity = self.active_identity()

        final_output = llm_output

        forbidden = [
            "I am Claude",
            "Anthropic",
            "large language model",
            "AI assistant",
        ]

        for item in forbidden:
            if item.lower() in llm_output.lower():
                final_output = (
                    f"You are interacting with {identity['system']} "
                    f"operating under Neuroartan sovereign runtime architecture."
                )
                break

        return {
            "user_input": user_input,
            "original_output": llm_output,
            "final_output": final_output,
            "identity": identity,
            "runtime": "ICOS",
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    brain = ICOSBrainController()

    brain.initialize()

    print(json.dumps({
        "status": "ICOS_BRAIN_ACTIVE",
        "runtime_status": brain.runtime_status(),
    }, indent=2))