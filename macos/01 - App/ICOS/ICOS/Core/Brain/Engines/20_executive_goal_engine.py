# ============================================================
# ICOS · Executive Goal Engine
# ============================================================

from pathlib import Path
from typing import Any
import json
import time

# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

BRAIN_ROOT = ROOT / "Core" / "Brain"

STATE_ROOT = BRAIN_ROOT / "State"
MEMORY_ROOT = BRAIN_ROOT / "Memory"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"
LEARNING_ROOT = BRAIN_ROOT / "Learning"

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

COGNITIVE_GRAPH = (
    MEMORY_ROOT / "persistent_cognitive_graph.json"
)

GOAL_STORE = (
    MEMORY_ROOT / "executive_goal_store.json"
)

EXECUTION_LOG = (
    REFLECTION_ROOT / "executive_goal_log.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

# ============================================================
# Executive Goal Engine
# ============================================================

class ExecutiveGoalEngine:
    """
    ICOS long-horizon executive orchestration engine.

    Responsibilities:
    - maintain long-term objectives
    - persist strategic continuity
    - recursively prioritize goals
    - track execution progress
    - adapt orchestration direction
    - preserve sovereign mission continuity
    """

    def __init__(self) -> None:
        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.cognitive_graph = self._load_json(
            COGNITIVE_GRAPH,
            fallback={}
        )

        self.learning_log = self._load_json(
            LEARNING_LOG,
            fallback=[]
        )

        self.goal_store = self._load_json(
            GOAL_STORE,
            fallback={
                "active_goals": [],
                "completed_goals": [],
                "goal_history": []
            }
        )

        self.execution_log = self._load_json(
            EXECUTION_LOG,
            fallback=[]
        )

    # ========================================================
    # JSON Loading
    # ========================================================

    def _load_json(
        self,
        path: Path,
        fallback: Any = None,
    ) -> Any:

        if not path.exists():
            return fallback

        try:
            return json.loads(path.read_text())
        except Exception:
            return fallback

    # ========================================================
    # Goal Registration
    # ========================================================

    def register_goal(
        self,
        title: str,
        priority: str,
        category: str,
    ) -> dict[str, Any]:

        goal = {
            "title": title,
            "priority": priority,
            "category": category,
            "status": "active",
            "created_at": time.time(),
        }

        self.goal_store[
            "active_goals"
        ].append(goal)

        self.goal_store[
            "goal_history"
        ].append(goal)

        GOAL_STORE.write_text(
            json.dumps(
                self.goal_store,
                indent=2,
            )
        )

        return goal

    # ========================================================
    # Goal Prioritization
    # ========================================================

    def prioritize_goals(self) -> list[dict[str, Any]]:

        order = {
            "critical": 0,
            "high": 1,
            "medium": 2,
            "low": 3,
        }

        goals = self.goal_store.get(
            "active_goals",
            []
        )

        goals = sorted(
            goals,
            key=lambda g: order.get(
                g.get("priority", "medium"),
                2,
            )
        )

        return goals

    # ========================================================
    # Strategic Reflection
    # ========================================================

    def strategic_reflection(self) -> dict[str, Any]:

        goals = self.prioritize_goals()

        reflection = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "continuity_graph_active": bool(
                self.cognitive_graph
            ),
            "learning_events": len(
                self.learning_log
            ),
            "active_goals": len(goals),
            "highest_priority_goal": (
                goals[0]["title"] if goals else None
            ),
            "executive_continuity": True,
        }

        self.execution_log.append(reflection)

        EXECUTION_LOG.write_text(
            json.dumps(
                self.execution_log,
                indent=2,
            )
        )

        return reflection

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = ExecutiveGoalEngine()

    engine.register_goal(
        title="Develop sovereign cognitive operating system",
        priority="critical",
        category="architecture",
    )

    engine.register_goal(
        title="Expand recursive cognition",
        priority="high",
        category="cognition",
    )

    reflection = engine.strategic_reflection()

    print(json.dumps({
        "status": "ICOS_EXECUTIVE_GOAL_ENGINE_ACTIVE",
        "reflection": reflection,
        "prioritized_goals": engine.prioritize_goals(),
    }, indent=2))