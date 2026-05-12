from __future__ import annotations

import json
import hashlib
from dataclasses import dataclass, asdict
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

STATE_PATH = Path(__file__).with_name(
    "constitutional_memory_state.json"
)

GRAPH_PATH = Path(__file__).with_name(
    "constitutional_memory_graph.json"
)


@dataclass
class MemoryEvent:
    key: str
    value: Any
    scope: str = "institutional"
    priority: int = 0
    timestamp: str = ""
    tags: Optional[List[str]] = None
    source: str = "ICOS"


class PersistentConstitutionalMemoryEngine:
    def __init__(
        self,
        state_path: Path = STATE_PATH
    ) -> None:
        self.state_path = state_path
        self.state = self._load()

    def _default_state(self) -> Dict[str, Any]:
        return {
            "version": 2,
            "events": [],
            "profiles": {},
            "priorities": {},
            "routing": {},
            "temporal_index": {},
            "semantic_index": {},
            "project_memory": {},
            "agent_memory": {},
            "last_update": None
        }

    def _load(self) -> Dict[str, Any]:
        default_state = self._default_state()

        if self.state_path.exists():
            try:
                loaded = json.loads(
                    self.state_path.read_text(
                        encoding="utf-8"
                    )
                )

                for key, value in default_state.items():
                    if key not in loaded:
                        loaded[key] = value

                loaded["version"] = max(
                    loaded.get("version", 1),
                    default_state["version"]
                )

                return loaded

            except Exception:
                pass

        return default_state

    def _save(self) -> None:
        self.state_path.write_text(
            json.dumps(
                self.state,
                indent=2,
                ensure_ascii=False
            ),
            encoding="utf-8"
        )

    def _now(self) -> str:
        return datetime.now().isoformat(timespec="seconds")

    def _event_hash(self, event: MemoryEvent) -> str:
        payload = f"{event.key}:{event.scope}:{event.timestamp}"

        return hashlib.sha1(
            payload.encode()
        ).hexdigest()[:12]

    def _update_temporal_index(
        self,
        event_id: str,
        timestamp: str
    ) -> None:
        day = timestamp.split("T")[0]

        if day not in self.state["temporal_index"]:
            self.state["temporal_index"][day] = []

        self.state["temporal_index"][day].append(event_id)

    def _update_semantic_index(
        self,
        event_id: str,
        event: MemoryEvent
    ) -> None:
        tags = event.tags or []

        for tag in tags:
            if tag not in self.state["semantic_index"]:
                self.state["semantic_index"][tag] = []

            self.state["semantic_index"][tag].append(event_id)

    def _update_project_memory(
        self,
        event_id: str,
        event: MemoryEvent
    ) -> None:
        if event.scope != "project":
            return

        if event.key not in self.state["project_memory"]:
            self.state["project_memory"][event.key] = []

        self.state["project_memory"][event.key].append(event_id)

    def _update_agent_memory(
        self,
        event_id: str,
        event: MemoryEvent
    ) -> None:
        if event.scope != "agent":
            return

        if event.key not in self.state["agent_memory"]:
            self.state["agent_memory"][event.key] = []

        self.state["agent_memory"][event.key].append(event_id)

    def record(self, event: MemoryEvent) -> Dict[str, Any]:
        if not event.timestamp:
            event.timestamp = self._now()

        payload = asdict(event)

        event_id = self._event_hash(event)

        payload["event_id"] = event_id

        self.state["events"].append(payload)

        self.state["profiles"][event.key] = event.value

        self.state["priorities"][event.key] = event.priority

        self._update_temporal_index(
            event_id,
            event.timestamp
        )

        self._update_semantic_index(
            event_id,
            event
        )

        self._update_project_memory(
            event_id,
            event
        )

        self._update_agent_memory(
            event_id,
            event
        )

        self.state["last_update"] = event.timestamp

        self._save()

        return payload

    def get(
        self,
        key: str,
        default: Optional[Any] = None
    ) -> Any:
        return self.state["profiles"].get(
            key,
            default
        )

    def retrieve_by_tag(
        self,
        tag: str
    ) -> List[Dict[str, Any]]:
        ids = self.state["semantic_index"].get(
            tag,
            []
        )

        return [
            e for e in self.state["events"]
            if e.get("event_id") in ids
        ]

    def retrieve_recent(
        self,
        limit: int = 10
    ) -> List[Dict[str, Any]]:
        return self.state["events"][-limit:]

    def memory_summary(self) -> Dict[str, Any]:
        return {
            "status": "PERSISTENT_MEMORY_ACTIVE",
            "version": self.state.get("version"),
            "event_count": len(self.state["events"]),
            "profile_count": len(self.state["profiles"]),
            "semantic_tags": len(self.state["semantic_index"]),
            "project_memories": len(self.state["project_memory"]),
            "agent_memories": len(self.state["agent_memory"]),
            "graph_connected": GRAPH_PATH.exists(),
            "last_update": self.state.get("last_update")
        }


ENGINE = PersistentConstitutionalMemoryEngine()


if __name__ == "__main__":
    sample = ENGINE.record(
        MemoryEvent(
            key="icos_sovereign_cognition",
            value={
                "maturity": "72/100",
                "state": "persistent constitutional memory operational"
            },
            scope="project",
            priority=10,
            tags=[
                "icos",
                "memory",
                "sovereign-cognition"
            ],
            source="ICOS_RUNTIME"
        )
    )

    print(json.dumps({
        "recorded": sample,
        "summary": ENGINE.memory_summary()
    }, indent=2))
