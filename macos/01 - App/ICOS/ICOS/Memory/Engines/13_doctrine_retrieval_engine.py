from pathlib import Path
import json

INDEX = Path("/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime/ContinueBridge/PythonRuntime/intelligence/institutional_doctrine_index.json")

def retrieve(query, limit=8):
    q = query.lower()
    records = json.loads(INDEX.read_text()) if INDEX.exists() else []

    scored = []
    for r in records:
        hay = f"{r.get('title','')} {r.get('path','')} {r.get('preview','')}".lower()
        score = sum(1 for term in q.split() if term in hay)
        if score:
            scored.append((score, r))

    scored.sort(key=lambda x: x[0], reverse=True)

    return {
        "status": "DOCTRINE_RETRIEVED",
        "query": query,
        "results": [r for _, r in scored[:limit]]
    }

if __name__ == "__main__":
    import sys
    print(json.dumps(retrieve(" ".join(sys.argv[1:])), indent=2))
