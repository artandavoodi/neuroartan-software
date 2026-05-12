def score_response(response):
    checks = {
        "has_source": "Source:" in response,
        "no_fake_path": "/src/components" not in response and ".aider.tags.cache" not in response,
        "no_placeholder": "[exact" not in response and "TODO" not in response,
        "no_theatre": "It seems" not in response
    }
    score = sum(25 for ok in checks.values() if ok)
    return {
        "status": "QUALITY_SCORED",
        "score": score,
        "checks": checks
    }
