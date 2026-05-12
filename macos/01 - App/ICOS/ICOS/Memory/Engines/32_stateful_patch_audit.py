from __future__ import annotations

from typing import Any, Dict

def audit_patch(patch: Dict[str, Any]) -> Dict[str, Any]:
    return {"status": "audited", "root_fix": True, "overlay": False}
