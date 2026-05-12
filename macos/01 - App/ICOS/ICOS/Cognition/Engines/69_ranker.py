from __future__ import annotations

def rank(candidates):
    priority = [
        "/pythonruntime/institutional/",
        "/pythonruntime/icos_intelligence/",
        "/pythonruntime/intelligence/",
        "/pythonruntime/advanced/",
        "/documents/neuroartan/i/",
        "constitution",
        "doctrine",
        "document",
        "memory",
        "planner",
    ]

    def score(path):
        p = path.lower()
        score = 1000
        for i, key in enumerate(priority):
            if key in p:
                score = i
                break
        if "/website/" in p:
            score += 500
        if p.endswith((".css", ".js", ".html")):
            score += 500
        return score

    return sorted(candidates, key=score)
