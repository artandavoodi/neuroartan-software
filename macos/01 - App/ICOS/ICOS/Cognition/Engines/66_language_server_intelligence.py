
from pathlib import Path
import json
import re
from collections import defaultdict

ROOT = Path("/Users/artan/Documents/Neuroartan/website")
GRAPH_FILE = Path(__file__).resolve().parent / "repository_semantic_memory_graph.json"

IGNORE = {
    ".git",
    ".github",
    ".aider.tags.cache.v4",
    "node_modules",
    ".next",
    "dist",
    "build",
    ".DS_Store"
}

SOURCE_SUFFIXES = {
    ".css",
    ".scss",
    ".js",
    ".ts",
    ".mjs",
    ".html",
    ".md",
    ".json"
}

SYMBOL_PATTERNS = {
    "css_selector": re.compile(r"([.#][A-Za-z0-9_-]+)\s*\{"),
    "css_token": re.compile(r"var\((--[A-Za-z0-9_-]+)\)"),
    "js_function": re.compile(r"function\s+([A-Za-z0-9_]+)"),
    "js_const": re.compile(r"const\s+([A-Za-z0-9_]+)\s*="),
    "js_class": re.compile(r"class\s+([A-Za-z0-9_]+)"),
    "html_id": re.compile(r"id=[\"']([^\"']+)[\"']"),
    "html_class": re.compile(r"class=[\"']([^\"']+)[\"']"),
}


def ignored(path: Path) -> bool:
    return any(part in IGNORE for part in path.parts)


def safe_read(path: Path) -> str:
    try:
        return path.read_text(errors="ignore")
    except Exception:
        return ""


def classify(path: Path) -> str:
    s = str(path).lower()

    if "/docs/assets/css/core/" in s:
        return "global-css"
    if "/docs/assets/js/core/" in s:
        return "global-js"
    if "/docs/assets/css/layers/" in s:
        return "layer-css"
    if "/docs/assets/js/layers/" in s:
        return "layer-js"
    if "/docs/pages/" in s:
        return "page"
    if "/server/" in s:
        return "server"
    if "/supabase/" in s:
        return "database"
    if "/planning/" in s:
        return "planning"

    return "general"


def extract_symbols(path: Path, content: str):
    symbols = []

    for kind, pattern in SYMBOL_PATTERNS.items():
        for match in pattern.findall(content):
            if isinstance(match, tuple):
                match = next((m for m in match if m), "")
            if not match:
                continue

            symbols.append({
                "kind": kind,
                "name": match,
                "file": str(path)
            })

    return symbols


def inspect_project():
    files = []
    symbols = []
    categories = defaultdict(list)

    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        if ignored(path):
            continue
        if path.suffix not in SOURCE_SUFFIXES:
            continue

        category = classify(path)
        content = safe_read(path)

        record = {
            "path": str(path),
            "suffix": path.suffix,
            "category": category,
            "lines": len(content.splitlines()),
            "size": path.stat().st_size,
        }

        files.append(record)
        categories[category].append(str(path))
        symbols.extend(extract_symbols(path, content))

    result = {
        "status": "OK",
        "root": str(ROOT),
        "file_count": len(files),
        "symbol_count": len(symbols),
        "categories": {k: len(v) for k, v in sorted(categories.items())},
        "files": files,
        "symbols": symbols,
    }

    return result


def find_symbol(query: str):
    data = inspect_project()
    q = query.lower()

    matches = [
        symbol for symbol in data["symbols"]
        if q in symbol["name"].lower()
    ]

    return {
        "status": "OK",
        "query": query,
        "matches": matches
    }


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 2 and sys.argv[1] == "find":
        print(json.dumps(find_symbol(" ".join(sys.argv[2:])), indent=2))
    else:
        summary = inspect_project()
        print(json.dumps({
            "status": summary["status"],
            "root": summary["root"],
            "file_count": summary["file_count"],
            "symbol_count": summary["symbol_count"],
            "categories": summary["categories"]
        }, indent=2))
