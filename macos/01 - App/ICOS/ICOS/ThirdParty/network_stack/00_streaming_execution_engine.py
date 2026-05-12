def stream_pipeline(steps):
    for step in steps:
        print(f"ICOS_STEP::{step}")

if __name__ == "__main__":
    stream_pipeline([
        "SCAN",
        "SEMANTIC_GRAPH",
        "OWNER_CHAIN",
        "PATCH_PLAN",
        "SAFE_APPLY",
        "BROWSER_VERIFY",
        "VISUAL_DIFF",
        "MEMORY_UPDATE"
    ])
