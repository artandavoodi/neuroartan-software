from pathlib import Path
import json
import subprocess
import time

RUNTIME = Path("/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/Runtime/ContinueBridge/PythonRuntime")

TEXT_VERIFIER = RUNTIME / "advanced" / "runtime_text_owner_verifier.py"
BROWSER_VERIFIER = RUNTIME / "advanced" / "browser_runtime_verifier.py"
VISUAL_DIFF = RUNTIME / "advanced" / "autonomous_visual_diff.py"

def run(args):
    result = subprocess.run(args, text=True, capture_output=True)
    return {
        "exit_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }

def closed_verify_text(old_text, new_text):
    ownership = run([
        "python3",
        str(TEXT_VERIFIER),
        old_text,
        new_text
    ])

    runtime_before = run([
        "python3",
        str(BROWSER_VERIFIER)
    ])

    time.sleep(1)

    runtime_after = run([
        "python3",
        str(BROWSER_VERIFIER)
    ])

    visual = run([
        "python3",
        str(VISUAL_DIFF)
    ])

    status = "VERIFICATION_INCOMPLETE"

    if "VERIFIED_COMPLETE" in ownership["stdout"]:
        status = "VERIFIED_COMPLETE"

    if "RUNTIME_OWNER_MISMATCH" in ownership["stdout"]:
        status = "RUNTIME_OWNER_MISMATCH"

    return {
        "status": status,
        "ownership_verification": ownership,
        "runtime_before": runtime_before,
        "runtime_after": runtime_after,
        "visual_verification": visual,
        "decision": "CONTINUE_CORRECTION_CHAIN" if status != "VERIFIED_COMPLETE" else "STOP_VERIFIED"
    }

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 3:
        print(json.dumps({
            "status": "INVALID_ARGUMENTS",
            "usage": "closed_verification_loop.py <old_text> <new_text>"
        }, indent=2))
        raise SystemExit(1)

    print(json.dumps(
        closed_verify_text(sys.argv[1], sys.argv[2]),
        indent=2
    ))
