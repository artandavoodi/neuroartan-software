from __future__ import annotations

from typing import Any, Dict, List

def rank_doctrines(items: List[Dict[str, Any]], query: str) -> List[Dict[str, Any]]:
    def score(item: Dict[str, Any]) -> float:
        return float(item.get("authority_weight", 0)) * 3.0 + float(item.get("priority_weight", 0)) * 2.0 + float(item.get("relevance_weight", 0))
    return sorted(items, key=score, reverse=True)
