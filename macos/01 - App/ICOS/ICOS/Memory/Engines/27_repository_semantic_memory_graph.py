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
    "build"
}

IMPORT_PATTERNS = [
    re.compile(r'@import\s+["\']([^"\']+)["\']'),
    re.compile(r'import\s+.*?from\s+["\']([^"\']+)["\']'),
    re.compile(r'import\s+["\']([^"\']+)["\']'),
    re.compile(r'<script[^>]+src=["\']([^"\']+)["\']'),
    re.compile(r'<link[^>]+href=["\']([^"\']+)["\']')
]

TEXT_SUFFIXES = {
    ".css",
    ".scss",
    ".js",
    ".ts",
    ".mjs",
    ".html",
    ".md",
    ".json"
}


def ignored(path: Path):
    return any(part in IGNORE for part in path.parts)


def classify(path: Path):
    s = str(path).lower()

    if "/css/core/" in s:
        return "global-css"

    if "/js/core/" in s:
        return "global-js"

    if "/css/layers/" in s:
        return "layer-css"

    if "/js/layers/" in s:
        return "layer-js"

    if "/pages/" in s:
        return "page"

    return "general"


def safe_read(path: Path):
    try:
        return path.read_text(errors="ignore")
    except Exception:
        return ""


def resolve_relative(base: Path, ref: str):
    if ref.startswith(("http://", "https://", "#")):
        return None

    candidate = (base.parent / ref).resolve()

    if candidate.exists():
        return str(candidate)

    for ext in ["", ".js", ".css", ".scss", ".html", ".ts"]:
        c = Path(str(candidate) + ext)

        if c.exists():
            return str(c)

    return None


def extract_imports(path: Path, content: str):
    imports = []

    for pattern in IMPORT_PATTERNS:
        for match in pattern.findall(content):
            resolved = resolve_relative(path, match)

            if resolved:
                imports.append(resolved)

    return sorted(set(imports))


def build_graph():
    nodes = []
    edges = []

    semantic_index = defaultdict(list)

    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue

        if ignored(path):
            continue

        content = ""

        if path.suffix in TEXT_SUFFIXES:
            content = safe_read(path)

        imports = extract_imports(path, content)

        node = {
            "path": str(path),
            "name": path.name,
            "suffix": path.suffix,
            "category": classify(path),
            "imports": imports,
            "size": path.stat().st_size,
        }

        nodes.append(node)

        semantic_index[path.suffix].append(str(path))

        for dep in imports:
            edges.append({
                "from": str(path),
                "to": dep,
                "type": "import"
            })

    graph = {
        "root": str(ROOT),
        "nodes": nodes,
        "edges": edges,
        "semantic_index": dict(semantic_index)
    }

    GRAPH_FILE.write_text(json.dumps(graph, indent=2))

    print("=== SEMANTIC GRAPH BUILT ===")
    print("Nodes:", len(nodes))
    print("Edges:", len(edges))
    print("Graph:", GRAPH_FILE)

    return GRAPH_FILE


if __name__ == "__main__":
    print(build_graph())
