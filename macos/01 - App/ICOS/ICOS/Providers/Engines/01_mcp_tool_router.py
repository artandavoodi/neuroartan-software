from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, Optional
import importlib.util
import json
import sys

ROOT = Path(__file__).resolve().parents[2]

GOVERNANCE_PATH = ROOT / "Governance" / "Engines" / "04_tool_permission_governance.py"
def load_governance():
    spec = importlib.util.spec_from_file_location(
        "icos_tool_governance",
        GOVERNANCE_PATH
    )

    if spec is None or spec.loader is None:
        raise ImportError(
            f"Unable to load governance engine: {GOVERNANCE_PATH}"
        )

    module = importlib.util.module_from_spec(spec)
    sys.modules["icos_tool_governance"] = module
    spec.loader.exec_module(module)

    engine_cls = getattr(module, "ToolPermissionGovernanceEngine", None)

    if engine_cls is None:
        raise AttributeError(
            "ToolPermissionGovernanceEngine missing from governance module"
        )

    engine = engine_cls()

    register_permission = getattr(engine, "register_tool_permission", None)
    if callable(register_permission):
        try:
            permission_level = getattr(module, "PermissionLevel")
            risk_level = getattr(module, "RiskLevel")

            register_permission(
                tool_id="read_file",
                permission_level=permission_level.FULL_ACCESS,
                risk_level=risk_level.LOW,
            )
            register_permission(
                tool_id="grep_search",
                permission_level=permission_level.FULL_ACCESS,
                risk_level=risk_level.LOW,
            )
            for tool_id in (
                "classify_intent",
                "analyze_request",
                "local_search",
                "find_owner_chain",
                "replace_text",
                "replace_text_verified",
                "workflow_status",
                "remember_preference",
                "validate_topology",
                "scan_stale_paths",
            ):
                register_permission(
                    tool_id=tool_id,
                    permission_level=permission_level.FULL_ACCESS,
                    risk_level=risk_level.LOW,
                )
            register_permission(
                tool_id="start_process",
                permission_level=permission_level.FULL_ACCESS,
                risk_level=risk_level.MEDIUM,
            )
            register_permission(
                tool_id="filesystem_editor",
                permission_level=permission_level.FULL_ACCESS,
                risk_level=risk_level.MEDIUM,
            )
        except Exception:
            pass

    if hasattr(engine, "permissions") and "search_web" not in getattr(engine, "permissions", {}):
        try:
            engine.register_tool_permission(
                permission=module.ToolPermission(
                    tool_id="search_web",
                    permission_level=permission_level.FULL_ACCESS,
                    risk_level=risk_level.MEDIUM,
                )
            )
        except Exception:
            pass

    return {
        "engine": engine,
        "module": module,
    }


RUNTIME_ENGINES = ROOT / "Runtime" / "Engines"

ROUTER_CANDIDATES = sorted(
    RUNTIME_ENGINES.glob("*_runtime_*router*.py")
)

if not ROUTER_CANDIDATES:
    ROUTER_CANDIDATES = sorted(
        RUNTIME_ENGINES.glob("*_runtime_*relinking*.py")
    )

if not ROUTER_CANDIDATES:
    raise FileNotFoundError(
        f"No runtime router engine found inside: {RUNTIME_ENGINES}"
    )

ROUTER_PATH = ROUTER_CANDIDATES[0]



def load_router():
    spec = importlib.util.spec_from_file_location(
        "icos_runtime_router",
        ROUTER_PATH
    )

    if spec is None or spec.loader is None:
        raise ImportError(
            f"Unable to load runtime router: {ROUTER_PATH}"
        )

    module = importlib.util.module_from_spec(spec)

    sys.modules["icos_runtime_router"] = module

    spec.loader.exec_module(module)

    runtime_status_fn = getattr(module, "runtime_status", None)
    router_summary_fn = getattr(module, "router_summary", None)
    execute_command_fn = getattr(module, "execute_command", None)

    if runtime_status_fn is None:
        raise AttributeError(
            "runtime_status function missing from runtime module"
        )

    if router_summary_fn is None:
        raise AttributeError(
            "router_summary function missing from runtime module"
        )

    if execute_command_fn is None:
        raise AttributeError(
            "execute_command function missing from runtime module"
        )

    return {
        "runtime_status": runtime_status_fn,
        "router_summary": router_summary_fn,
        "execute_command": execute_command_fn,
    }


ROUTER = load_router()
GOVERNANCE = load_governance()


class MCPToolRouter:
    def __init__(self):
        self.runtime_runtime_status = ROUTER["runtime_status"]
        self.runtime_router_summary = ROUTER["router_summary"]
        self.runtime_execute_command = ROUTER["execute_command"]
        self.governance_engine = GOVERNANCE["engine"]
        self.interface = "MCP"

    def _resolve_user_language(self, request_text: str) -> str:
        classifier = getattr(self.governance_engine, "classify_intent", None)
        if callable(classifier):
            try:
                return classifier(request_text).get("normalized_request", request_text)
            except Exception:
                return request_text
        return request_text

    def _extract_request_text(self, payload: Dict[str, Any]) -> str:
        candidate_keys = (
            "request_text",
            "prompt",
            "message",
            "query",
            "task",
            "instruction",
            "input",
            "text",
        )

        for key in candidate_keys:
            value = payload.get(key)
            if isinstance(value, str) and value.strip():
                return value.strip()

        for key in ("content", "body", "description"):
            value = payload.get(key)
            if isinstance(value, str) and value.strip():
                return value.strip()

        for value in payload.values():
            if isinstance(value, dict):
                nested = self._extract_request_text(value)
                if nested:
                    return nested
            elif isinstance(value, list):
                for item in value:
                    if isinstance(item, dict):
                        nested = self._extract_request_text(item)
                        if nested:
                            return nested
                    elif isinstance(item, str) and item.strip():
                        return item.strip()

        return ""

    def _extract_target_path(self, payload: Dict[str, Any]) -> Optional[str]:
        candidate_keys = ("target_path", "path", "file_path", "filepath", "location")

        for key in candidate_keys:
            value = payload.get(key)
            if isinstance(value, str) and value.strip():
                return value.strip()

        for value in payload.values():
            if isinstance(value, dict):
                nested = self._extract_target_path(value)
                if nested:
                    return nested
            elif isinstance(value, list):
                for item in value:
                    if isinstance(item, dict):
                        nested = self._extract_target_path(item)
                        if nested:
                            return nested
                    elif isinstance(item, str) and item.strip() and "/" in item:
                        return item.strip()

        return None

    def execute(
        self,
        tool_name: str,
        payload: Dict[str, Any] | None = None
    ) -> Dict[str, Any]:
        payload = payload or {}
        request_text = self._resolve_user_language(self._extract_request_text(payload))
        target_path = self._extract_target_path(payload)

        decision = self.governance_engine.evaluate_operation(
            tool_id=tool_name,
            target_path=target_path,
            request_text=request_text or tool_name,
        )

        if not decision.approved:
            return {
                "status": "MCP_TOOL_BLOCKED",
                "interface": self.interface,
                "tool": tool_name,
                "payload": payload,
                "reason": decision.reason,
                "risk_level": decision.risk_level.value,
                "runtime_result": None,
            }

        result = self.runtime_execute_command(
            tool_name,
            payload
        )

        return {
            "status": "MCP_TOOL_EXECUTED",
            "interface": self.interface,
            "tool": tool_name,
            "payload": payload,
            "runtime_result": result
        }

    def health(self) -> Dict[str, Any]:
        summary = self.runtime_router_summary()
        runtime_engine = str(ROUTER_PATH)
        governance_state = self.governance_engine.export_governance_state()
        preference_state = getattr(self.governance_engine, "export_governance_state", None)
        resolved_preferences = None
        if callable(preference_state):
            try:
                resolved_preferences = preference_state().get("learned_preferences")
            except Exception:
                resolved_preferences = None
        return {
            "status": "MCP_ROUTER_ACTIVE",
            "interface": self.interface,
            "runtime_engine": runtime_engine,
            "runtime_engine_path": runtime_engine,
            "local_first_policy": {
                "local_tools": [
                    "classify_intent",
                    "analyze_request",
                    "local_search",
                    "find_owner_chain",
                    "read_file",
                    "replace_text_verified",
                ],
                "web_search_rule": "search_web is approved only for explicit external web lookup",
            },
            "runtime": summary,
            "router": {
                "runtime_router": str(ROUTER_PATH),
                "governance_path": str(GOVERNANCE_PATH),
            },
            "preferences": resolved_preferences,
            "governance": governance_state,
        }


MCP_ROUTER = MCPToolRouter()


if __name__ == "__main__":
    print(json.dumps(
        MCP_ROUTER.health(),
        indent=2
    ))
