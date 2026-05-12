# ============================================================
# ICOS · Persistent Cognitive Graph
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

GRAPH_ROOT = BRAIN_ROOT / "Memory"
LEARNING_ROOT = BRAIN_ROOT / "Learning"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"
STATE_ROOT = BRAIN_ROOT / "State"

GRAPH_STORE = (
    GRAPH_ROOT / "persistent_cognitive_graph.json"
)

LEARNING_LOG = (
    LEARNING_ROOT / "model_learning_log.json"
)

REFLECTION_LOG = (
    REFLECTION_ROOT / "runtime_reflection_log.json"
)

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)


# ============================================================
# Persistent Cognitive Graph
# ============================================================

class PersistentCognitiveGraph:
    """
    Long-term ICOS continuity graph.

    Responsibilities:
    - persistent conceptual memory
    - provider continuity mapping
    - recurring cognition pattern tracking
    - runtime identity continuity
    - recursive reflection indexing
    - relationship graph construction
    """

    def __init__(self) -> None:
        self.learning_log = self._load_json(
            LEARNING_LOG,
            fallback=[]
        )

        self.reflection_log = self._load_json(
            REFLECTION_LOG,
            fallback=[]
        )

        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.graph = self._load_json(
            GRAPH_STORE,
            fallback={
                "providers": {},
                "concepts": {},
                "identity": {},
                "reflections": [],
                "relationships": []
            }
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
    # Provider Graph
    # ========================================================

    def build_provider_graph(self) -> None:
        providers = {}

        for item in self.learning_log:
            provider = item.get("provider")

            if provider is None:
                continue

            providers.setdefault(provider, {
                "usage_count": 0,
                "last_seen": None,
            })

            providers[provider]["usage_count"] += 1
            providers[provider]["last_seen"] = item.get(
                "timestamp"
            )

        self.graph["providers"] = providers


    # ========================================================
    # Reflection Graph
    # ========================================================

    def build_reflection_graph(self) -> None:
        reflections = []

        for item in self.reflection_log:
            reflections.append({
                "identity_coherence": item.get(
                    "identity_coherence"
                ),
                "timestamp": item.get("timestamp"),
            })

        self.graph["reflections"] = reflections


    # ========================================================
    # Identity Continuity
    # ========================================================

    def build_identity_graph(self) -> None:
        self.graph["identity"] = {
            "runtime": "ICOS",
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "direct_brain_mode": self.brain_state.get(
                "direct_brain_mode",
                False,
            ),
            "learning_enabled": self.brain_state.get(
                "learning_enabled",
                False,
            ),
            "memory_enabled": self.brain_state.get(
                "memory_enabled",
                False,
            ),
            "continuity_timestamp": time.time(),
        }


    # ========================================================
    # Relationship Mapping
    # ========================================================

    def build_relationship_graph(self) -> None:
        relationships = []

        for provider, data in self.graph.get(
            "providers",
            {}
        ).items():
            relationships.append({
                "source": "ICOS Brain",
                "target": provider,
                "relationship": "processor",
                "usage_count": data.get("usage_count", 0),
            })

        self.graph["relationships"] = relationships


    # ========================================================
    # Persistence
    # ========================================================

    def persist(self) -> None:
        GRAPH_STORE.write_text(
            json.dumps(
                self.graph,
                indent=2,
            )
        )


    # ========================================================
    # Graph Construction
    # ========================================================

    def construct(self) -> dict[str, Any]:
        self.build_provider_graph()
        self.build_reflection_graph()
        self.build_identity_graph()
        self.build_relationship_graph()

        self.persist()

        return {
            "runtime": "ICOS",
            "persistent_cognitive_graph": True,
            "providers": len(
                self.graph.get("providers", {})
            ),
            "relationships": len(
                self.graph.get("relationships", [])
            ),
            "reflections": len(
                self.graph.get("reflections", [])
            ),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    graph = PersistentCognitiveGraph()

    result = graph.construct()

    print(json.dumps({
        "status": "ICOS_PERSISTENT_COGNITIVE_GRAPH_ACTIVE",
        "graph": result,
    }, indent=2))