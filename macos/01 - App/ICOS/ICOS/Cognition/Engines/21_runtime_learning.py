from pathlib import Path
import json
from datetime import datetime

LEARNING_FILE = Path(__file__).resolve().parent / "runtime_learning.json"

def learn(observation, correction=None):
    data = []
    if LEARNING_FILE.exists():
        data = json.loads(LEARNING_FILE.read_text())
    data.append({
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "observation": observation,
        "correction": correction
    })
    LEARNING_FILE.write_text(json.dumps(data, indent=2))
    return data[-1]
