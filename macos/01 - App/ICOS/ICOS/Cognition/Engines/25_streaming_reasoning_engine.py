def stream_steps(steps):
    for step in steps:
        print(f"STEP: {step}")

if __name__ == "__main__":
    stream_steps([
        "SCAN",
        "RESOLVE",
        "OWNER_CHAIN",
        "PLAN",
        "PATCH",
        "VERIFY"
    ])
