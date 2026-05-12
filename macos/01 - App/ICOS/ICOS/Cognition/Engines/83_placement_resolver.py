import json

PLACEMENT_RULES = {
    "product_definition": "Operations / Product Vision Core",
    "legal": "Governance / Legal",
    "finance": "Operations / Finance",
    "agent": "Governance / Agent Registry",
    "website": "Infrastructure / Website Systems",
    "software": "Infrastructure / Software Systems",
    "icos": "Infrastructure / ICOS Infrastructure",
    "memo": "Operations / Active Memos",
    "decision": "Governance / Institutional Decisions",
    "policy": "Governance / Policies",
    "doctrine": "Governance / Doctrine"
}

def resolve(title, purpose):
    q = f"{title} {purpose}".lower()
    scores = {}

    for key, placement in PLACEMENT_RULES.items():
        scores[key] = q.count(key.replace("_", " "))

    best = max(scores, key=scores.get)

    return {
        "status": "PLACEMENT_RESOLVED",
        "title": title,
        "purpose": purpose,
        "category": best,
        "recommended_placement": PLACEMENT_RULES[best],
        "confidence": scores[best]
    }

if __name__ == "__main__":
    import sys
    print(json.dumps(resolve(sys.argv[1], " ".join(sys.argv[2:])), indent=2))
