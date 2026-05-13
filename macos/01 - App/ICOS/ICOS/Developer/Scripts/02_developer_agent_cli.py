#!/usr/bin/env python3
from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path
from typing import Any, Dict

RUNTIME_PATH = Path("/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime/Engines/01_runtime_relinking_engine.py")

def load_runtime_module():
    spec = importlib.util.spec_from_file_location("icos_runtime_relinking_engine", RUNTIME_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Unable to load runtime engine: {RUNTIME_PATH}")

    module = importlib.util.module_from_spec(spec)
    sys.modules["icos_runtime_relinking_engine"] = module
    spec.loader.exec_module(module)
    return module

def main() -> int:
    parser = argparse.ArgumentParser(description="ICOS Developer Agent CLI")
    parser.add_argument("command", help="Runtime command to execute")
    parser.add_argument("--payload", default="{}", help="JSON payload")
    args = parser.parse_args()

    try:
        payload: Dict[str, Any] = json.loads(args.payload)
        if not isinstance(payload, dict):
            raise ValueError("payload must be a JSON object")
    except Exception as exc:
        print(json.dumps({"status": "INVALID_PAYLOAD", "error": str(exc)}, indent=2))
        return 2

    try:
        module = load_runtime_module()
        result = module.execute_command(args.command, payload)
    except Exception as exc:
        print(json.dumps({"status": "DEVELOPER_AGENT_FAILED", "error": str(exc)}, indent=2))
        return 1

    print(json.dumps(result, indent=2, sort_keys=True))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
