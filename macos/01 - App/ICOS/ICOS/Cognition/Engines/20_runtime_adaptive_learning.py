from pathlib import Path
import json
from datetime import datetime

LEARNING_FILE = Path(__file__).resolve().parent / "runtime_adaptive_learning.json"

def record_feedback(task, result, lesson):
    data = []
    if LEARNING_FILE.exists():
        data = json.loads(LEARNING_FILE.read_text())
    data.append({
        "created_at": datetime.now().isoformat(timespec="seconds"),
        "task": task,
        "result": result,
        "lesson": lesson
    })
    LEARNING_FILE.write_text(json.dumps(data, indent=2))
    return data[-1]

if __name__ == "__main__":
    print(json.dumps(record_feedback(
        "bootstrap",
        "ready",
        "always verify file existence before proposing edits"
    ), indent=2))
