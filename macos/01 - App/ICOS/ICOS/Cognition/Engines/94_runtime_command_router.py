from __future__ import annotations

from pathlib import Path
from datetime import datetime
from typing import Any, Dict, Callable
import importlib.util
import json
import traceback
import sys

ROOT = Path(__file__).resolve().parents[2]

REGISTRY_PATH = ROOT / "core" / "02_icos_command_registry.py"

EXECUTION_LOG = ROOT / "runtime" / "logs" / "runtime_execution_log.json"



def load_module(path: Path, module_name: str):
    spec = importlib.util.spec_from_file_location(
        module_name,
        path
    )

    if spec is None or spec.loader is None:
        raise ImportError(
            f"Unable to load module spec for: {path}"
        )

    module = importlib.util.module_from_spec(spec)

    sys.modules[module_name] = module

    spec.loader.exec_module(module)

    return module


registry_module = load_module(
    REGISTRY_PATH,
    "icos_command_registry"
)

REGISTRY = registry_module.REGISTRY



def load_execution_log():
    if not EXECUTION_LOG.exists():
        return []

    try:
        return json.loads(
            EXECUTION_LOG.read_text()
        )
    except Exception:
        return []



def save_execution_log(entries):
    EXECUTION_LOG.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    EXECUTION_LOG.write_text(
        json.dumps(entries, indent=2)
    )



def resolve_callable(handler_path: str) -> Callable[..., Any]:
    module_name, function_name = handler_path.rsplit(".", 1)

    file_name = module_name + ".py"

    located = list(ROOT.rglob(file_name))

    if not located:
        raise FileNotFoundError(
            f"Unable to locate handler module: {file_name}"
        )

    module = load_module(
        located[0],
        module_name.replace("/", "_")
    )

    return getattr(module, function_name)



def execute_command(command_name: str, payload: Dict[str, Any]):
    started_at = datetime.now().isoformat(timespec="seconds")

    command = REGISTRY.resolve(command_name)

    if not command:
        return {
            "status": "COMMAND_NOT_FOUND",
            "command": command_name
        }

    if not command.enabled:
        return {
            "status": "COMMAND_DISABLED",
            "command": command_name
        }

    try:
        callable_handler = resolve_callable(
            command.handler
        )

        if isinstance(payload, dict):
            result = callable_handler(**payload)
        else:
            result = callable_handler(payload)

        entry = {
            "executed_at": started_at,
            "command": command_name,
            "authority": command.authority,
            "requires_verification": command.requires_verification,
            "requires_governance_review": command.requires_governance_review,
            "status": "SUCCESS"
        }

        logs = load_execution_log()
        logs.append(entry)
        save_execution_log(logs)

        return {
            "status": "COMMAND_EXECUTED",
            "command": command_name,
            "result": result,
            "execution": entry
        }

    except Exception as error:
        trace = traceback.format_exc()

        entry = {
            "executed_at": started_at,
            "command": command_name,
            "status": "FAILED",
            "error": str(error)
        }

        logs = load_execution_log()
        logs.append(entry)
        save_execution_log(logs)

        return {
            "status": "COMMAND_FAILED",
            "command": command_name,
            "error": str(error),
            "traceback": trace
        }



def router_summary():
    logs = load_execution_log()

    return {
        "status": "ICOS_RUNTIME_COMMAND_ROUTER_ACTIVE",
        "registered_commands": len(REGISTRY.commands),
        "execution_log_entries": len(logs),
        "latest_execution": logs[-1] if logs else None
    }


if __name__ == "__main__":
    print(json.dumps(
        router_summary(),
        indent=2
    ))