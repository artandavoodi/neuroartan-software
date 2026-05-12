#!/usr/bin/env python3
import json
import sys
from pathlib import Path

try:
    from mcp.server.fastmcp import FastMCP
except Exception:
    class FastMCP:
        def __init__(self, name: str):
            self.name = name
            self._tools = {}

        def tool(self):
            def decorator(func):
                self._tools[func.__name__] = func
                return func
            return decorator

        def run(self, transport: str = "stdio"):
            print(json.dumps({
                "status": "MCP_PACKAGE_MISSING",
                "server": self.name,
                "transport": transport,
                "tools": list(self._tools.keys()),
                "fallback_mode": True
            }, indent=2))

ROOT = Path(__file__).resolve().parents[2]
REGISTRY = ROOT / "Core" / "Registries" / "identity_registry.json"

def load_identity():
    if REGISTRY.exists():
        return json.loads(REGISTRY.read_text(encoding="utf-8"))
    return {
        "product": "ICOS",
        "company": "Neuroartan",
        "model": "WSDA",
        "identity": "ICOS",
        "runtime": "ICOS",
        "source": "fallback"
    }

mcp = FastMCP("icos")

@mcp.tool()
def ping():
    return {"status": "ok", "server": "icos"}

@mcp.tool()
def status():
    identity = load_identity()
    return {
        "name": identity["identity"],
        "product": identity["product"],
        "company": identity["company"],
        "model": identity["model"],
        "runtime": identity["runtime"],
        "tools": ["ping", "status", "echo", "whoami"],
    }

@mcp.tool()
def whoami():
    return load_identity()

@mcp.tool()
def echo(message: str):
    return {"echo": message}

def main():
    mcp.run(transport="stdio")

if __name__ == "__main__":
    main()
