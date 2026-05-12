from __future__ import annotations

from pathlib import Path
from typing import Iterable, List, Set, Dict
import json
import re
from datetime import datetime

ROOT = Path("/Users/artan/Documents/Neuroartan")

DOCUMENT_ID_PATTERN = re.compile(
    r'document_id:\s*["\']?([^"\'\n]+)',
    re.I
)

CATEGORY_PREFIX = {
    "governance": "GOV",
    "operations": "OPS",
    "infrastructure": "INF",
    "knowledge": "KNO",
    "brand": "BRD",
    "communication": "COM",
    "legal": "LEG",
    "finance": "FIN",
    "icos": "ICOS",
    "website": "WEB",
    "software": "SFT"
}


def extract_document_ids() -> List[Dict[str, str]]:
    records: List[Dict[str, str]] = []

    for path in ROOT.rglob("*.md"):
        try:
            text = path.read_text(errors="ignore")
        except Exception:
            continue

        match = DOCUMENT_ID_PATTERN.search(text)

        if not match:
            continue

        records.append({
            "document_id": match.group(1).strip(),
            "path": str(path)
        })

    return records



def find_duplicate_ids(ids: Iterable[str]) -> List[str]:
    seen: Set[str] = set()
    dupes: List[str] = []

    for doc_id in ids:
        if doc_id in seen and doc_id not in dupes:
            dupes.append(doc_id)

        seen.add(doc_id)

    return dupes



def classify_domain(path: str) -> str:
    lowered = path.lower()

    for domain in CATEGORY_PREFIX:
        if domain in lowered:
            return domain

    return "operations"



def generate_next_document_id(domain: str) -> str:
    existing = {
        r["document_id"]
        for r in extract_document_ids()
    }

    prefix = CATEGORY_PREFIX.get(domain, "OPS")

    year = datetime.now().year

    number = 1

    while True:
        candidate = f"NA-{prefix}-{year}-{number:04d}"

        if candidate not in existing:
            return candidate

        number += 1



def audit_document_ids() -> Dict:
    records = extract_document_ids()

    ids = [
        r["document_id"]
        for r in records
    ]

    duplicates = find_duplicate_ids(ids)

    duplicate_map = {}

    for duplicate in duplicates:
        duplicate_map[duplicate] = [
            r["path"]
            for r in records
            if r["document_id"] == duplicate
        ]

    malformed = [
        r for r in records
        if not re.match(r'^[A-Z0-9\-]+$', r["document_id"])
    ]

    return {
        "status": "DOCUMENT_ID_GOVERNANCE_AUDIT_COMPLETE",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "total_documents": len(records),
        "duplicate_count": len(duplicates),
        "duplicates": duplicate_map,
        "malformed_ids": malformed,
        "recommended_next_ids": {
            domain: generate_next_document_id(domain)
            for domain in CATEGORY_PREFIX
        }
    }


if __name__ == "__main__":
    print(json.dumps(
        audit_document_ids(),
        indent=2
    ))
