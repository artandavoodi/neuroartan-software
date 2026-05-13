"""
ICOS Runtime Relinking Engine

Canonical Responsibility:
- runtime dependency relinking
- sovereign topology synchronization
- runtime ownership validation
- stale path detection
- execution/runtime reconciliation
- runtime integrity enforcement
- cross-layer synchronization

IMPORTANT:
This layer owns runtime synchronization.
It does NOT own:
- cognition
- provider intelligence
- interfaces
- model authority
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional
import json
import os
import re
import subprocess

class RelinkStatus(str, Enum):
    PENDING = "pending"
    VALID = "valid"
    BROKEN = "broken"
    REPAIRED = "repaired"

@dataclass
class RuntimeReference:
    reference_id: str
    source: str
    target: str
    status: RelinkStatus = RelinkStatus.PENDING
    metadata: Dict[str, Any] = field(default_factory=dict)

class RuntimeRelinkingEngine:
    """
    Sovereign runtime synchronization authority.

    Responsibilities:
    - topology synchronization
    - runtime relinking
    - stale path detection
    - broken ownership repair
    - dependency reconciliation
    - sovereign architecture enforcement
    """

    def __init__(self, root_path: str) -> None:
        self.root_path = Path(root_path)
        self.workspace_roots: Dict[str, Path] = {
            "icos": self.root_path,
            "software": self.root_path,
            "software_repo": Path("/Users/artan/Neuroartan-software"),
            "website": Path("/Users/artan/Documents/Neuroartan/website"),
            "neuroartan": Path("/Users/artan/Documents/Neuroartan"),
            "vault": Path("/Users/artan/Documents/Neuroartan/I"),
            "continue": Path("/Users/artan/.continue"),
        }
        self.blocked_directory_names = {
            ".git",
            ".next",
            ".venv",
            "__pycache__",
            "DerivedData",
            "Library",
            "node_modules",
            "site-packages",
            "_architecture_scan",
            "_runtime_maturity",
            "_runtime_connection_audit",
            "_architecture_alignment",
            "_production_reconstruction",
            "_sovereign_scan",
        }
        self.placeholder_path_markers = {
            "src/main.py",
            "path/to",
            "path/to/the_file",
            "the_file.txt",
            "file.txt",
            "<file>",
            "<filepath>",
        }

        self.references: Dict[str, RuntimeReference] = {}

        self.runtime_state: Dict[str, Any] = {
            "runtime_root": str(self.root_path),
            "integrity_valid": False,
            "references": 0,
        }

        self.authoritative_layers = {
            "Cognition",
            "Memory",
            "Governance",
            "Runtime",
            "Providers",
            "Models",
            "Sources",
            "Interfaces",
            "Execution",
            "ThirdParty",
        }

    def _normalize_text(self, value: str) -> str:
        normalized = (value or "").strip().lower()
        normalized = normalized.replace("“", '"').replace("”", '"').replace("’", "'")
        normalized = " ".join(normalized.split())
        return normalized

    def _is_placeholder_path(self, path: str) -> bool:
        normalized = self._normalize_text(path)
        return any(marker in normalized for marker in self.placeholder_path_markers)

    def _path_within_workspace(self, path: Path) -> bool:
        resolved = path.expanduser().resolve(strict=False)
        return any(
            str(resolved).startswith(str(root.expanduser().resolve(strict=False)))
            for root in self.workspace_roots.values()
        )

    def _is_runtime_artifact_path(self, path: str) -> bool:
        normalized = path.lower()
        artifact_markers = (
            "/_architecture_scan/",
            "/_continue_relinking/",
            "/_architecture_alignment/",
            "/_runtime_maturity/",
            "/_runtime_connection_audit/",
            "/_architecture_audit/",
            "/diagnostics/",
            "/planning/",
            "/execution/config/",
            "/memory/config/",
            "/runtimeartifacts/",
            "/_final_empty_folder_classification.json",
            "/_remaining_empty_dirs_after_venv_relocation.txt",
            "/_surgical_runtime_classification.json",
            "/thirdparty/",
            "/quarantinedvendorruntime/",
            "/runtime/source/llama.cpp/",
            "/venv/",
            "/memory/repository_semantic_memory_graph.json",
            "/memory/config/repository_semantic_memory_graph.json",
            "/_duplicate_backup_resolution_report.json",
            "/_surgical_runtime_developer_move_plan.json",
            "/build/",
            "/deriveddata/",
        )
        return any(marker in normalized for marker in artifact_markers)

    def _resolve_path(self, path: str) -> Path:
        candidate = Path(path).expanduser()
        if candidate.is_absolute():
            return candidate

        for root in self.workspace_roots.values():
            merged = root / candidate
            if merged.exists():
                return merged

        return self.root_path / candidate

    def classify_intent(
        self,
        request_text: str,
        target_path: Optional[str] = None,
    ) -> Dict[str, Any]:
        normalized = self._normalize_text(request_text)
        scope = self.infer_scope(request_text=request_text, path=target_path)
        explicit_web = any(
            marker in normalized
            for marker in (
                "search the web",
                "browse the web",
                "web search",
                "search web",
                "look up online",
                "external lookup",
                "internet search",
            )
        )

        intents: List[str] = []
        if any(marker in normalized for marker in ("change", "replace", "fix", "edit", "update")):
            intents.append("edit")
        if any(marker in normalized for marker in ("find", "search", "scan", "audit", "owner")):
            intents.append("local_search")
        if any(marker in normalized for marker in ("owner file", "owner chain", "canonical owner", "source of truth")):
            intents.append("owner_chain")
        if any(marker in normalized for marker in ("verify", "test", "recheck")):
            intents.append("verify")
        if not intents:
            intents.append("inspect")

        return {
            "status": "INTENT_CLASSIFIED",
            "normalized_request": normalized,
            "scope": scope,
            "route": "external_web" if explicit_web and scope == "external_web" else "local_first",
            "intents": intents,
            "target_path": target_path,
            "workspace_root": str(self.resolve_search_root(path=target_path, request_text=request_text)),
            "web_allowed": explicit_web and scope == "external_web",
        }

    def infer_scope(
        self,
        request_text: str = "",
        path: Optional[str] = None,
    ) -> str:
        if path:
            resolved = self._resolve_path(path)
            for scope, root in self.workspace_roots.items():
                if str(resolved.resolve(strict=False)).startswith(str(root.resolve(strict=False))):
                    return scope

        normalized = self._normalize_text(request_text)
        local_markers = (
            "website",
            "homepage",
            "platform",
            "site",
            "software",
            "icos",
            "repo",
            "repository",
            "workspace",
            "codebase",
            "owner file",
            "owner chain",
            "canonical owner",
            "fix this",
            "change this",
            "replace this",
            "local",
        )
        explicit_web_markers = (
            "search the web",
            "browse the web",
            "web search",
            "search web",
            "look up online",
            "external lookup",
            "internet search",
        )

        if any(marker in normalized for marker in ("website", "homepage", "platform", "site")):
            return "website"
        if any(marker in normalized for marker in ("software", "icos", "macos app")):
            return "software"
        if any(marker in normalized for marker in ("continue", "mcp", "bridge")):
            return "software"
        if any(marker in normalized for marker in ("repo", "repository", "workspace", "codebase")):
            return "neuroartan"
        if any(marker in normalized for marker in explicit_web_markers) and not any(marker in normalized for marker in local_markers):
            return "external_web"

        return "software"

    def resolve_search_root(
        self,
        path: Optional[str] = None,
        request_text: str = "",
    ) -> Path:
        if path:
            candidate = self._resolve_path(path)
            if candidate.exists():
                return candidate

        scope = self.infer_scope(request_text=request_text, path=path)
        return self.workspace_roots.get(scope, self.workspace_roots["software"])

    def extract_search_terms(self, payload: Dict[str, Any]) -> List[str]:
        terms: List[str] = []
        quoted_terms: List[str] = []

        for source_key in ("request_text", "instruction", "prompt", "query", "text"):
            source_text = payload.get(source_key)
            if not isinstance(source_text, str):
                continue
            matches = re.findall(r'"([^"]+)"|\'([^\']+)\'', source_text.replace("“", '"').replace("”", '"'))
            for match in matches:
                term = next((part for part in match if part), "")
                if term.strip():
                    quoted_terms.append(term.strip())

        for key in ("old_text", "pattern"):
            value = payload.get(key)
            if isinstance(value, str) and value.strip():
                terms.append(value.strip())

        if quoted_terms:
            terms.extend(quoted_terms)
        else:
            for key in ("query", "text"):
                value = payload.get(key)
                if isinstance(value, str) and value.strip():
                    terms.append(value.strip())

        if not quoted_terms and not any(isinstance(payload.get(key), str) and payload.get(key, "").strip() for key in ("old_text", "pattern")):
            semantic_text = " ".join(
                str(payload.get(key, ""))
                for key in ("request_text", "instruction", "prompt", "query", "text")
            )
            terms.extend(self.derive_semantic_terms(semantic_text))

        deduped: List[str] = []
        for term in terms:
            if term not in deduped:
                deduped.append(term)

        return deduped

    def derive_semantic_terms(self, request_text: str) -> List[str]:
        normalized = self._normalize_text(request_text)
        hints: List[str] = []
        semantic_map = {
            "sidebar": ["SidebarView", "ShellState", "NavigationShell", "sidebar"],
            "side bar": ["SidebarView", "ShellState", "NavigationShell", "sidebar"],
            "developer icon": ["developer", "console", "AppRoute", "ICOSIcon"],
            "developer": ["DeveloperConsoleView", "DeveloperWorkspaceService", "Developer"],
            "icon": ["ICOSIcon", "IconRegistry", "SVGImageView"],
            "settings": ["SettingsRootView", "SettingsPanels", "settings"],
            "model": ["RuntimeSettingsState", "ModelRegistry", "ProviderRouter"],
            "lm studio": ["RuntimeSettingsState", "ProviderRouter", "CloudFrontierProvider"],
            "platform": ["website", "platform", "home-stage"],
            "website": ["website", "docs", "assets"],
            "homepage": ["home-stage", "homepage", "home-interaction"],
            "profile": ["profile", "ProfileManager", "UserProfile"],
            "voice": ["DeveloperVoiceTranscriptionService", "listen", "Speech"],
            "terminal": ["DeveloperTerminalView", "terminal", "runTerminalCommand"],
        }

        for marker, marker_terms in semantic_map.items():
            if marker in normalized:
                hints.extend(marker_terms)

        return hints

    def analyze_request(
        self,
        request_text: str,
        path: Optional[str] = None,
    ) -> Dict[str, Any]:
        classification = self.classify_intent(
            request_text=request_text,
            target_path=path,
        )
        owner_chain = self.find_owner_chain(
            query=request_text,
            path=path,
            request_text=request_text,
        )

        return {
            "status": "REQUEST_ANALYZED",
            "classification": classification,
            "owner_chain": owner_chain,
            "next_actions": [
                "Review canonical_owner before editing.",
                "Read the owner file.",
                "Apply a verified edit only after old/new text is known.",
                "Run local verification after the edit.",
            ],
        }

    def _iter_candidate_files(self, search_root: Path) -> List[Path]:
        if search_root.is_file():
            return [search_root]

        candidates: List[Path] = []
        for root, dirs, files in os.walk(search_root):
            dirs[:] = [directory for directory in dirs if directory not in self.blocked_directory_names]
            for filename in files:
                file = Path(root) / filename
                if file.is_file():
                    candidates.append(file)
        return candidates

    def _run_rg_search(self, pattern: str, search_root: Path) -> List[Dict[str, Any]]:
        command = [
            "rg",
            "--json",
            "--fixed-strings",
            "--line-number",
            pattern,
            str(search_root),
        ]

        try:
            completed = subprocess.run(
                command,
                check=False,
                capture_output=True,
                text=True,
                timeout=12,
            )
        except Exception:
            return self._python_search(pattern=pattern, search_root=search_root)

        if completed.returncode not in {0, 1}:
            return self._python_search(pattern=pattern, search_root=search_root)

        matches: List[Dict[str, Any]] = []
        for line in completed.stdout.splitlines():
            try:
                event = json.loads(line)
            except Exception:
                continue
            if event.get("type") != "match":
                continue

            data = event.get("data", {})
            path = data.get("path", {}).get("text")
            line_number = data.get("line_number")
            lines = data.get("lines", {}).get("text", "")
            if path and not self._is_runtime_artifact_path(path):
                matches.append(
                    {
                        "path": path,
                        "line": line_number,
                        "text": lines.rstrip("\n"),
                    }
                )

        return matches

    def _python_search(self, pattern: str, search_root: Path) -> List[Dict[str, Any]]:
        matches: List[Dict[str, Any]] = []
        for file in self._iter_candidate_files(search_root):
            try:
                lines = file.read_text(errors="ignore").splitlines()
            except Exception:
                continue

            for index, line in enumerate(lines, start=1):
                if pattern in line:
                    if self._is_runtime_artifact_path(str(file)):
                        continue
                    matches.append(
                        {
                            "path": str(file),
                            "line": index,
                            "text": line,
                        }
                    )
        return matches

    def classify_file_role(self, path: str) -> str:
        file_path = Path(path)
        parts = set(file_path.parts)
        suffix = file_path.suffix.lower()

        if "fragments" in parts or suffix in {".html", ".md"}:
            return "content_fragment"
        if "data" in parts or suffix in {".json", ".jsonl", ".yaml", ".yml"}:
            return "structured_data"
        if suffix in {".js", ".ts", ".mjs"}:
            return "behavior_runtime"
        if suffix in {".css", ".scss"}:
            return "style_layer"
        if suffix in {".py", ".swift"}:
            return "runtime_engine"
        return "unknown"

    def score_owner_candidate(self, path: str, occurrences: int) -> int:
        role = self.classify_file_role(path)
        score = occurrences * 10
        role_weights = {
            "structured_data": 25,
            "content_fragment": 45,
            "behavior_runtime": 35,
            "style_layer": 25,
            "runtime_engine": 60,
            "unknown": 5,
        }
        score += role_weights.get(role, 0)

        normalized_path = path.lower()
        if any(
            marker in normalized_path
            for marker in (
                "/planning/",
                "/dev_data/",
                "/diagnostics/",
                "/execution/config/",
                "/memory/config/",
                "/runtimeartifacts/",
                "/_final_empty_folder_classification.json",
                "/_remaining_empty_dirs_after_venv_relocation.txt",
                "/_surgical_runtime_classification.json",
                "/_architecture_scan/",
                "/_runtime_maturity/",
                "/_runtime_connection_audit/",
                "/_architecture_alignment/",
                "/_production_reconstruction/",
                "/_sovereign_scan/",
                "/memory/repository_semantic_memory_graph.json",
            )
        ):
            score -= 200
        if "/node_modules/" in normalized_path or "/.git/" in normalized_path:
            score -= 100

        return score

    def request_owner_boost(self, path: str, request_text: str) -> int:
        normalized_path = path.lower()
        normalized_request = self._normalize_text(request_text)
        boost = 0

        if "sidebar" in normalized_request or "side bar" in normalized_request:
            if normalized_path.endswith("/swiftui/shell/sidebarview.swift"):
                boost += 240
            if normalized_path.endswith("/swiftui/shell/shellstate.swift"):
                boost += 120
            if normalized_path.endswith("/swiftui/navigation/approuter.swift"):
                boost += 100

        if "icon" in normalized_request:
            if normalized_path.endswith("/designsystem/icons/icosicon.swift"):
                boost += 170
            if normalized_path.endswith("/designsystem/icons/iconregistry.swift"):
                boost += 130
            if normalized_path.endswith("/swiftui/navigation/approuter.swift"):
                boost += 160

        if "developer icon" in normalized_request:
            if normalized_path.endswith("/swiftui/navigation/approuter.swift"):
                boost += 260
            if normalized_path.endswith("/developer/views/developerplanview.swift"):
                boost -= 160
            if normalized_path.endswith("/developer/engines/developerworkspaceservice.swift"):
                boost -= 120

        if "settings" in normalized_request and normalized_path.endswith("/swiftui/settings/settingspanels.swift"):
            boost += 180

        if "model" in normalized_request or "lm studio" in normalized_request:
            if normalized_path.endswith("/system/settings/state/runtimesettingsstate.swift"):
                boost += 220
            if normalized_path.endswith("/providers/apple/providerrouter.swift"):
                boost += 180

        return boost

    def register_reference(
        self,
        reference_id: str,
        source: str,
        target: str,
    ) -> RuntimeReference:
        reference = RuntimeReference(
            reference_id=reference_id,
            source=source,
            target=target,
        )

        self.references[reference_id] = reference

        self.runtime_state["references"] = len(self.references)

        return reference

    def validate_reference(
        self,
        reference_id: str,
    ) -> RelinkStatus:
        reference = self.references.get(reference_id)

        if reference is None:
            return RelinkStatus.BROKEN

        source_exists = Path(reference.source).exists()
        target_exists = Path(reference.target).exists()

        if source_exists and target_exists:
            reference.status = RelinkStatus.VALID
        else:
            reference.status = RelinkStatus.BROKEN

        return reference.status

    def scan_for_stale_runtime_paths(self) -> List[str]:
        stale_patterns = [
            "ContinueBridge",
            "Runtime/Providers",
            "Runtime/models",
            "Runtime/interfaces",
            ".venv",
            "site-packages",
        ]

        detected: List[str] = []

        for file in self.root_path.rglob("*"):
            if not file.is_file():
                continue

            try:
                content = file.read_text(errors="ignore")
            except Exception:
                continue

            for pattern in stale_patterns:
                if pattern in content:
                    detected.append(str(file))
                    break

        return detected

    def validate_sovereign_topology(self) -> Dict[str, Any]:
        existing_layers = {
            path.name
            for path in self.root_path.iterdir()
            if path.is_dir()
        }

        missing = self.authoritative_layers - existing_layers

        topology_valid = len(missing) == 0

        self.runtime_state["integrity_valid"] = topology_valid

        return {
            "valid": topology_valid,
            "missing_layers": sorted(list(missing)),
            "existing_layers": sorted(list(existing_layers)),
        }

    def repair_reference(
        self,
        reference_id: str,
        repaired_target: str,
    ) -> bool:
        reference = self.references.get(reference_id)

        if reference is None:
            return False

        reference.target = repaired_target
        reference.status = RelinkStatus.REPAIRED

        return True

    def read_file(self, path: str) -> Dict[str, Any]:
        if self._is_placeholder_path(path):
            return {
                "status": "PLACEHOLDER_PATH_REJECTED",
                "path": path,
                "reason": "Runtime refuses unverified example paths. Resolve owner chain first.",
            }

        file_path = self._resolve_path(path)

        if not self._path_within_workspace(file_path):
            return {
                "status": "PATH_OUTSIDE_WORKSPACE",
                "path": str(file_path),
                "workspace_roots": {
                    key: str(root)
                    for key, root in self.workspace_roots.items()
                },
            }

        if not file_path.exists() or not file_path.is_file():
            return {
                "status": "FILE_NOT_FOUND",
                "path": str(file_path),
            }

        try:
            content = file_path.read_text(errors="ignore")
        except Exception as exc:
            return {
                "status": "READ_FAILED",
                "path": str(file_path),
                "error": str(exc),
            }

        return {
            "status": "FILE_READ",
            "path": str(file_path),
            "content": content,
        }

    def grep_search(self, pattern: str, path: Optional[str] = None) -> Dict[str, Any]:
        if not isinstance(pattern, str) or not pattern.strip():
            return {
                "status": "GREP_SEARCH_REQUIRES_PATTERN",
                "matches": [],
            }

        search_root = self.resolve_search_root(path=path, request_text=pattern)

        if not self._path_within_workspace(search_root):
            return {
                "status": "PATH_OUTSIDE_WORKSPACE",
                "path": str(search_root),
                "matches": [],
            }

        if not search_root.exists():
            return {
                "status": "PATH_NOT_FOUND",
                "path": str(search_root),
                "matches": [],
            }

        matches = self._run_rg_search(pattern=pattern.strip(), search_root=search_root)

        return {
            "status": "GREP_COMPLETE",
            "pattern": pattern,
            "path": str(search_root),
            "matches": matches,
        }

    def find_owner_chain(
        self,
        query: str,
        path: Optional[str] = None,
        request_text: str = "",
    ) -> Dict[str, Any]:
        search_root = self.resolve_search_root(path=path, request_text=request_text or query)

        if not search_root.exists():
            return {
                "status": "PATH_NOT_FOUND",
                "query": query,
                "path": str(search_root),
                "candidates": [],
            }

        terms = self.extract_search_terms(
            {
                "query": query,
                "request_text": request_text or query,
            }
        )
        if not terms:
            return {
                "status": "OWNER_CHAIN_REQUIRES_SEARCH_TERM",
                "query": query,
                "path": str(search_root),
                "candidates": [],
            }

        grouped: Dict[str, Dict[str, Any]] = {}
        for term in terms:
            for match in self._run_rg_search(pattern=term, search_root=search_root):
                match_path = match["path"]
                entry = grouped.setdefault(
                    match_path,
                    {
                        "path": match_path,
                        "role": self.classify_file_role(match_path),
                        "occurrences": 0,
                        "terms": [],
                        "matches": [],
                    },
                )
                entry["occurrences"] += 1
                if term not in entry["terms"]:
                    entry["terms"].append(term)
                entry["matches"].append(match)

        candidates = []
        for entry in grouped.values():
            entry["owner_score"] = self.score_owner_candidate(
                path=entry["path"],
                occurrences=entry["occurrences"],
            ) + self.request_owner_boost(entry["path"], request_text or query)
            candidates.append(entry)

        candidates.sort(key=lambda item: item["owner_score"], reverse=True)
        canonical_owner = candidates[0] if candidates else None
        top_score = canonical_owner["owner_score"] if canonical_owner else None
        canonical_owners = [
            candidate for candidate in candidates
            if top_score is not None and candidate["owner_score"] == top_score
        ]

        return {
            "status": "OWNER_CHAIN_RESOLVED" if canonical_owner else "OWNER_CHAIN_NOT_FOUND",
            "query": query,
            "request_text": request_text or query,
            "scope": self.infer_scope(request_text=request_text or query, path=path),
            "search_root": str(search_root),
            "search_terms": terms,
            "canonical_owner": canonical_owner,
            "canonical_owners": canonical_owners,
            "owner_chain": candidates[:12],
            "candidate_count": len(candidates),
        }

    def replace_text_verified(
        self,
        path: str,
        old_text: str,
        new_text: str,
        count: int = 0,
        dry_run: bool = False,
        request_text: str = "",
    ) -> Dict[str, Any]:
        if self._is_placeholder_path(path):
            return {
                "status": "PLACEHOLDER_PATH_REJECTED",
                "path": path,
                "reason": "Runtime refuses unverified example paths. Resolve owner chain first.",
            }

        file_path = self._resolve_path(path)
        if not self._path_within_workspace(file_path):
            return {
                "status": "PATH_OUTSIDE_WORKSPACE",
                "path": str(file_path),
            }

        if not file_path.exists() or not file_path.is_file():
            return {
                "status": "FILE_NOT_FOUND",
                "path": str(file_path),
            }

        try:
            content = file_path.read_text(encoding="utf-8", errors="ignore")
        except Exception as exc:
            return {
                "status": "READ_FAILED",
                "path": str(file_path),
                "error": str(exc),
            }

        before_old = content.count(old_text)
        before_new = content.count(new_text)

        if before_old == 0:
            return {
                "status": "TEXT_NOT_FOUND",
                "path": str(file_path),
                "old_text": old_text,
                "new_text": new_text,
                "old_count_before": before_old,
                "new_count_before": before_new,
            }

        replace_count = before_old if count is None or count <= 0 else min(before_old, count)
        updated = content.replace(old_text, new_text, replace_count)

        if dry_run:
            return {
                "status": "DRY_RUN_REPLACE_VERIFIED",
                "path": str(file_path),
                "request_text": request_text,
                "old_count_before": before_old,
                "new_count_before": before_new,
                "planned_replacements": replace_count,
                "verification": "dry_run_only_no_file_written",
            }

        try:
            file_path.write_text(updated, encoding="utf-8")
        except Exception as exc:
            return {
                "status": "WRITE_FAILED",
                "path": str(file_path),
                "error": str(exc),
            }

        verified = file_path.read_text(encoding="utf-8", errors="ignore")
        after_old = verified.count(old_text)
        after_new = verified.count(new_text)

        status = "REPLACE_VERIFIED"
        if after_old != before_old - replace_count or after_new < before_new + replace_count:
            status = "REPLACE_WRITTEN_VERIFICATION_WARNING"

        return {
            "status": status,
            "path": str(file_path),
            "request_text": request_text,
            "old_text": old_text,
            "new_text": new_text,
            "old_count_before": before_old,
            "new_count_before": before_new,
            "old_count_after": after_old,
            "new_count_after": after_new,
            "replacements": replace_count,
        }

    def execute_command(
        self,
        command: str,
        payload: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        payload = payload or {}
        available_commands = [
            "status",
            "classify_intent",
            "validate_topology",
            "scan_stale_paths",
            "register_reference",
            "read_file",
            "grep_search",
            "local_search",
            "analyze_request",
            "find_owner_chain",
            "replace_text",
            "replace_text_verified",
            "workflow_status",
        ]

        if command == "status":
            return self.router_summary()

        if command == "classify_intent":
            return self.classify_intent(
                request_text=payload.get("request_text") or payload.get("query") or payload.get("text") or "",
                target_path=payload.get("path") or payload.get("target_path"),
            )

        if command == "analyze_request":
            request_text = payload.get("request_text") or payload.get("query") or payload.get("text") or ""
            if not isinstance(request_text, str) or not request_text.strip():
                return {
                    "status": "ANALYZE_REQUEST_REQUIRES_REQUEST_TEXT",
                    "available_commands": available_commands,
                }
            return self.analyze_request(
                request_text=request_text.strip(),
                path=payload.get("path") or payload.get("target_path"),
            )

        if command == "validate_topology":
            return self.validate_sovereign_topology()

        if command == "scan_stale_paths":
            return {
                "stale_paths": self.scan_for_stale_runtime_paths(),
            }

        if command == "register_reference":
            reference = self.register_reference(
                reference_id=payload.get("reference_id", "runtime::dynamic"),
                source=payload.get("source", "unknown"),
                target=payload.get("target", "unknown"),
            )

            return {
                "registered": True,
                "reference_id": reference.reference_id,
                "status": reference.status.value,
            }

        if command == "read_file":
            target = payload.get("path") or payload.get("file_path") or payload.get("target")
            if not isinstance(target, str) or not target.strip():
                return {
                    "status": "READ_FILE_REQUIRES_PATH",
                    "available_commands": available_commands,
                }

            return self.read_file(target.strip())

        if command in {"grep_search", "local_search"}:
            pattern = payload.get("pattern") or payload.get("query") or payload.get("text")
            if not isinstance(pattern, str) or not pattern.strip():
                return {
                    "status": "GREP_SEARCH_REQUIRES_PATTERN",
                    "available_commands": available_commands,
                }

            return self.grep_search(
                pattern=pattern.strip(),
                path=payload.get("path"),
            )

        if command == "find_owner_chain":
            query = payload.get("query") or payload.get("pattern") or payload.get("text") or payload.get("request_text")
            if not isinstance(query, str) or not query.strip():
                return {
                    "status": "OWNER_CHAIN_REQUIRES_QUERY",
                    "available_commands": available_commands,
                }

            return self.find_owner_chain(
                query=query.strip(),
                path=payload.get("path"),
                request_text=payload.get("request_text") or query.strip(),
            )

        if command in {"replace_text", "replace_text_verified"}:
            target = payload.get("path") or payload.get("file_path") or payload.get("target")
            old_text = payload.get("old_text")
            new_text = payload.get("new_text")
            if not isinstance(target, str) or not target.strip():
                return {
                    "status": "REPLACE_TEXT_REQUIRES_PATH",
                    "available_commands": available_commands,
                }
            if not isinstance(old_text, str) or not isinstance(new_text, str):
                return {
                    "status": "REPLACE_TEXT_REQUIRES_OLD_AND_NEW_TEXT",
                    "available_commands": available_commands,
                }

            return self.replace_text_verified(
                path=target.strip(),
                old_text=old_text,
                new_text=new_text,
                count=int(payload.get("count") or 0),
                dry_run=bool(payload.get("dry_run", False)),
                request_text=payload.get("request_text") or "",
            )

        if command == "workflow_status":
            return {
                "status": "WORKFLOW_STATUS_AVAILABLE",
                "runtime_state": self.runtime_state,
                "workspace_roots": {
                    key: str(root)
                    for key, root in self.workspace_roots.items()
                },
            }

        return {
            "status": "UNKNOWN_RUNTIME_COMMAND",
            "command": command,
            "available_commands": available_commands,
        }

    def router_summary(self) -> Dict[str, Any]:
        topology = self.validate_sovereign_topology()

        return {
            "runtime": "ICOS",
            "engine": "RuntimeRelinkingEngine",
            "root": str(self.root_path),
            "workspace_roots": {
                key: str(root)
                for key, root in self.workspace_roots.items()
            },
            "tools": [
                "classify_intent",
                "local_search",
                "analyze_request",
                "grep_search",
                "find_owner_chain",
                "read_file",
                "replace_text_verified",
                "validate_topology",
                "scan_stale_paths",
            ],
            "integrity_valid": topology["valid"],
            "references": len(self.references),
            "missing_layers": topology["missing_layers"],
        }

    def export_runtime_state(self) -> Dict[str, Any]:
        return {
            "runtime_state": self.runtime_state,
            "references": [
                {
                    "reference_id": reference.reference_id,
                    "source": reference.source,
                    "target": reference.target,
                    "status": reference.status.value,
                }
                for reference in self.references.values()
            ],
        }

#
# ============================================================
# Compatibility Runtime Layer
# ============================================================

RUNTIME_ROOT = "/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS"

runtime_router = RuntimeRelinkingEngine(
    root_path=RUNTIME_ROOT
)

def router_summary() -> Dict[str, Any]:
    return runtime_router.router_summary()

def execute_command(
    command: str,
    payload: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    return runtime_router.execute_command(
        command=command,
        payload=payload,
    )

def runtime_status() -> Dict[str, Any]:
    return {
        "status": "RUNTIME_ROUTER_ACTIVE",
        "runtime": "ICOS",
        "engine": "RuntimeRelinkingEngine",
        "summary": router_summary(),
    }

if __name__ == "__main__":
    runtime = RuntimeRelinkingEngine(
        root_path="/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS"
    )

    runtime.register_reference(
        reference_id="runtime::providers",
        source="Interfaces/runtime_router.py",
        target="Providers/00_provider_registry.py",
    )

    topology = runtime.validate_sovereign_topology()

    stale_paths = runtime.scan_for_stale_runtime_paths()

    read_test = runtime.execute_command(
        command="read_file",
        payload={"path": "/Users/artan/.continue/config.yaml"},
    )

    grep_test = runtime.execute_command(
        command="grep_search",
        payload={"pattern": "search_web", "path": "/Users/artan/.continue"},
    )

    print(
        json.dumps(
            {
                "status": "ICOS_RUNTIME_RELINKING_ENGINE_ACTIVE",
                "topology": topology,
                "stale_paths_detected": len(stale_paths),
                "read_test": read_test,
                "grep_test": grep_test,
                "runtime_state": runtime.export_runtime_state(),
                "router_summary": runtime.router_summary(),
            },
            indent=2,
        )
    )
