# ============================================================
# ICOS · Continue Runtime Adapter
# ============================================================

from pathlib import Path
from typing import Any
import json


# ============================================================
# Runtime Paths
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

CONTINUE_ROOT = ROOT / "Interfaces" / "Continue"
CONFIG_ROOT = CONTINUE_ROOT / "Config"
REGISTRY_ROOT = CONTINUE_ROOT / "Registries"


# ============================================================
# Continue Runtime Adapter
# ============================================================

class ContinueRuntimeAdapter:
    """
    Sovereign interface bridge between Continue and ICOS.

    Responsibilities:
    - load Continue runtime configuration
    - expose runtime status
    - expose registry access
    - expose provider access
    - expose cognition/runtime routing
    - maintain sovereign ownership boundaries
    """

    def __init__(self) -> None:
        self.runtime_config_path = CONFIG_ROOT / "continue_runtime_config.json"
        self.tool_registry_path = REGISTRY_ROOT / "continue_tool_registry.json"

        self.runtime_config: dict[str, Any] = {}
        self.tool_registry: dict[str, Any] = {}

        self.runtime_state = {
            "initialized": False,
            "config_loaded": False,
            "registry_loaded": False,
        }


    # ========================================================
    # Runtime Initialization
    # ========================================================

    def initialize(self) -> dict[str, Any]:
        self.load_runtime_config()
        self.load_tool_registry()

        self.runtime_state["initialized"] = True

        return self.runtime_state


    # ========================================================
    # Configuration
    # ========================================================

    def load_runtime_config(self) -> dict[str, Any]:
        if not self.runtime_config_path.exists():
            self.runtime_config = {
                "runtime": "continue",
                "provider": "lmstudio",
                "local_only": True,
                "sovereign_mode": True,
            }

            self.runtime_config_path.write_text(
                json.dumps(self.runtime_config, indent=2)
            )

        else:
            self.runtime_config = json.loads(
                self.runtime_config_path.read_text()
            )

        self.runtime_state["config_loaded"] = True

        return self.runtime_config


    # ========================================================
    # Registry
    # ========================================================

    def load_tool_registry(self) -> dict[str, Any]:
        if not self.tool_registry_path.exists():
            self.tool_registry = {
                "tools": [],
                "version": "1.0",
                "runtime": "ICOS",
            }

            self.tool_registry_path.write_text(
                json.dumps(self.tool_registry, indent=2)
            )

        else:
            self.tool_registry = json.loads(
                self.tool_registry_path.read_text()
            )

        self.runtime_state["registry_loaded"] = True

        return self.tool_registry


    # ========================================================
    # Runtime Status
    # ========================================================

    def get_runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "Continue",
            "provider": self.runtime_config.get("provider", "unknown"),
            "initialized": self.runtime_state["initialized"],
            "config_loaded": self.runtime_state["config_loaded"],
            "registry_loaded": self.runtime_state["registry_loaded"],
            "tool_count": len(self.tool_registry.get("tools", [])),
            "root": str(ROOT),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    adapter = ContinueRuntimeAdapter()

    state = adapter.initialize()

    print(json.dumps({
        "status": "CONTINUE_RUNTIME_INITIALIZED",
        "state": state,
        "runtime_status": adapter.get_runtime_status(),
    }, indent=2))