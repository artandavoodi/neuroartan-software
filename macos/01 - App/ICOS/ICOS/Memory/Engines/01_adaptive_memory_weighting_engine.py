"""
ICOS Adaptive Memory Weighting Engine

Canonical Responsibility:
- adaptive memory weighting
- recurrence-aware memory prioritization
- contextual importance scoring
- emotional weighting
- behavioral reinforcement
- continuity relevance modeling
- long-range memory prioritization

IMPORTANT:
This layer owns memory weighting.
It does NOT own:
- cognition authority
- governance authority
- execution infrastructure
- provider intelligence
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

class MemoryPriority(str, Enum):
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    CRITICAL = "critical"

@dataclass
class WeightedMemory:
    memory_id: str
    content: str
    category: str
    emotional_weight: float = 0.0
    behavioral_weight: float = 0.0
    recurrence_weight: float = 0.0
    contextual_weight: float = 0.0
    continuity_weight: float = 0.0
    total_weight: float = 0.0
    priority: MemoryPriority = MemoryPriority.NORMAL
    created_at: datetime = field(default_factory=datetime.utcnow)
    metadata: Dict[str, Any] = field(default_factory=dict)

class AdaptiveMemoryWeightingEngine:
    """
    Sovereign adaptive memory authority.

    Responsibilities:
    - memory prioritization
    - contextual weighting
    - emotional weighting
    - recurrence analysis
    - continuity relevance
    - adaptive reinforcement
    """

    def __init__(self) -> None:
        self.memories: Dict[str, WeightedMemory] = {}

        self.runtime_state: Dict[str, Any] = {
            "memory_weighting_initialized": True,
            "weighted_memories": 0,
            "priority_memories": 0,
        }

    def register_memory(
        self,
        memory: WeightedMemory,
    ) -> None:
        memory.total_weight = self.calculate_total_weight(memory)

        memory.priority = self.calculate_priority(memory.total_weight)

        self.memories[memory.memory_id] = memory

        self.runtime_state["weighted_memories"] = len(
            self.memories
        )

        self.runtime_state["priority_memories"] = len(
            [
                memory
                for memory in self.memories.values()
                if memory.priority in [
                    MemoryPriority.HIGH,
                    MemoryPriority.CRITICAL,
                ]
            ]
        )

    def calculate_total_weight(
        self,
        memory: WeightedMemory,
    ) -> float:
        total = (
            memory.emotional_weight * 0.25
            + memory.behavioral_weight * 0.20
            + memory.recurrence_weight * 0.20
            + memory.contextual_weight * 0.15
            + memory.continuity_weight * 0.20
        )

        return round(total, 3)

    def calculate_priority(
        self,
        total_weight: float,
    ) -> MemoryPriority:
        if total_weight >= 0.85:
            return MemoryPriority.CRITICAL

        if total_weight >= 0.65:
            return MemoryPriority.HIGH

        if total_weight >= 0.35:
            return MemoryPriority.NORMAL

        return MemoryPriority.LOW

    def reinforce_memory(
        self,
        memory_id: str,
        reinforcement: float = 0.05,
    ) -> Optional[WeightedMemory]:
        memory = self.memories.get(memory_id)

        if memory is None:
            return None

        memory.recurrence_weight = min(
            1.0,
            memory.recurrence_weight + reinforcement,
        )

        memory.total_weight = self.calculate_total_weight(memory)

        memory.priority = self.calculate_priority(
            memory.total_weight
        )

        return memory

    def retrieve_priority_memories(
        self,
        minimum_priority: MemoryPriority = MemoryPriority.HIGH,
    ) -> List[WeightedMemory]:
        priority_order = {
            MemoryPriority.LOW: 0,
            MemoryPriority.NORMAL: 1,
            MemoryPriority.HIGH: 2,
            MemoryPriority.CRITICAL: 3,
        }

        minimum_value = priority_order[minimum_priority]

        return [
            memory
            for memory in self.memories.values()
            if priority_order[memory.priority] >= minimum_value
        ]

    def export_runtime_state(self) -> Dict[str, Any]:
        return {
            "runtime_state": self.runtime_state,
            "memories": [
                {
                    "memory_id": memory.memory_id,
                    "category": memory.category,
                    "priority": memory.priority.value,
                    "total_weight": memory.total_weight,
                }
                for memory in self.memories.values()
            ],
        }

if __name__ == "__main__":
    engine = AdaptiveMemoryWeightingEngine()

    memory = WeightedMemory(
        memory_id="memory::001",
        content="Founder-level ambient cognition realization",
        category="strategic_realization",
        emotional_weight=0.9,
        behavioral_weight=0.8,
        recurrence_weight=0.7,
        contextual_weight=0.9,
        continuity_weight=1.0,
    )

    engine.register_memory(memory)

    reinforced = engine.reinforce_memory(
        memory_id="memory::001",
        reinforcement=0.1,
    )

    print(
        {
            "priority": reinforced.priority.value,
            "total_weight": reinforced.total_weight,
            "runtime_state": engine.export_runtime_state(),
        }
    )