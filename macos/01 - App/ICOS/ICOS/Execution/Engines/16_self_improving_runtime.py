from __future__ import annotations

from typing import Any, Dict

def introspect(runtime_state: Dict[str, Any]) -> Dict[str, Any]:
    return {"status": "introspected", "signals": list(runtime_state.keys())}
