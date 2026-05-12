from __future__ import annotations

from typing import Any, Dict, List

class SharedMultiAgentMemory:
    def __init__(self) -> None:
        self.memory: List[Dict[str, Any]] = []

    def append(self, item: Dict[str, Any]) -> None:
        self.memory.append(item)

    def read(self) -> List[Dict[str, Any]]:
        return list(self.memory)
