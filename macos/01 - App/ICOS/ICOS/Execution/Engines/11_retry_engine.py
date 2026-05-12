import json
from orchestrator import orchestrate_alignment_fix

MAX_RETRIES = 3

def run_with_retry(tasks):
    history = []

    for attempt in range(1, MAX_RETRIES + 1):
        result = orchestrate_alignment_fix(tasks)

        history.append({
            "attempt": attempt,
            "result": result
        })

        if result["status"] == "CHAIN_COMPLETE":
            return {
                "status": "SUCCESS",
                "attempts": history
            }

    return {
        "status": "FAILED_AFTER_RETRIES",
        "attempts": history
    }

if __name__ == "__main__":
    sample = [
        {
            "file": "/Users/artan/Documents/Neuroartan/website/docs/assets/css/layers/website/home/shell/home-navigation-drawer.css",
            "selector": "home-navigation-drawer__stack-item",
            "property": "padding",
            "value": "0.78rem 0"
        }
    ]

    print(json.dumps(run_with_retry(sample), indent=2))
