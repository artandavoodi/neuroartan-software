# ============================================================
# ICOS · Interaction Learning Engine
# ============================================================

from pathlib import Path
from typing import Any
import json
import time
import uuid


# ============================================================
# Sovereign Root
# ============================================================

ROOT = Path(__file__).resolve().parents[3]

FOUNDRY_ROOT = ROOT / "Core" / "ModelFoundry"

DATA_ROOT = FOUNDRY_ROOT / "Data"
LEARNING_ROOT = FOUNDRY_ROOT / "Learning"
DATASET_ROOT = FOUNDRY_ROOT / "Datasets"
EMOTION_ROOT = FOUNDRY_ROOT / "EmotionalSignals"

RAW_INTERACTION_LOG = (
    DATA_ROOT / "raw_interaction_log.json"
)

LEARNING_EVENT_STORE = (
    LEARNING_ROOT / "learning_event_store.json"
)

SEMANTIC_MEMORY_STORE = (
    LEARNING_ROOT / "semantic_memory_store.json"
)

RELATIONSHIP_GRAPH_STORE = (
    LEARNING_ROOT / "relationship_graph_store.json"
)

DATASET_MANIFEST = (
    DATASET_ROOT / "dataset_manifest.json"
)

EMOTIONAL_SIGNAL_STORE = (
    EMOTION_ROOT / "emotional_signal_store.json"
)


# ============================================================
# Interaction Learning Engine
# ============================================================

class InteractionLearningEngine:
    """
    ICOS semantic learning and relationship engine.

    Responsibilities:
    - encode semantic memory
    - extract conceptual relationships
    - bind emotional context to cognition
    - evolve interaction intelligence
    - construct conceptual continuity
    - generate future training knowledge
    """

    def __init__(self) -> None:
        self.interactions = self._load_json(
            RAW_INTERACTION_LOG,
            fallback=[]
        )

        self.learning_events = self._load_json(
            LEARNING_EVENT_STORE,
            fallback=[]
        )

        self.semantic_memory = self._load_json(
            SEMANTIC_MEMORY_STORE,
            fallback=[]
        )

        self.relationship_graph = self._load_json(
            RELATIONSHIP_GRAPH_STORE,
            fallback=[]
        )

        self.dataset_manifest = self._load_json(
            DATASET_MANIFEST,
            fallback=[]
        )

        self.emotional_signals = self._load_json(
            EMOTIONAL_SIGNAL_STORE,
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
            content = path.read_text().strip()

            if not content:
                return fallback

            return json.loads(content)

        except Exception:
            return fallback


    # ========================================================
    # Concept Extraction
    # ========================================================

    def extract_concepts(
        self,
        text: str,
    ) -> list[str]:

        concepts = []

        vocabulary = [
            "icos",
            "cognition",
            "memory",
            "emotion",
            "routing",
            "governance",
            "learning",
            "identity",
            "model",
            "architecture",
            "continuity",
            "reflection",
            "token",
            "dataset",
            "reasoning",
            "autonomy",
        ]

        lowered = text.lower()

        for item in vocabulary:
            if item in lowered:
                concepts.append(item)

        return list(set(concepts))


    # ========================================================
    # Semantic Encoding
    # ========================================================

    def encode_semantic_memory(
        self,
        interaction: dict[str, Any],
    ) -> dict[str, Any]:

        combined = (
            interaction.get("user_input", "")
            + "\n"
            + interaction.get("model_output", "")
        )

        concepts = self.extract_concepts(
            combined
        )

        memory = {
            "memory_id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "provider": interaction.get("provider"),
            "concepts": concepts,
            "concept_count": len(concepts),
            "semantic_density": (
                "high" if len(concepts) > 5 else "medium"
            ),
        }

        self.semantic_memory.append(memory)

        SEMANTIC_MEMORY_STORE.write_text(
            json.dumps(
                self.semantic_memory,
                indent=2,
            )
        )

        return memory


    # ========================================================
    # Relationship Construction
    # ========================================================

    def build_relationship_graph(
        self,
        memory: dict[str, Any],
    ) -> list[dict[str, Any]]:

        concepts = memory.get("concepts", [])

        relationships = []

        for left in concepts:
            for right in concepts:
                if left == right:
                    continue

                relationships.append({
                    "source": left,
                    "target": right,
                    "relationship": "semantic_association",
                    "timestamp": time.time(),
                })

        self.relationship_graph.extend(
            relationships
        )

        RELATIONSHIP_GRAPH_STORE.write_text(
            json.dumps(
                self.relationship_graph,
                indent=2,
            )
        )

        return relationships


    # ========================================================
    # Emotional Binding
    # ========================================================

    def bind_emotion(
        self,
        memory: dict[str, Any],
    ) -> dict[str, Any]:

        emotion = (
            self.emotional_signals[-1]
            if self.emotional_signals
            else {"emotion": "neutral"}
        )

        binding = {
            "memory_id": memory.get("memory_id"),
            "emotion": emotion.get("emotion"),
            "timestamp": time.time(),
        }

        return binding


    # ========================================================
    # Learning Cycle
    # ========================================================

    def learning_cycle(self) -> dict[str, Any]:

        if not self.interactions:
            return {
                "runtime": "ICOS_LEARNING_ENGINE",
                "status": "no_interactions",
            }

        interaction = self.interactions[-1]

        memory = self.encode_semantic_memory(
            interaction
        )

        relationships = self.build_relationship_graph(
            memory
        )

        emotion = self.bind_emotion(
            memory
        )

        learning_event = {
            "timestamp": time.time(),
            "memory_id": memory.get("memory_id"),
            "relationship_count": len(
                relationships
            ),
            "emotion": emotion.get("emotion"),
            "concepts": memory.get("concepts"),
            "learning_completed": True,
        }

        self.learning_events.append(
            learning_event
        )

        LEARNING_EVENT_STORE.write_text(
            json.dumps(
                self.learning_events,
                indent=2,
            )
        )

        return {
            "runtime": "ICOS_LEARNING_ENGINE",
            "semantic_memory": memory,
            "relationships": len(relationships),
            "emotion_binding": emotion,
            "learning_event": learning_event,
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = InteractionLearningEngine()

    result = engine.learning_cycle()

    print(json.dumps({
        "status": "ICOS_INTERACTION_LEARNING_ENGINE_ACTIVE",
        "result": result,
    }, indent=2))