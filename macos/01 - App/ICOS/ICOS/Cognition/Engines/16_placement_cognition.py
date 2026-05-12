from __future__ import annotations

from typing import Any, Dict

def resolve_placement(doc: Dict[str, Any]) -> Dict[str, Any]:
    return {"department": doc.get("department", "unknown"), "office": doc.get("office", "unknown"), "category": doc.get("category", "unknown")}
