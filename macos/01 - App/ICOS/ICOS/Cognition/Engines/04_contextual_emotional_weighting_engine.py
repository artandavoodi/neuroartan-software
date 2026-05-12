"""
ICOS Contextual Emotional Weighting Engine

Canonical Responsibility:
- contextual emotional interpretation
- emotional salience modeling
- adaptive emotional weighting
- priority modulation
- behavioral-affective reinforcement
- contextual cognition shaping
- emotional continuity analysis

IMPORTANT:
This layer owns emotional-context cognition.
It does NOT own:
- governance authority
- execution infrastructure
- provider routing
- runtime synchronization
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional


class EmotionalState(str, Enum):
    NEUTRAL = "neutral"
    FOCUSED = "focused"
    REFLECTIVE = "reflective"
    URGENT = "urgent"
    CREATIVE = "creative"
    STRESSED = "stressed"
    MOTIVATED = "motivated"
    FATIGUED = "fatigued"


class EmotionalPriority(str, Enum):
    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"
    CRITICAL = "critical"


@dataclass
class EmotionalContext:
    context_id: str
    emotional_state: EmotionalState
    source: str
    intensity: float
    continuity_relevance: float = 0.0
    behavioral_alignment: float = 0.0
    contextual_relevance: float = 0.0
    created_at: datetime = field(default_factory=datetime.utcnow)
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class EmotionalWeighting:
    weighting_id: str
    context_id: str
    total_weight: float
    priority: EmotionalPriority
    recommendations: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)


class ContextualEmotionalWeightingEngine:
    """
    Sovereign emotional-context cognition authority.

    Responsibilities:
    - emotional salience
    - contextual weighting
    - affective interpretation
    - priority shaping
    - continuity-aware emotional cognition
    - adaptive emotional reinforcement
    """

    def __init__(self) -> None:
        self.contexts: Dict[str, EmotionalContext] = {}
        self.weightings: Dict[str, EmotionalWeighting] = {}

        self.runtime_state: Dict[str, Any] = {
            "emotional_engine_initialized": True,
            "contexts_registered": 0,
            "weightings_generated": 0,
            "high_priority_contexts": 0,
        }

    def register_context(
        self,
        context: EmotionalContext,
    ) -> None:
        self.contexts[context.context_id] = context

        self.runtime_state["contexts_registered"] = len(
            self.contexts
        )

    def calculate_weighting(
        self,
        weighting_id: str,
        context_id: str,
    ) -> EmotionalWeighting:
        context = self.contexts.get(context_id)

        if context is None:
            raise ValueError(
                f"Unknown emotional context: {context_id}"
            )

        total_weight = round(
            context.intensity * 0.35
            + context.continuity_relevance * 0.25
            + context.behavioral_alignment * 0.20
            + context.contextual_relevance * 0.20,
            3,
        )

        priority = EmotionalPriority.NORMAL

        if total_weight >= 0.85:
            priority = EmotionalPriority.CRITICAL

        elif total_weight >= 0.65:
            priority = EmotionalPriority.HIGH

        elif total_weight < 0.35:
            priority = EmotionalPriority.LOW

        recommendations: List[str] = []

        if context.emotional_state == EmotionalState.STRESSED:
            recommendations.append(
                "reduce_cognitive_overload"
            )

        if context.emotional_state == EmotionalState.CREATIVE:
            recommendations.append(
                "increase_exploratory_reasoning"
            )

        if context.emotional_state == EmotionalState.FOCUSED:
            recommendations.append(
                "prioritize_execution_alignment"
            )

        weighting = EmotionalWeighting(
            weighting_id=weighting_id,
            context_id=context.context_id,
            total_weight=total_weight,
            priority=priority,
            recommendations=recommendations,
        )

        self.weightings[weighting_id] = weighting

        self.runtime_state["weightings_generated"] += 1

        self.runtime_state["high_priority_contexts"] = len(
            [
                weighting
                for weighting in self.weightings.values()
                if weighting.priority in [
                    EmotionalPriority.HIGH,
                    EmotionalPriority.CRITICAL,
                ]
            ]
        )

        return weighting

    def retrieve_priority_contexts(
        self,
        minimum_priority: EmotionalPriority = EmotionalPriority.HIGH,
    ) -> List[EmotionalWeighting]:
        priority_order = {
            EmotionalPriority.LOW: 0,
            EmotionalPriority.NORMAL: 1,
            EmotionalPriority.HIGH: 2,
            EmotionalPriority.CRITICAL: 3,
        }

        minimum_value = priority_order[minimum_priority]

        return [
            weighting
            for weighting in self.weightings.values()
            if priority_order[weighting.priority] >= minimum_value
        ]

    def export_runtime_state(self) -> Dict[str, Any]:
        return {
            "runtime_state": self.runtime_state,
            "contexts": [
                {
                    "context_id": context.context_id,
                    "emotional_state": context.emotional_state.value,
                    "source": context.source,
                    "intensity": context.intensity,
                }
                for context in self.contexts.values()
            ],
            "weightings": [
                {
                    "weighting_id": weighting.weighting_id,
                    "context_id": weighting.context_id,
                    "priority": weighting.priority.value,
                    "total_weight": weighting.total_weight,
                }
                for weighting in self.weightings.values()
            ],
        }


if __name__ == "__main__":
    engine = ContextualEmotionalWeightingEngine()

    context = EmotionalContext(
        context_id="context::001",
        emotional_state=EmotionalState.FOCUSED,
        source="voice_reflection",
        intensity=0.92,
        continuity_relevance=0.95,
        behavioral_alignment=0.88,
        contextual_relevance=0.90,
    )

    engine.register_context(context)

    weighting = engine.calculate_weighting(
        weighting_id="weighting::001",
        context_id="context::001",
    )

    print(
        {
            "priority": weighting.priority.value,
            "total_weight": weighting.total_weight,
            "recommendations": weighting.recommendations,
            "runtime_state": engine.export_runtime_state(),
        }
    )