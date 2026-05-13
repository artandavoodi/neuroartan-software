#!/usr/bin/env python3
import json
import sys
import importlib.util
from pathlib import Path

PROJECT_VENV = Path("/Users/artan/.venvs/icos")
for candidate in sorted(PROJECT_VENV.glob("lib/python*/site-packages")):
    if candidate.exists() and str(candidate) not in sys.path:
        sys.path.insert(0, str(candidate))

try:
    from mcp.server.fastmcp import FastMCP
except Exception as e:
    print(f"Failed to import mcp from project venv: {e}", file=sys.stderr)
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parent
REGISTRY = ROOT / "identity_registry.json"

def find_runtime_path() -> Path | None:
    candidate_roots = [
        ROOT.parents[2] / "Runtime" / "Engines",
        ROOT.parents[3] / "ICOS" / "Runtime" / "Engines",
        ROOT.parents[3] / "Runtime" / "Engines",
    ]

    for runtime_root in candidate_roots:
        runtime_path = runtime_root / "01_runtime_relinking_engine.py"
        if runtime_path.exists():
            return runtime_path

    return None

RUNTIME_PATH = find_runtime_path()

def load_runtime_router():
    if RUNTIME_PATH is None:
        return None

    spec = importlib.util.spec_from_file_location(
        "icos_runtime_relinking_engine",
        RUNTIME_PATH,
    )

    if spec is None or spec.loader is None:
        return None

    module = importlib.util.module_from_spec(spec)
    sys.modules["icos_runtime_relinking_engine"] = module

    try:
        spec.loader.exec_module(module)
    except Exception as exc:
        return {"error": str(exc)}

    return module

RUNTIME_ROUTER = load_runtime_router()

LOCAL_WORKSPACE_ROOTS = [
    Path("/Users/artan/.continue"),
    Path("/Users/artan/Documents/Neuroartan"),
    Path("/Users/artan/Neuroartan-software"),
]

def _is_within_local_workspace(file_path: Path) -> bool:
    resolved = file_path.expanduser().resolve(strict=False)
    return any(
        str(resolved).startswith(str(root.expanduser().resolve(strict=False)))
        for root in LOCAL_WORKSPACE_ROOTS
    )

def resolve_local_path(raw_path: str) -> Path:
    candidate = Path(raw_path).expanduser()

    if candidate.is_absolute():
        return candidate

    for root in LOCAL_WORKSPACE_ROOTS:
        merged = (root / candidate).expanduser()
        if merged.exists():
            return merged

    return candidate

def load_identity():
    if REGISTRY.exists():
        return json.loads(REGISTRY.read_text(encoding="utf-8"))
    return {
        "product": "ICOS",
        "company": "Neuroartan",
        "model": "WSDA",
        "identity": "ICOS",
        "runtime": "ContinueBridge",
        "source": "fallback"
    }

mcp = FastMCP("icos")

@mcp.tool()
def ping():
    return {"status": "ok", "server": "icos"}

@mcp.tool()
def status():
    identity = load_identity()

    runtime_summary = None
    if RUNTIME_ROUTER is not None and not isinstance(RUNTIME_ROUTER, dict):
        try:
            runtime_summary = RUNTIME_ROUTER.router_summary()
        except Exception as exc:
            runtime_summary = {"error": str(exc)}
    elif isinstance(RUNTIME_ROUTER, dict):
        runtime_summary = RUNTIME_ROUTER

    return {
        "name": identity["identity"],
        "product": identity["product"],
        "company": identity["company"],
        "model": identity["model"],
        "runtime": identity["runtime"],
        "tools": [
            "ping",
            "status",
            "echo",
            "whoami",
            "classify_intent",
            "analyze_request",
            "local_search",
            "read_file",
            "grep_search",
            "find_owner_chain",
            "replace_text",
            "replace_text_verified",
            "workflow_status",
            "validate_topology",
            "scan_stale_paths",
        ],
        "local_first_policy": {
            "default_route": "classify_intent -> local_search -> find_owner_chain -> read_file -> replace_text_verified",
            "web_search": "not exposed by ICOS MCP adapter; external web lookup must be explicit and separate",
        },
        "runtime_summary": runtime_summary,
    }

@mcp.tool()
def whoami():
    return load_identity()

@mcp.tool()
def echo(message: str):
    return {"echo": message}

@mcp.tool()
def classify_intent(request_text: str, path: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "request_text": request_text}

    payload = {"request_text": request_text}
    if path:
        payload["path"] = path

    return RUNTIME_ROUTER.execute_command(
        command="classify_intent",
        payload=payload,
    )

@mcp.tool()
def analyze_request(request_text: str, path: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "request_text": request_text}

    payload = {"request_text": request_text}
    if path:
        payload["path"] = path

    return RUNTIME_ROUTER.execute_command(
        command="analyze_request",
        payload=payload,
    )

@mcp.tool()
def read_file(path: str):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "path": path}

    return RUNTIME_ROUTER.execute_command(
        command="read_file",
        payload={"path": path},
    )

@mcp.tool()
def local_search(query: str, path: str = "", request_text: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "query": query, "path": path}

    payload = {"query": query}
    if path:
        payload["path"] = path
    if request_text:
        payload["request_text"] = request_text

    return RUNTIME_ROUTER.execute_command(
        command="local_search",
        payload=payload,
    )

@mcp.tool()
def grep_search(pattern: str, path: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "pattern": pattern, "path": path}

    payload = {"pattern": pattern}
    if path:
        payload["path"] = path

    return RUNTIME_ROUTER.execute_command(
        command="grep_search",
        payload=payload,
    )

@mcp.tool()
def find_owner_chain(query: str, path: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "query": query, "path": path}

    payload = {"query": query, "request_text": query}
    if path:
        payload["path"] = path

    return RUNTIME_ROUTER.execute_command(
        command="find_owner_chain",
        payload=payload,
    )

@mcp.tool()
def replace_text(path: str, old_text: str, new_text: str, count: int = 1):
    return replace_text_verified(
        path=path,
        old_text=old_text,
        new_text=new_text,
        count=count,
        dry_run=False,
        request_text="",
    )

@mcp.tool()
def replace_text_verified(path: str, old_text: str, new_text: str, count: int = 0, dry_run: bool = False, request_text: str = ""):
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable", "path": path}

    return RUNTIME_ROUTER.execute_command(
        command="replace_text_verified",
        payload={
            "path": path,
            "old_text": old_text,
            "new_text": new_text,
            "count": count,
            "dry_run": dry_run,
            "request_text": request_text,
        },
    )

@mcp.tool()
def workflow_status():
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable"}

    return RUNTIME_ROUTER.execute_command(command="workflow_status", payload={})

@mcp.tool()
def validate_topology():
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable"}

    return RUNTIME_ROUTER.execute_command(command="validate_topology", payload={})

@mcp.tool()
def scan_stale_paths():
    if RUNTIME_ROUTER is None or isinstance(RUNTIME_ROUTER, dict):
        return {"status": "runtime_router_unavailable"}

    return RUNTIME_ROUTER.execute_command(command="scan_stale_paths", payload={})

def main():
    mcp.run(transport="stdio")

if __name__ == "__main__":
    main()
