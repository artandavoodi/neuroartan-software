import json
from pathlib import Path
from datetime import datetime

MEMORY_FILE = Path("/Users/artan/Documents/Neuroartan/software/icos/memory/memory.json")

def load_memory():
    if not MEMORY_FILE.exists() or MEMORY_FILE.read_text().strip() == "":
        return []
    return json.loads(MEMORY_FILE.read_text())

def save_memory(items):
    MEMORY_FILE.parent.mkdir(parents=True, exist_ok=True)
    MEMORY_FILE.write_text(json.dumps(items, indent=2, ensure_ascii=False))

def remember(text, source="user"):
    items = load_memory()
    items.append({
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "source": source,
        "memory": text
    })
    save_memory(items)
    return items[-1]

def search_memory(query):
    q = query.lower()
    return [m for m in load_memory() if q in m["memory"].lower()]

if __name__ == "__main__":
    import sys
    if len(sys.argv) >= 3 and sys.argv[1] == "remember":
        print(json.dumps(remember(" ".join(sys.argv[2:])), indent=2))
    elif len(sys.argv) >= 3 and sys.argv[1] == "search":
        print(json.dumps(search_memory(" ".join(sys.argv[2:])), indent=2))
    else:
        print(json.dumps(load_memory(), indent=2))
