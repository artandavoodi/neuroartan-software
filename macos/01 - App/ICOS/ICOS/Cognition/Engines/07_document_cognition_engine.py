from pathlib import Path
import json
import re

GRAPH = Path(__file__).resolve().parent / "constitutional_memory_graph.json"

REQUIRED_FIELDS = [
    "type", "subtype", "title", "document_id", "classification",
    "authority_level", "owner", "department", "status", "version"
]

def analyze_document(path):
    p = Path(path)
    if not p.exists():
        return {"status": "FILE_NOT_FOUND", "path": str(path)}

    text = p.read_text(errors="ignore")
    frontmatter = text.split("---")[1] if text.startswith("---") and len(text.split("---")) > 2 else ""

    missing = [f for f in REQUIRED_FIELDS if not re.search(rf"^{f}:", frontmatter, re.M)]

    return {
        "status": "DOCUMENT_ANALYZED",
        "path": str(p),
        "missing_required_fields": missing,
        "has_change_log": "Change Log" in text,
        "has_document_control": "Document Control" in text,
        "has_end_marker": "END OF DOCUMENT" in text,
        "is_compliant_candidate": not missing and "Change Log" in text and "END OF DOCUMENT" in text
    }

if __name__ == "__main__":
    import sys
    print(json.dumps(analyze_document(sys.argv[1]), indent=2))
