from pathlib import Path
import json
from datetime import datetime

MEMORY_FILE = Path(__file__).resolve().parent / "repository_reasoning_memory.json"

def load():
    if not MEMORY_FILE.exists():
        return []
    return json.loads(MEMORY_FILE.read_text())

def record(event_type, payload):
    data = load()
    data.append({
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "event_type": event_type,
        "payload": payload
    })
    MEMORY_FILE.write_text(json.dumps(data, indent=2))
    return data[-1]

def search(query):
    q = query.lower()
    return [x for x in load() if q in json.dumps(x).lower()]

if __name__ == "__main__":
    print(json.dumps(load(), indent=2))
