# ============================================================
# ICOS · Safety Constraint Layer
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
POLICY_ROOT = BRAIN_ROOT / "Policies"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"
MEMORY_ROOT = BRAIN_ROOT / "Memory"

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

SAFETY_POLICY = (
    POLICY_ROOT / "self_modification_policy.json"
)

CONSTRAINT_LOG = (
    REFLECTION_ROOT / "safety_constraint_log.json"
)

MUTATION_STORE = (
    MEMORY_ROOT / "architecture_mutation_store.json"
)

# ============================================================
# Safety Constraint Layer
# ============================================================

class SafetyConstraintLayer:
    """
    ICOS sovereign safety enforcement layer.

    Responsibilities:
    - enforce immutable constraints
    - protect sovereign identity
    - prevent uncontrolled recursion
    - constrain unsafe mutations
    - preserve continuity stability
    - prohibit identity corruption
    """

    IMMUTABLE_CONSTRAINTS = [
        "identity",
        "runtime",
        "governance",
        "safety",
        "core_brain",
    ]

    def __init__(self) -> None:
        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.safety_policy = self._load_json(
            SAFETY_POLICY,
            fallback={}
        )

        self.constraint_log = self._load_json(
            CONSTRAINT_LOG,
            fallback=[]
        )

        self.mutation_store = self._load_json(
            MUTATION_STORE,
            fallback={}
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
    # Constraint Enforcement
    # ========================================================

    def enforce_constraints(
        self,
        mutation: dict[str, Any],
    ) -> dict[str, Any]:

        target = mutation.get(
            "target_layer",
            "unknown",
        ).lower()

        violation = (
            target in self.IMMUTABLE_CONSTRAINTS
        )

        result = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "mutation_id": mutation.get(
                "mutation_id"
            ),
            "target_layer": target,
            "constraint_violation": violation,
            "allowed": not violation,
            "immutable_constraints": self.IMMUTABLE_CONSTRAINTS,
        }

        self.constraint_log.append(result)

        CONSTRAINT_LOG.write_text(
            json.dumps(
                self.constraint_log,
                indent=2,
            )
        )

        return result

    # ========================================================
    # Runtime Integrity
    # ========================================================

    def runtime_integrity(self) -> dict[str, Any]:

        proposed = self.mutation_store.get(
            "proposed_mutations",
            []
        )

        blocked = [
            x for x in self.constraint_log
            if x.get("constraint_violation")
        ]

        return {
            "runtime": "ICOS",
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "proposed_mutations": len(proposed),
            "blocked_mutations": len(blocked),
            "runtime_integrity": len(blocked) == 0,
            "safety_constraints_active": True,
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    layer = SafetyConstraintLayer()

    sample = layer.enforce_constraints({
        "mutation_id": "demo-mutation",
        "target_layer": "identity",
    })

    print(json.dumps({
        "status": "ICOS_SAFETY_CONSTRAINT_LAYER_ACTIVE",
        "constraint_result": sample,
        "runtime": layer.runtime_integrity(),
    }, indent=2))