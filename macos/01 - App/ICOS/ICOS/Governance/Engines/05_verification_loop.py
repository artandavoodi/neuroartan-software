from pathlib import Path
import subprocess

ROOT = Path("/Users/artan/Documents/Neuroartan/website")

def git_status():
    return subprocess.run(["git", "status", "--short"], cwd=ROOT, text=True, capture_output=True).stdout

def git_diff():
    return subprocess.run(["git", "diff", "--", "."], cwd=ROOT, text=True, capture_output=True).stdout

def verify_file_contains(path, text):
    p = Path(path)
    return p.exists() and text in p.read_text(errors="ignore")
