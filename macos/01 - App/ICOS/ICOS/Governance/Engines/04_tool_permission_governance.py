"""
ICOS Tool Permission Governance Engine

Canonical Responsibility:
- tool permission governance
- execution authorization
- runtime safety boundaries
- tool-access policy enforcement
- capability restrictions
- governance verification
- execution-risk classification

IMPORTANT:
This layer owns governance authority.
It does NOT own:
- cognition
- provider intelligence
- interfaces
- memory continuity
- raw execution infrastructure
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional
import json


class PermissionLevel(str, Enum):
    DENIED = "denied"
    READ_ONLY = "read_only"
    LIMITED_WRITE = "limited_write"
    FULL_ACCESS = "full_access"


class RiskLevel(str, Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"


class ToolCategory(str, Enum):
    LOCAL_REPO = "local_repo"
    FILESYSTEM = "filesystem"
    MCP = "mcp"
    WEB = "web"
    UNKNOWN = "unknown"


@dataclass
class ToolPermission:
    tool_id: str
    permission_level: PermissionLevel
    risk_level: RiskLevel
    allowed_paths: List[str] = field(default_factory=list)
    blocked_paths: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)
    category: ToolCategory = ToolCategory.UNKNOWN


@dataclass
class GovernanceDecision:
    tool_id: str
    approved: bool
    reason: str
    risk_level: RiskLevel
    metadata: Dict[str, Any] = field(default_factory=dict)


class ToolPermissionGovernanceEngine:
    """
    Sovereign governance authority.

    Responsibilities:
    - permission enforcement
    - execution authorization
    - risk classification
    - governance validation
    - tool-access restrictions
    - runtime safety enforcement
    """

    def __init__(self) -> None:
        self.permissions: Dict[str, ToolPermission] = {}
        self.local_repo_roots: List[str] = [
            "/Users/artan/Documents/Neuroartan",
            "/Users/artan/Neuroartan-software",
            "/Users/artan/.continue",
        ]
        self.memory_root = Path("/Users/artan/.continue/icos_runtime_memory")
        self.preference_store_path = self.memory_root / "preference_registry.json"
        self.workflow_store_path = self.memory_root / "workflow_ledger.json"
        self.request_aliases: Dict[str, List[str]] = {
            "local_repo": [
                "website",
                "homepage",
                "software",
                "platform",
                "repo",
                "repository",
                "local",
                "file",
                "files",
                "code",
                "edit",
                "fix",
                "change",
                "replace",
                "scan",
                "audit",
                "find",
                "open",
            ],
            "web": [
                "search the web",
                "browse the web",
                "web search",
                "search web",
                "latest",
                "current",
                "news",
                "today",
            ],
        }
        self.preference_aliases: Dict[str, List[str]] = {
            "website": ["website", "homepage", "platform", "site"],
            "software": ["software", "icos", "macos app", "app"],
            "local_repo": ["repo", "repository", "workspace", "codebase"],
            "web_search": ["web search", "search the web", "browse the web", "search web"],
            "open_file": ["open file", "read file", "inspect file"],
            "edit_file": ["edit file", "change file", "fix file", "replace text", "fix this", "change this", "replace this"],
            "owner_chain": ["owner file", "owner chain", "canonical owner", "source of truth"],
        }
        self.learned_preferences: Dict[str, str] = {}
        self.preference_history: List[Dict[str, str]] = []
        self.workflow_state: Dict[str, Any] = {
            "achieved": [],
            "in_progress": [],
            "blocked": [],
            "current_priority": None,
            "canonical_owner_chains": {},
            "events": [],
        }
        self.runtime_state: Dict[str, Any] = {
            "governance_initialized": True,
            "registered_tools": 0,
            "blocked_operations": 0,
            "approved_operations": 0,
        }
        self._load_memory()
        self._seed_default_preferences()

    def _utc_now(self) -> str:
        return datetime.now(timezone.utc).isoformat()

    def _load_json_file(self, path: Path, default: Dict[str, Any]) -> Dict[str, Any]:
        if not path.exists():
            return dict(default)

        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except Exception:
            return dict(default)

        return payload if isinstance(payload, dict) else dict(default)

    def _write_json_file(self, path: Path, payload: Dict[str, Any]) -> None:
        self.memory_root.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(payload, indent=2, sort_keys=True), encoding="utf-8")

    def _load_memory(self) -> None:
        preference_payload = self._load_json_file(
            self.preference_store_path,
            {"learned_preferences": {}, "preference_history": []},
        )
        workflow_payload = self._load_json_file(
            self.workflow_store_path,
            self.workflow_state,
        )

        learned = preference_payload.get("learned_preferences", {})
        history = preference_payload.get("preference_history", [])

        if isinstance(learned, dict):
            self.learned_preferences.update(
                {
                    self.normalize_request_text(str(alias)): self.normalize_request_text(str(canonical))
                    for alias, canonical in learned.items()
                    if str(alias).strip() and str(canonical).strip()
                }
            )

        if isinstance(history, list):
            self.preference_history = [
                item for item in history
                if isinstance(item, dict)
            ]

        if isinstance(workflow_payload, dict):
            merged = dict(self.workflow_state)
            merged.update(workflow_payload)
            self.workflow_state = merged

    def _save_preferences(self) -> None:
        self._write_json_file(
            self.preference_store_path,
            {
                "updated_at": self._utc_now(),
                "learned_preferences": self.learned_preferences,
                "preference_history": self.preference_history[-200:],
            },
        )

    def _save_workflow_state(self) -> None:
        self._write_json_file(
            self.workflow_store_path,
            {
                **self.workflow_state,
                "updated_at": self._utc_now(),
            },
        )

    def _seed_default_preferences(self) -> None:
        for canonical, aliases in self.preference_aliases.items():
            for alias in aliases:
                alias_key = self.normalize_request_text(alias)
                self.learned_preferences.setdefault(alias_key, canonical)
        self._save_preferences()

    def register_tool_permission(
        self,
        permission: Optional[ToolPermission] = None,
        tool_id: Optional[str] = None,
        permission_level: Optional[PermissionLevel] = None,
        risk_level: Optional[RiskLevel] = None,
        allowed_paths: Optional[List[str]] = None,
        blocked_paths: Optional[List[str]] = None,
        metadata: Optional[Dict[str, Any]] = None,
        category: ToolCategory = ToolCategory.UNKNOWN,
    ) -> None:
        if permission is None:
            if tool_id is None or permission_level is None or risk_level is None:
                raise ValueError(
                    "register_tool_permission requires either a ToolPermission or tool_id, permission_level, and risk_level"
                )

            permission = ToolPermission(
                tool_id=tool_id,
                permission_level=permission_level,
                risk_level=risk_level,
                allowed_paths=allowed_paths or [],
                blocked_paths=blocked_paths or [],
                metadata=metadata or {},
                category=category,
            )

        self.permissions[permission.tool_id] = permission
        self.runtime_state["registered_tools"] = len(self.permissions)

    def normalize_request_text(self, request_text: str) -> str:
        normalized = (request_text or "").strip().lower()
        normalized = normalized.replace("“", '"').replace("”", '"').replace("’", "'")
        normalized = " ".join(normalized.split())
        return normalized

    def register_preference(
        self,
        alias: str,
        canonical: str,
    ) -> None:
        alias_key = self.normalize_request_text(alias)
        canonical_key = self.normalize_request_text(canonical)

        if not alias_key or not canonical_key:
            return

        self.learned_preferences[alias_key] = canonical_key
        self.preference_history.append(
            {
                "alias": alias_key,
                "canonical": canonical_key,
                "timestamp": self._utc_now(),
            }
        )
        self._save_preferences()

    def register_preference_aliases(
        self,
        canonical: str,
        aliases: List[str],
    ) -> None:
        canonical_key = self.normalize_request_text(canonical)

        if not canonical_key:
            return

        for alias in aliases:
            self.register_preference(alias=alias, canonical=canonical_key)

    def resolve_canonical_term(self, value: str) -> str:
        normalized = self.normalize_request_text(value)

        if not normalized:
            return normalized

        if normalized in self.learned_preferences:
            return self.learned_preferences[normalized]

        for canonical, aliases in self.preference_aliases.items():
            if normalized == canonical or normalized in aliases:
                return canonical

        return normalized

    def extract_preference_signals(self, request_text: str) -> Dict[str, List[str]]:
        normalized = self.normalize_request_text(request_text)
        signals: Dict[str, List[str]] = {}

        for alias, canonical in self.learned_preferences.items():
            if alias and alias in normalized:
                signals.setdefault(canonical, []).append(alias)

        for canonical, aliases in self.preference_aliases.items():
            for alias in aliases:
                alias_key = self.normalize_request_text(alias)
                if alias_key and alias_key in normalized:
                    signals.setdefault(canonical, []).append(alias_key)

        return {
            canonical: sorted(set(aliases))
            for canonical, aliases in signals.items()
        }

    def classify_intent(
        self,
        request_text: str,
        target_path: Optional[str] = None,
    ) -> Dict[str, Any]:
        normalized = self.normalize_request_text(request_text)
        signals = self.extract_preference_signals(normalized)
        scope = self.classify_request_scope(
            request_text=normalized,
            target_path=target_path,
        )

        intents: List[str] = []
        if any(marker in normalized for marker in ["replace", "change", "fix", "update", "edit"]):
            intents.append("edit")
        if any(marker in normalized for marker in ["find", "search", "scan", "audit", "owner"]):
            intents.append("local_search")
        if any(marker in normalized for marker in ["owner file", "owner chain", "canonical owner", "source of truth"]):
            intents.append("owner_chain")
        if any(marker in normalized for marker in ["verify", "test", "recheck"]):
            intents.append("verify")
        if not intents:
            intents.append("inspect")

        domain = "unknown"
        if "website" in signals:
            domain = "website"
        elif "software" in signals:
            domain = "software"
        elif "local_repo" in signals:
            domain = "local_repo"
        elif "web_search" in signals and scope == ToolCategory.WEB:
            domain = "external_web"

        route = "local_first"
        if scope == ToolCategory.WEB:
            route = "external_web"
        elif scope == ToolCategory.UNKNOWN:
            route = "local_first_unknown_scope"

        return {
            "normalized_request": normalized,
            "scope": scope.value,
            "domain": domain,
            "intents": intents,
            "alias_signals": signals,
            "route": route,
            "web_allowed": scope == ToolCategory.WEB,
        }

    def classify_request_scope(
        self,
        request_text: str,
        target_path: Optional[str] = None,
    ) -> ToolCategory:
        normalized = self.normalize_request_text(request_text)
        signals = self.extract_preference_signals(normalized)

        if target_path:
            for root in self.local_repo_roots:
                if target_path.startswith(root):
                    return ToolCategory.LOCAL_REPO

        explicit_web_markers = [
            "search the web",
            "browse the web",
            "web search",
            "search web",
            "look up online",
            "external lookup",
            "internet search",
        ]
        explicit_web = any(marker in normalized for marker in explicit_web_markers)

        local_signal_present = any(
            canonical in signals
            for canonical in ("website", "software", "local_repo", "edit_file", "owner_chain", "open_file")
        )

        if explicit_web and not local_signal_present:
            return ToolCategory.WEB

        local_markers = self.request_aliases["local_repo"] + [
            "local file",
            "local files",
            "filesystem",
            "file search",
            "open the file",
            "open file",
            "edit the file",
            "edit file",
            "fix this",
            "fix it",
            "change this",
            "replace this",
            "homepage text",
            "live owner chain",
            "canonical owner",
            "render this text",
            "scan the files",
            "scan the repo",
            "scan repository",
            "terminal",
            "rg ",
            "find ",
            "sed ",
            "in the website",
            "in the homepage",
            "in the software",
            "in the platform",
            "change website",
            "fix website",
            "change software",
            "fix software",
            "change platform",
            "fix platform",
        ]
        if any(marker in normalized for marker in local_markers):
            return ToolCategory.LOCAL_REPO

        web_markers = self.request_aliases["web"] + [
            "browse the internet",
        ]
        if any(marker in normalized for marker in web_markers):
            return ToolCategory.WEB

        return ToolCategory.UNKNOWN

    def should_allow_web_search(
        self,
        request_text: str,
        target_path: Optional[str] = None,
    ) -> bool:
        scope = self.classify_request_scope(request_text=request_text, target_path=target_path)
        return scope == ToolCategory.WEB

    def should_allow_tool(
        self,
        tool_id: str,
        request_text: Optional[str] = None,
        target_path: Optional[str] = None,
    ) -> bool:
        scope = self.classify_request_scope(request_text=request_text or "", target_path=target_path)

        if tool_id == "search_web":
            return scope == ToolCategory.WEB

        local_tool_ids = {
            "filesystem_editor",
            "read_file",
            "grep_search",
            "local_search",
            "find_owner_chain",
            "owner_chain",
            "replace_text",
            "replace_text_verified",
            "classify_intent",
            "workflow_status",
            "remember_preference",
            "start_process",
            "mcp",
            "validate_topology",
            "scan_stale_paths",
        }

        if tool_id in local_tool_ids:
            return scope in {
                ToolCategory.LOCAL_REPO,
                ToolCategory.FILESYSTEM,
                ToolCategory.UNKNOWN,
            }

        return True

    def evaluate_operation(
        self,
        tool_id: str,
        target_path: Optional[str] = None,
        request_text: Optional[str] = None,
    ) -> GovernanceDecision:
        permission = self.permissions.get(tool_id)

        if request_text is not None and not self.should_allow_tool(
            tool_id=tool_id,
            request_text=request_text,
            target_path=target_path,
        ):
            self.runtime_state["blocked_operations"] += 1

            return GovernanceDecision(
                tool_id=tool_id,
                approved=False,
                reason="Tool blocked by local-first governance policy",
                risk_level=RiskLevel.HIGH,
            )

        if permission is None:
            self.runtime_state["blocked_operations"] += 1

            return GovernanceDecision(
                tool_id=tool_id,
                approved=False,
                reason="Tool permission not registered",
                risk_level=RiskLevel.CRITICAL,
            )

        if permission.permission_level == PermissionLevel.DENIED:
            self.runtime_state["blocked_operations"] += 1

            return GovernanceDecision(
                tool_id=tool_id,
                approved=False,
                reason="Tool explicitly denied",
                risk_level=permission.risk_level,
            )

        if target_path:
            for blocked in permission.blocked_paths:
                if blocked in target_path:
                    self.runtime_state["blocked_operations"] += 1

                    return GovernanceDecision(
                        tool_id=tool_id,
                        approved=False,
                        reason="Target path blocked by governance policy",
                        risk_level=permission.risk_level,
                    )

        self.runtime_state["approved_operations"] += 1

        return GovernanceDecision(
            tool_id=tool_id,
            approved=True,
            reason="Operation approved",
            risk_level=permission.risk_level,
        )

    def record_workflow_event(
        self,
        event_type: str,
        detail: Dict[str, Any],
    ) -> None:
        event = {
            "timestamp": self._utc_now(),
            "event_type": self.normalize_request_text(event_type),
            "detail": detail,
        }
        self.workflow_state.setdefault("events", []).append(event)
        self.workflow_state["events"] = self.workflow_state["events"][-300:]
        self._save_workflow_state()

    def register_owner_chain(
        self,
        key: str,
        owner_chain: Dict[str, Any],
    ) -> None:
        normalized_key = self.normalize_request_text(key)
        if not normalized_key:
            return

        self.workflow_state.setdefault("canonical_owner_chains", {})[normalized_key] = {
            "updated_at": self._utc_now(),
            "owner_chain": owner_chain,
        }
        self._save_workflow_state()

    def update_priority(
        self,
        priority: str,
        state: str = "in_progress",
    ) -> None:
        normalized_priority = priority.strip()
        normalized_state = self.normalize_request_text(state)
        if not normalized_priority:
            return

        if normalized_state not in {"achieved", "in_progress", "blocked"}:
            normalized_state = "in_progress"

        self.workflow_state["current_priority"] = normalized_priority
        bucket = self.workflow_state.setdefault(normalized_state, [])
        if normalized_priority not in bucket:
            bucket.append(normalized_priority)
        self._save_workflow_state()

    def validate_runtime_boundaries(self) -> Dict[str, Any]:
        denied = sum(
            1
            for permission in self.permissions.values()
            if permission.permission_level == PermissionLevel.DENIED
        )

        unrestricted = sum(
            1
            for permission in self.permissions.values()
            if permission.permission_level == PermissionLevel.FULL_ACCESS
        )

        return {
            "registered_tools": len(self.permissions),
            "denied_tools": denied,
            "full_access_tools": unrestricted,
            "local_repo_roots": self.local_repo_roots,
            "runtime_state": self.runtime_state,
        }

    def export_governance_state(self) -> Dict[str, Any]:
        return {
            "permissions": [
                {
                    "tool_id": permission.tool_id,
                    "permission_level": permission.permission_level.value,
                    "risk_level": permission.risk_level.value,
                    "allowed_paths": permission.allowed_paths,
                    "blocked_paths": permission.blocked_paths,
                }
                for permission in self.permissions.values()
            ],
            "local_repo_roots": self.local_repo_roots,
            "preference_aliases": self.preference_aliases,
            "learned_preferences": self.learned_preferences,
            "preference_history": self.preference_history,
            "memory_paths": {
                "root": str(self.memory_root),
                "preferences": str(self.preference_store_path),
                "workflow": str(self.workflow_store_path),
            },
            "workflow_state": self.workflow_state,
            "runtime_state": self.runtime_state,
        }


if __name__ == "__main__":
    governance = ToolPermissionGovernanceEngine()

    governance.register_preference_aliases(
        canonical="website",
        aliases=["platform", "homepage", "site"],
    )
    governance.register_preference_aliases(
        canonical="local_repo",
        aliases=["repo", "repository", "workspace", "codebase"],
    )

    governance.register_tool_permission(
        tool_id="read_file",
        permission_level=PermissionLevel.FULL_ACCESS,
        risk_level=RiskLevel.LOW,
    )
    governance.register_tool_permission(
        tool_id="grep_search",
        permission_level=PermissionLevel.FULL_ACCESS,
        risk_level=RiskLevel.LOW,
    )
    governance.register_tool_permission(
        tool_id="start_process",
        permission_level=PermissionLevel.FULL_ACCESS,
        risk_level=RiskLevel.MEDIUM,
    )
    governance.register_tool_permission(
        tool_id="filesystem_editor",
        permission_level=PermissionLevel.FULL_ACCESS,
        risk_level=RiskLevel.MEDIUM,
    )
    governance.register_tool_permission(
        tool_id="search_web",
        permission_level=PermissionLevel.FULL_ACCESS,
        risk_level=RiskLevel.MEDIUM,
    )

    governance.register_tool_permission(
        ToolPermission(
            tool_id="filesystem_editor",
            permission_level=PermissionLevel.LIMITED_WRITE,
            risk_level=RiskLevel.MEDIUM,
            allowed_paths=[
                "/Users/artan/Neuroartan-software",
            ],
            blocked_paths=[
                "/System",
                "/Applications",
            ],
        )
    )

    decision = governance.evaluate_operation(
        tool_id="filesystem_editor",
        target_path="/Users/artan/Neuroartan-software/runtime.py",
        request_text="Fix this local repository file",
    )

    print(
        {
            "approved": decision.approved,
            "reason": decision.reason,
            "governance_state": governance.export_governance_state(),
        }
    )
