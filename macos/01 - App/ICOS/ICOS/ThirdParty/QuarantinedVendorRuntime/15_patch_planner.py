from __future__ import annotations

from typing import Any, Dict

def plan_patch(primary: Any, intent: str) -> Dict[str, Any]:
    return {
        "status": "PATCH_PLANNED",
        "primary": primary,
        "intent": intent,
    }
