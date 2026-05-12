from __future__ import annotations

from typing import Any, Dict, List

def plan(tasks: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    return sorted(tasks, key=lambda t: (t.get("priority", 0), -len(t.get("dependencies", []))), reverse=True)
