# ============================================================
# ICOS · Provider Arbitration Layer
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

REGISTRY_ROOT = BRAIN_ROOT / "Registries"
CONFIG_ROOT = BRAIN_ROOT / "Config"
STATE_ROOT = BRAIN_ROOT / "State"
LEARNING_ROOT = BRAIN_ROOT / "Learning"

RUNTIME_REGISTRY = (
    REGISTRY_ROOT / "brain_runtime_registry.json"
)

BRAIN_CONFIG = (
    CONFIG_ROOT / "brain_runtime_config.json"
)

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

# ============================================================
# Provider Arbitration Layer
# ============================================================

class ProviderArbitrationLayer:
    """
    ICOS provider arbitration engine.

    Responsibilities:
    - select optimal provider/model
    - preserve sovereign ICOS control
    - treat LLMs as replaceable processors
    - observe provider behavior
    - learn from model responses
    - support future multi-model cognition
    """

    def __init__(self) -> None:
        self.runtime_registry = self._load_json(
            RUNTIME_REGISTRY
        )

        self.brain_config = self._load_json(
            BRAIN_CONFIG
        )

        self.brain_state = self._load_json(
            BRAIN_STATE
        )

        self.providers = {
            "LMStudio": {
                "local": True,
                "latency": "low",
                "privacy": "high",
                "reasoning": "medium",
                "coding": "high",
                "creative": "medium",
            },
            "OpenAI": {
                "local": False,
                "latency": "medium",
                "privacy": "medium",
                "reasoning": "high",
                "coding": "high",
                "creative": "high",
            },
            "Gemini": {
                "local": False,
                "latency": "medium",
                "privacy": "medium",
                "reasoning": "high",
                "coding": "medium",
                "creative": "medium",
            },
            "Qwen": {
                "local": True,
                "latency": "low",
                "privacy": "high",
                "reasoning": "medium",
                "coding": "high",
                "creative": "medium",
            },
        }

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
    # Arbitration
    # ========================================================

    def select_provider(
        self,
        task_type: str,
    ) -> dict[str, Any]:

        task_type = task_type.lower()

        if task_type in [
            "coding",
            "engineering",
            "architecture",
            "runtime",
        ]:
            selected = "LMStudio"

        elif task_type in [
            "reasoning",
            "research",
            "analysis",
        ]:
            selected = "OpenAI"

        elif task_type in [
            "creative",
            "writing",
            "language",
        ]:
            selected = "Gemini"

        else:
            selected = self.runtime_registry.get(
                "providers",
                {}
            ).get(
                "active_provider",
                "LMStudio"
            )

        self.brain_state[
            "last_mounted_model"
        ] = selected

        BRAIN_STATE.write_text(
            json.dumps(
                self.brain_state,
                indent=2,
            )
        )

        return {
            "selected_provider": selected,
            "provider_profile": self.providers.get(
                selected,
                {}
            ),
            "runtime": "ICOS",
            "timestamp": time.time(),
        }

    # ========================================================
    # Learning Observation
    # ========================================================

    def observe_model_response(
        self,
        provider: str,
        user_input: str,
        model_output: str,
    ) -> None:

        current = []

        if LEARNING_LOG.exists():
            try:
                current = json.loads(
                    LEARNING_LOG.read_text()
                )
            except Exception:
                current = []

        current.append({
            "provider": provider,
            "user_input": user_input,
            "model_output": model_output,
            "timestamp": time.time(),
        })

        LEARNING_LOG.write_text(
            json.dumps(
                current,
                indent=2,
            )
        )

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "brain_active": True,
            "provider_arbitration": True,
            "providers": list(self.providers.keys()),
            "active_provider": self.brain_state.get(
                "last_mounted_model"
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    arbitration = ProviderArbitrationLayer()

    sample = arbitration.select_provider(
        task_type="coding"
    )

    arbitration.observe_model_response(
        provider=sample["selected_provider"],
        user_input="Build runtime architecture",
        model_output="Runtime architecture generated.",
    )

    print(json.dumps({
        "status": "ICOS_PROVIDER_ARBITRATION_ACTIVE",
        "selection": sample,
        "runtime": arbitration.runtime_status(),
    }, indent=2))