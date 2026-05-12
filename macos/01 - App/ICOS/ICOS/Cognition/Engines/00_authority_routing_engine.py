from pathlib import Path
import json
import re
from datetime import datetime

ROOT = Path("/Users/artan/Documents/Neuroartan")
GRAPH = Path(__file__).resolve().parent / "constitutional_memory_graph.json"

AUTHORITY_RULES = {
    "Executive": {
        "can_route_to": [
            "Executive",
            "Departmental",
            "Office-level"
        ],
        "requires_review": []
    },
    "Departmental": {
        "can_route_to": [
            "Departmental",
            "Office-level"
        ],
        "requires_review": [
            "Executive"
        ]
    },
    "Office-level": {
        "can_route_to": [
            "Office-level"
        ],
        "requires_review": [
            "Departmental"
        ]
    }
}

LEGAL_SIGNALS = [
    "legal",
    "contract",
    "compliance",
    "policy",
    "terms",
    "privacy",
    "gdpr",
    "finance",
    "financial"
]

REQUIRES_GCA_REVIEW = [
    "legal",
    "contract",
    "policy",
    "privacy",
    "finance"
]


def load_graph():
    if not GRAPH.exists():
        return {
            "nodes": [],
            "edges": []
        }

    return json.loads(GRAPH.read_text())


def classify_domain(path, text):
    combined = f"{path} {text}".lower()

    domains = [
        "governance",
        "operations",
        "knowledge",
        "infrastructure",
        "brand",
        "communication",
        "legal",
        "finance",
        "website",
        "software",
        "icos"
    ]

    scores = {
        d: combined.count(d)
        for d in domains
    }

    return max(scores, key=scores.get)


def detect_authority_level(text):
    lowered = text.lower()

    if "authority_level:" in lowered:
        match = re.search(r'authority_level:\s*["\']?([^"\'\n]+)', text, re.I)
        if match:
            return match.group(1).strip()

    if any(k in lowered for k in [
        "executive",
        "founder",
        "constitutional",
        "institutional decision"
    ]):
        return "Executive"

    if any(k in lowered for k in [
        "department",
        "departmental"
    ]):
        return "Departmental"

    return "Office-level"


def detect_required_review(domain, text):
    lowered = text.lower()

    reviews = []

    if any(signal in lowered for signal in LEGAL_SIGNALS):
        reviews.append("General Counsel Agent")

    if domain == "finance":
        reviews.append("Chief Financial Officer Agent")

    if domain == "governance":
        reviews.append("Governance Synchronization Authority")

    return sorted(set(reviews))



def resolve_routing(path):
    p = Path(path)

    if not p.exists():
        return {
            "status": "FILE_NOT_FOUND",
            "path": path
        }

    text = p.read_text(errors="ignore")

    domain = classify_domain(path, text)
    authority = detect_authority_level(text)
    review_chain = detect_required_review(domain, text)

    routing_targets = AUTHORITY_RULES.get(authority, {}).get(
        "can_route_to",
        []
    )

    return {
        "status": "AUTHORITY_ROUTING_RESOLVED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "path": path,
        "domain": domain,
        "authority_level": authority,
        "allowed_routing_targets": routing_targets,
        "required_review_chain": review_chain,
        "requires_gca_review": any(
            s in text.lower()
            for s in REQUIRES_GCA_REVIEW
        ),
        "graph_loaded": GRAPH.exists()
    }


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print(json.dumps({
            "status": "INVALID_ARGUMENTS",
            "usage": "14_authority_routing_engine.py <document_path>"
        }, indent=2))
        raise SystemExit(1)

    print(json.dumps(
        resolve_routing(sys.argv[1]),
        indent=2
    ))