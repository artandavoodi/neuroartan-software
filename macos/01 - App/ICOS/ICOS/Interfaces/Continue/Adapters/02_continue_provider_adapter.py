# ============================================================
# ICOS · Continue Provider Adapter
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

PROVIDER_ROOT = ROOT / "Providers"
MODEL_ROOT = ROOT / "Models"

# ============================================================
# Continue Provider Adapter
# ============================================================

class ContinueProviderAdapter:
    """
    Sovereign provider bridge between Continue and ICOS.

    Responsibilities:
    - expose provider routing
    - expose local LM Studio compatibility
    - expose model availability
    - maintain sovereign provider ownership
    - prepare future multi-provider orchestration
    """

    def __init__(self) -> None:
        self.runtime_config_path = CONFIG_ROOT / "continue_runtime_config.json"

        self.runtime_config: dict[str, Any] = {}

        self.providers = {
            "lmstudio": {
                "enabled": True,
                "local": True,
                "runtime": "openai-compatible",
                "default_model": "local-model",
            }
        }

    # ========================================================
    # Runtime Config
    # ========================================================

    def load_runtime_config(self) -> dict[str, Any]:
        if self.runtime_config_path.exists():
            self.runtime_config = json.loads(
                self.runtime_config_path.read_text()
            )

        else:
            self.runtime_config = {
                "provider": "lmstudio",
                "local_only": True,
                "sovereign_mode": True,
            }

            self.runtime_config_path.write_text(
                json.dumps(self.runtime_config, indent=2)
            )

        return self.runtime_config

    # ========================================================
    # Provider Access
    # ========================================================

    def get_provider(self, name: str) -> dict[str, Any] | None:
        return self.providers.get(name)

    def list_providers(self) -> dict[str, Any]:
        return self.providers

    # ========================================================
    # Runtime Provider
    # ========================================================

    def get_active_provider(self) -> dict[str, Any] | None:
        self.load_runtime_config()

        provider_name = self.runtime_config.get("provider", "lmstudio")

        return self.get_provider(provider_name)

    # ========================================================
    # Runtime Status
    # ========================================================

    def get_status(self) -> dict[str, Any]:
        active = self.get_active_provider()

        return {
            "provider_root": str(PROVIDER_ROOT),
            "model_root": str(MODEL_ROOT),
            "active_provider": active,
            "provider_count": len(self.providers),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    adapter = ContinueProviderAdapter()

    print(json.dumps({
        "status": "CONTINUE_PROVIDER_ADAPTER_READY",
        "providers": adapter.list_providers(),
        "runtime_status": adapter.get_status(),
    }, indent=2))