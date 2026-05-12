from pathlib import Path
import json
import subprocess

ROOT = Path("/Users/artan/Documents/Neuroartan/website")

def search_text(old_text, new_text):
    matches = []

    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue

        if path.suffix not in [".html", ".js", ".css", ".md", ".json"]:
            continue

        text = path.read_text(errors="ignore")

        if old_text in text or new_text in text:
            matches.append({
                "path": str(path),
                "contains_old": old_text in text,
                "contains_new": new_text in text,
                "type": path.suffix
            })

    return matches

def verify_text_replacement(old_text, new_text):
    matches = search_text(old_text, new_text)

    old_remaining = [m for m in matches if m["contains_old"]]
    new_present = [m for m in matches if m["contains_new"]]

    status = "VERIFIED_COMPLETE"

    if old_remaining:
        status = "RUNTIME_OWNER_MISMATCH"

    return {
        "status": status,
        "old_text": old_text,
        "new_text": new_text,
        "new_present": new_present,
        "old_remaining": old_remaining,
        "diagnosis": "Static fragment changed but runtime JS still owns/overwrites visible text." if old_remaining else "All known owners updated."
    }

if __name__ == "__main__":
    import sys

    old_text = sys.argv[1]
    new_text = sys.argv[2]

    print(json.dumps(
        verify_text_replacement(old_text, new_text),
        indent=2
    ))
