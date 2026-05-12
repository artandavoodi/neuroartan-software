# ============================================================
# ICOS · Autonomous Cognitive Router
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

REGISTRY_ROOT = BRAIN_ROOT / "Registries"
STATE_ROOT = BRAIN_ROOT / "State"
MEMORY_ROOT = BRAIN_ROOT / "Memory"
LEARNING_ROOT = BRAIN_ROOT / "Learning"

RUNTIME_REGISTRY = (
    REGISTRY_ROOT / "brain_runtime_registry.json"
)

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

COGNITIVE_GRAPH = (
    MEMORY_ROOT / "persistent_cognitive_graph.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)


# ============================================================
# Autonomous Cognitive Router
# ============================================================

class AutonomousCognitiveRouter:
    """
    ICOS autonomous orchestration engine.

    Responsibilities:
    - autonomous engine activation
    - provider arbitration routing
    - memory prioritization
    - interface-aware cognition routing
    - sovereign policy enforcement
    - direct brain escalation
    - adaptive runtime orchestration
    """

    def __init__(self) -> None:
        self.runtime_registry = self._load_json(
            RUNTIME_REGISTRY,
            fallback={}
        )

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
    # Task Classification
    # ========================================================

    def classify_task(
        self,
        user_input: str,
    ) -> str:

        text = user_input.lower()

        if any(x in text for x in [
            "code",
            "python",
            "runtime",
            "architecture",
            "debug",
            "engine",
        ]):
            return "engineering"

        if any(x in text for x in [
            "research",
            "analysis",
            "reasoning",
            "science",
        ]):
            return "reasoning"

        if any(x in text for x in [
            "write",
            "creative",
            "poem",
            "story",
        ]):
            return "creative"

        if any(x in text for x in [
            "main brain",
            "direct brain",
            "sovereign",
        ]):
            return "direct_brain"

        return "general"


    # ========================================================
    # Engine Routing
    # ========================================================

    def select_engines(
        self,
        task_type: str,
    ) -> list[str]:

        routes = {
            "engineering": [
                "provider_arbitration",
                "memory",
                "execution",
                "governance",
            ],
            "reasoning": [
                "provider_arbitration",
                "memory",
                "reflection",
                "cognition",
            ],
            "creative": [
                "provider_arbitration",
                "memory",
                "psyche",
                "response_synthesis",
            ],
            "direct_brain": [
                "identity_guard",
                "reflection",
                "psyche",
                "response_synthesis",
            ],
            "general": [
                "provider_arbitration",
                "memory",
                "response_synthesis",
            ],
        }

        return routes.get(task_type, routes["general"])


    # ========================================================
    # Provider Selection
    # ========================================================

    def select_provider(
        self,
        task_type: str,
    ) -> str:

        if task_type == "engineering":
            return "LMStudio"

        if task_type == "reasoning":
            return "OpenAI"

        if task_type == "creative":
            return "Gemini"

        if task_type == "direct_brain":
            return "ICOS_BRAIN_DIRECT"

        return self.runtime_registry.get(
            "providers",
            {}
        ).get(
            "active_provider",
            "LMStudio"
        )


    # ========================================================
    # Autonomous Routing
    # ========================================================

    def route(
        self,
        user_input: str,
        interface: str = "unknown",
    ) -> dict[str, Any]:

        task_type = self.classify_task(
            user_input
        )

        engines = self.select_engines(
            task_type
        )

        provider = self.select_provider(
            task_type
        )

        route = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "interface": interface,
            "task_type": task_type,
            "selected_provider": provider,
            "activated_engines": engines,
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "direct_brain_mode": (
                task_type == "direct_brain"
            ),
            "continuity_graph_active": bool(
                self.cognitive_graph
            ),
            "learning_events": len(self.learning_log),
        }

        self.brain_state[
            "last_route"
        ] = route

        BRAIN_STATE.write_text(
            json.dumps(
                self.brain_state,
                indent=2,
            )
        )

        return route


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    router = AutonomousCognitiveRouter()

    sample = router.route(
        user_input="Talk to the main brain about runtime architecture",
        interface="Continue",
    )

    print(json.dumps({
        "status": "ICOS_AUTONOMOUS_COGNITIVE_ROUTER_ACTIVE",
        "route": sample,
    }, indent=2))