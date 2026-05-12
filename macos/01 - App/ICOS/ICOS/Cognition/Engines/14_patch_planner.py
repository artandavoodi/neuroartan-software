from pathlib import Path
import json

def plan_patch(file_path, intent):
    p = Path(file_path)
    if not p.exists():
        return {"status": "INVALID_FILE", "file": file_path}

    content = p.read_text(errors="ignore")
    return {
        "status": "PATCH_PLAN_READY",
        "file": str(p),
        "intent": intent,
        "requires_manual_target": True,
        "safe": True,
        "evidence_excerpt": content[:1200]
    }

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("usage: patch_planner.py <file> <intent>")
        raise SystemExit(1)
    print(json.dumps(plan_patch(sys.argv[1], " ".join(sys.argv[2:])), indent=2))
