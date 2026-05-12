from __future__ import annotations

from pathlib import Path
import json
import re
from datetime import datetime
from typing import Any, Dict

ROOT = Path("/Users/artan/Documents/Neuroartan")
OUT = Path(__file__).resolve().parent / "constitutional_memory_graph.json"
STATE = Path(__file__).resolve().parent / "constitutional_memory_state.json"

DOCUMENT_ID_RE = re.compile(r'document_id:\s*["\']?([^"\'\n]+)')
TITLE_RE = re.compile(r'title:\s*["\']?([^"\'\n]+)')
CLASSIFICATION_RE = re.compile(r'classification:\s*["\']?([^"\'\n]+)')
AUTHORITY_RE = re.compile(r'authority_level:\s*["\']?([^"\'\n]+)')

def extract(pattern, text):
    m = pattern.search(text)
    return m.group(1).strip() if m else None

def classify_path(path):
    s = str(path).lower()
    for key in ["governance", "operations", "knowledge", "infrastructure", "brand", "communication", "legal", "finance", "icos", "website", "software"]:
        if key in s:
            return key
    return "general"

def load_state() -> Dict[str, Any]:
    if STATE.exists():
        return json.loads(STATE.read_text(encoding="utf-8"))
    return {"version": 1, "events": [], "profiles": {}, "priorities": {}, "routing": {}, "last_update": None, "graph": {"nodes": [], "edges": []}}

def save_state(state: Dict[str, Any]) -> None:
    STATE.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")
    OUT.write_text(json.dumps(state.get("graph", {"nodes": [], "edges": []}), indent=2, ensure_ascii=False), encoding="utf-8")

def build():
    state = load_state()
    nodes = []
    edges = []
    duplicates = []

    seen_ids = set()

    for p in ROOT.rglob("*.md"):
        text = p.read_text(errors="ignore")
        doc_id = extract(DOCUMENT_ID_RE, text)
        node = {
            "path": str(p),
            "title": extract(TITLE_RE, text) or p.stem,
            "document_id": doc_id,
            "classification": extract(CLASSIFICATION_RE, text),
            "authority_level": extract(AUTHORITY_RE, text),
            "domain": classify_path(p),
            "size": p.stat().st_size,
            "updated_at": datetime.fromtimestamp(p.stat().st_mtime).isoformat(timespec="seconds"),
            "signals": {
                "contains_icos": "ICOS" in text,
                "contains_product": "product" in text.lower(),
                "contains_doctrine": "doctrine" in text.lower(),
                "contains_legal": "legal" in text.lower(),
                "contains_finance": "finance" in text.lower(),
                "contains_agent": "agent" in text.lower(),
                "contains_decision": "decision" in text.lower(),
                "contains_task": "task" in text.lower()
            }
        }
        nodes.append(node)

        if doc_id:
            if doc_id in seen_ids and doc_id not in duplicates:
                duplicates.append(doc_id)
            seen_ids.add(doc_id)
            edges.append({"from": doc_id, "to": node["domain"], "type": "belongs_to_domain"})

    state["graph"] = {"nodes": nodes, "edges": edges}
    state["duplicates"] = duplicates
    state["last_update"] = datetime.utcnow().isoformat(timespec="seconds")
    save_state(state)

    print(json.dumps({
        "status": "CONSTITUTIONAL_MEMORY_GRAPH_BUILT",
        "nodes": len(nodes),
        "edges": len(edges),
        "duplicates": duplicates,
        "target": str(OUT),
        "state": str(STATE)
    }, indent=2))

if __name__ == "__main__":
    build()
