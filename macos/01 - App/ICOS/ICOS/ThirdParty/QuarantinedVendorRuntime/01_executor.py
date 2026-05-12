import sys
from pathlib import Path

RUNTIME = Path(__file__).parent
sys.path.append(str(RUNTIME))

import scanner
import verifier
import resolver
import ranker
import memory_manager
import editor

def inject_memory():
    memory = memory_manager.load_memory()

    print("\n=== MEMORY ===")
    for m in memory[-5:]:
        print("-", m["memory"])

def run():
    inject_memory()

    print("\n=== SCAN ===")
    data = scanner.scan()

    print("Folders:", len(data["folders"]))
    print("Files:", len(data["files"]))

    print("\n=== RESOLVE ===")
    candidates = resolver.resolve()
    candidates = verifier.filter_existing(candidates)

    print("\n=== RANK ===")
    ranked = ranker.rank(candidates)

    for c in ranked[:20]:
        print(c)

    if ranked:
        primary = ranked[0]

        print("\n=== PRIMARY OWNER ===")
        print(primary)

        print("\n=== FILE PREVIEW ===")
        try:
            preview = editor.read_file(primary)
            print(preview[:2000])
        except Exception as e:
            print("EDITOR ERROR:", e)

    print("\n=== DONE ===")

if __name__ == "__main__":
    run()
