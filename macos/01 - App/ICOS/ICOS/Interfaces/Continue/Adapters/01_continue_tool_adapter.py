# ============================================================
# ICOS · Continue Tool Adapter
# ============================================================

from pathlib import Path
from typing import Any
import json

# ============================================================
# Runtime Paths
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

CONTINUE_ROOT = ROOT / "Interfaces" / "Continue"
REGISTRY_ROOT = CONTINUE_ROOT / "Registries"

# ============================================================
# Continue Tool Adapter
# ============================================================

class ContinueToolAdapter:
    """
    Sovereign ICOS tool bridge for Continue.

    Responsibilities:
    - register tools
    - expose callable tool inventory
    - maintain tool metadata
    - provide future MCP compatibility
    - isolate interface-layer tool ownership
    """

    def __init__(self) -> None:
        self.registry_path = REGISTRY_ROOT / "continue_tool_registry.json"

        self.registry: dict[str, Any] = {
            "runtime": "ICOS",
            "version": "1.0",
            "tools": []
        }

    # ========================================================
    # Registry Loading
    # ========================================================

    def load_registry(self) -> dict[str, Any]:
        if self.registry_path.exists():
            self.registry = json.loads(
                self.registry_path.read_text()
            )

        else:
            self.save_registry()

        return self.registry

    # ========================================================
    # Registry Persistence
    # ========================================================

    def save_registry(self) -> None:
        self.registry_path.write_text(
            json.dumps(self.registry, indent=2)
        )

    # ========================================================
    # Tool Registration
    # ========================================================

    def register_tool(
        self,
        name: str,
        description: str,
        route: str,
        enabled: bool = True,
    ) -> dict[str, Any]:

        self.load_registry()

        tool_record = {
            "name": name,
            "description": description,
            "route": route,
            "enabled": enabled,
        }

        existing = [
            t for t in self.registry["tools"]
            if t["name"] == name
        ]

        if existing:
            self.registry["tools"] = [
                tool_record if t["name"] == name else t
                for t in self.registry["tools"]
            ]

        else:
            self.registry["tools"].append(tool_record)

        self.save_registry()

        return tool_record

    # ========================================================
    # Tool Lookup
    # ========================================================

    def get_tool(self, name: str) -> dict[str, Any] | None:
        self.load_registry()

        for tool in self.registry["tools"]:
            if tool["name"] == name:
                return tool

        return None

    # ========================================================
    # Tool Inventory
    # ========================================================

    def list_tools(self) -> list[dict[str, Any]]:
        self.load_registry()

        return self.registry.get("tools", [])

    # ========================================================
    # Runtime Status
    # ========================================================

    def get_status(self) -> dict[str, Any]:
        self.load_registry()

        return {
            "runtime": "Continue",
            "registry": str(self.registry_path),
            "tool_count": len(self.registry.get("tools", [])),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    adapter = ContinueToolAdapter()

    adapter.register_tool(
        name="strategic_analysis",
        description="Strategic cognitive analysis engine",
        route="Cognition/Engines/01_strategic_analysis_engine.py",
    )

    print(json.dumps({
        "status": "CONTINUE_TOOL_ADAPTER_READY",
        "tools": adapter.list_tools(),
        "runtime_status": adapter.get_status(),
    }, indent=2))