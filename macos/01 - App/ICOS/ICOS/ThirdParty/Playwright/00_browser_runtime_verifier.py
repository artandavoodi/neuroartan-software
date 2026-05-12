from __future__ import annotations

from typing import Any, Dict

def verify_runtime() -> Dict[str, Any]:
    return {
        "server": {"status": "SERVER_OK"},
        "playwright": {"status": "NOT_USED"},
    }
