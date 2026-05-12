from pathlib import Path
import json

BASE = Path(__file__).resolve().parent
REGISTRY = BASE.parent / "MCP" / "identity_registry.json"
PRELOAD_FILE = BASE / "system_preload_context.md"

def load_identity():
    fallback = {
    "company": "Neuroartan",
    "product": "ICOS",
    "model": "WSDA",
    "identity": "ICOS",
    "runtime": "ContinueBridge",
    "source": "registry"
}
    try:
        if REGISTRY.exists():
            return {**fallback, **json.loads(REGISTRY.read_text(encoding="utf-8"))}
    except Exception:
        pass
    return fallback

def build_preload():
    identity = load_identity()
    lines = []
    lines.append("# ICOS System Preload Context")
    lines.append("")
    lines.append("# Neuroartan Runtime Identity")
    lines.append("")
    lines.append("Identity is resolved from the runtime registry.")
    lines.append("")
    lines.append(f"Core identity: {identity['identity']}")
    lines.append(f"Company: {identity['company']}")
    lines.append(f"Product: {identity['product']}")
    lines.append(f"Model/Role: {identity['model']}")
    lines.append(f"Runtime: {identity['runtime']}")
    lines.append("")
    lines.append("Required self-answer:")
    lines.append("- If asked who are you, answer using the runtime registry identity.")
    lines.append("- Do not identify as Claude, ChatGPT, OpenAI, or a generic assistant.")
    lines.append("")
    lines.append("Operational rule:")
    lines.append("- Use verified runtime files before editing.")
    lines.append("- If the user says remember, route to memory.")
    lines.append("")
    PRELOAD_FILE.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return PRELOAD_FILE

if __name__ == "__main__":
    print(build_preload())
