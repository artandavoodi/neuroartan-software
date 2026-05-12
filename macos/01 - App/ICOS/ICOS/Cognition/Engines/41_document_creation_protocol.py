from pathlib import Path
import json
import re
from datetime import datetime

ROOT = Path("/Users/artan/Documents/Neuroartan")

DOCUMENT_TYPES = {
    "policy": {
        "domain": "governance",
        "default_authority": "Executive",
        "requires_gca_review": True,
        "placement": "Governance"
    },
    "memo": {
        "domain": "operations",
        "default_authority": "Departmental",
        "requires_gca_review": False,
        "placement": "Operations"
    },
    "contract": {
        "domain": "legal",
        "default_authority": "Executive",
        "requires_gca_review": True,
        "placement": "Governance"
    },
    "financial": {
        "domain": "finance",
        "default_authority": "Executive",
        "requires_gca_review": True,
        "placement": "Operations"
    },
    "agent": {
        "domain": "governance",
        "default_authority": "Departmental",
        "requires_gca_review": False,
        "placement": "Governance"
    },
    "website": {
        "domain": "infrastructure",
        "default_authority": "Departmental",
        "requires_gca_review": False,
        "placement": "Infrastructure"
    },
    "icos": {
        "domain": "infrastructure",
        "default_authority": "Executive",
        "requires_gca_review": False,
        "placement": "Infrastructure"
    }
}

FRONTMATTER_TEMPLATE = {
    "type": "Standard",
    "subtype": "Institutional",
    "title": "",
    "document_id": "",
    "classification": "Internal",
    "authority_level": "Departmental",
    "owner": "",
    "department": "",
    "status": "Draft",
    "version": "1.0"
}

DOCUMENT_ID_PATTERN = re.compile(r'document_id:\s*["\']?([^"\'\n]+)', re.I)



def existing_document_ids():
    ids = set()

    for p in ROOT.rglob("*.md"):
        try:
            text = p.read_text(errors="ignore")
        except Exception:
            continue

        match = DOCUMENT_ID_PATTERN.search(text)

        if match:
            ids.add(match.group(1).strip())

    return ids



def generate_document_id(category):
    existing = existing_document_ids()

    prefix = category.upper()[:4]

    number = 1

    while True:
        candidate = f"ICOS-{prefix}-{datetime.now().year}-{number:04d}"

        if candidate not in existing:
            return candidate

        number += 1



def resolve_document_type(title, purpose):
    combined = f"{title} {purpose}".lower()

    scores = {
        key: combined.count(key)
        for key in DOCUMENT_TYPES
    }

    return max(scores, key=scores.get)



def determine_placement(document_type):
    return DOCUMENT_TYPES.get(document_type, {}).get(
        "placement",
        "Operations"
    )



def create_protocol(title, purpose):
    document_type = resolve_document_type(title, purpose)

    rules = DOCUMENT_TYPES.get(document_type, {})

    document_id = generate_document_id(document_type)

    metadata = FRONTMATTER_TEMPLATE.copy()

    metadata["title"] = title
    metadata["document_id"] = document_id
    metadata["authority_level"] = rules.get(
        "default_authority",
        "Departmental"
    )
    metadata["department"] = rules.get(
        "placement",
        "Operations"
    )

    return {
        "status": "DOCUMENT_CREATION_PROTOCOL_RESOLVED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "title": title,
        "purpose": purpose,
        "document_type": document_type,
        "recommended_placement": determine_placement(document_type),
        "requires_gca_review": rules.get(
            "requires_gca_review",
            False
        ),
        "generated_document_id": document_id,
        "metadata_template": metadata,
        "required_sections": [
            "Change Log",
            "Document Control & Validation",
            "END OF DOCUMENT"
        ]
    }


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print(json.dumps({
            "status": "INVALID_ARGUMENTS",
            "usage": "16_document_creation_protocol.py <title> <purpose>"
        }, indent=2))
        raise SystemExit(1)

    title = sys.argv[1]
    purpose = " ".join(sys.argv[2:])

    print(json.dumps(
        create_protocol(title, purpose),
        indent=2
    ))