"""
ICOS Runtime Event Bus

Canonical Responsibility:
- runtime synchronization
- cross-layer event propagation
- cognition/runtime communication
- memory-event coordination
- provider/model synchronization
- execution-event routing
- system-wide runtime signaling

IMPORTANT:
This layer owns runtime communication.
It does NOT own:
- cognition
- governance authority
- provider intelligence
- memory persistence
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Callable, DefaultDict, Dict, List

from collections import defaultdict


class EventPriority(str, Enum):
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    CRITICAL = "critical"


@dataclass
class RuntimeEvent:
    event_id: str
    event_type: str
    source: str
    payload: Dict[str, Any] = field(default_factory=dict)
    priority: EventPriority = EventPriority.NORMAL
    timestamp: datetime = field(default_factory=datetime.utcnow)


class RuntimeEventBus:
    """
    Sovereign runtime synchronization authority.

    Responsibilities:
    - runtime signaling
    - cross-layer synchronization
    - cognition/runtime coordination
    - provider/model synchronization
    - execution-event propagation
    - event orchestration
    """

    def __init__(self) -> None:
        self.subscribers: DefaultDict[
            str,
            List[Callable[[RuntimeEvent], None]],
        ] = defaultdict(list)

        self.event_history: List[RuntimeEvent] = []

        self.runtime_state: Dict[str, Any] = {
            "event_bus_initialized": True,
            "events_published": 0,
            "events_processed": 0,
            "registered_channels": 0,
        }

    def subscribe(
        self,
        event_type: str,
        handler: Callable[[RuntimeEvent], None],
    ) -> None:
        self.subscribers[event_type].append(handler)

        self.runtime_state["registered_channels"] = len(
            self.subscribers
        )

    def unsubscribe(
        self,
        event_type: str,
        handler: Callable[[RuntimeEvent], None],
    ) -> None:
        if handler in self.subscribers[event_type]:
            self.subscribers[event_type].remove(handler)

    def publish(self, event: RuntimeEvent) -> None:
        self.event_history.append(event)

        self.runtime_state["events_published"] += 1

        handlers = self.subscribers.get(event.event_type, [])

        for handler in handlers:
            try:
                handler(event)
                self.runtime_state["events_processed"] += 1
            except Exception as error:
                print(
                    f"Runtime event handler error: {error}"
                )

    def emit(
        self,
        event_id: str,
        event_type: str,
        source: str,
        payload: Dict[str, Any] | None = None,
        priority: EventPriority = EventPriority.NORMAL,
    ) -> RuntimeEvent:
        event = RuntimeEvent(
            event_id=event_id,
            event_type=event_type,
            source=source,
            payload=payload or {},
            priority=priority,
        )

        self.publish(event)

        return event

    def get_recent_events(
        self,
        limit: int = 10,
    ) -> List[RuntimeEvent]:
        return self.event_history[-limit:]

    def export_runtime_state(self) -> Dict[str, Any]:
        return {
            "runtime_state": self.runtime_state,
            "channels": list(self.subscribers.keys()),
            "recent_events": [
                {
                    "event_id": event.event_id,
                    "event_type": event.event_type,
                    "source": event.source,
                    "priority": event.priority.value,
                    "timestamp": event.timestamp.isoformat(),
                }
                for event in self.get_recent_events()
            ],
        }


if __name__ == "__main__":
    bus = RuntimeEventBus()

    def cognition_listener(event: RuntimeEvent) -> None:
        print(
            f"[COGNITION] Received: {event.event_type}"
        )

    bus.subscribe(
        event_type="runtime.execution.completed",
        handler=cognition_listener,
    )

    emitted = bus.emit(
        event_id="event::001",
        event_type="runtime.execution.completed",
        source="ExecutionVerificationLoop",
        payload={
            "status": "verified",
        },
        priority=EventPriority.HIGH,
    )

    print(
        {
            "event": emitted.event_id,
            "runtime_state": bus.export_runtime_state(),
        }
    )