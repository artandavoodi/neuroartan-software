from __future__ import annotations

from typing import Any, Dict

REQUIRED_FIELDS = ["type", "subtype", "title", "document_id", "classification", "authority_level", "owner", "approval_status", "version"]

def audit_document(doc: Dict[str, Any]) -> Dict[str, Any]:
    missing = [f for f in REQUIRED_FIELDS if f not in doc or doc.get(f) in ("", None)]
    return {"status": "ok" if not missing else "missing_fields", "missing_fields": missing}
