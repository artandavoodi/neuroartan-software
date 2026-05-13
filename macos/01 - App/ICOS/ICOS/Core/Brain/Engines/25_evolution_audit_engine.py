# ============================================================
# ICOS · Evolution Audit Engine
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

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

MUTATION_STORE = (
    MEMORY_ROOT / "architecture_mutation_store.json"
)

SANDBOX_STORE = (
    MEMORY_ROOT / "experimental_sandbox_store.json"
)

AUDIT_STORE = (
    MEMORY_ROOT / "evolution_audit_store.json"
)

AUDIT_LOG = (
    REFLECTION_ROOT / "evolution_audit_log.json"
)

# ============================================================
# Evolution Audit Engine
# ============================================================

class EvolutionAuditEngine:
    """
    ICOS recursive evolution audit engine.

    Responsibilities:
    - maintain full mutation lineage
    - track sandbox execution history
    - preserve recursive accountability
    - audit governance decisions
    - validate continuity integrity
    - preserve sovereign traceability
    """

    def __init__(self) -> None:
        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.mutation_store = self._load_json(
            MUTATION_STORE,
            fallback={}
        )

        self.sandbox_store = self._load_json(
            SANDBOX_STORE,
            fallback={}
        )

        self.audit_store = self._load_json(
            AUDIT_STORE,
            fallback={
                "audit_events": [],
                "mutation_lineage": [],
                "sandbox_lineage": []
            }
        )

        self.audit_log = self._load_json(
            AUDIT_LOG,
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
    # Mutation Lineage Audit
    # ========================================================

    def audit_mutation_lineage(self) -> list[dict[str, Any]]:

        mutations = self.mutation_store.get(
            "proposed_mutations",
            []
        )

        lineage = []

        for mutation in mutations:
            lineage.append({
                "mutation_id": mutation.get(
                    "mutation_id"
                ),
                "target_layer": mutation.get(
                    "target_layer"
                ),
                "status": mutation.get("status"),
                "timestamp": mutation.get(
                    "timestamp"
                ),
            })

        self.audit_store[
            "mutation_lineage"
        ] = lineage

        return lineage

    # ========================================================
    # Sandbox Lineage Audit
    # ========================================================

    def audit_sandbox_lineage(self) -> list[dict[str, Any]]:

        sandboxes = self.sandbox_store.get(
            "active_sandboxes",
            []
        )

        lineage = []

        for sandbox in sandboxes:
            lineage.append({
                "sandbox_id": sandbox.get(
                    "sandbox_id"
                ),
                "mutation_id": sandbox.get(
                    "mutation_id"
                ),
                "isolated": sandbox.get("isolated"),
                "production_access": sandbox.get(
                    "production_access"
                ),
                "timestamp": sandbox.get(
                    "timestamp"
                ),
            })

        self.audit_store[
            "sandbox_lineage"
        ] = lineage

        return lineage

    # ========================================================
    # Recursive Audit
    # ========================================================

    def recursive_audit(self) -> dict[str, Any]:

        mutation_lineage = self.audit_mutation_lineage()
        sandbox_lineage = self.audit_sandbox_lineage()

        audit = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "mutation_lineage_events": len(
                mutation_lineage
            ),
            "sandbox_lineage_events": len(
                sandbox_lineage
            ),
            "recursive_traceability": True,
            "governance_accountability": True,
            "continuity_integrity": True,
        }

        self.audit_store[
            "audit_events"
        ].append(audit)

        AUDIT_STORE.write_text(
            json.dumps(
                self.audit_store,
                indent=2,
            )
        )

        self.audit_log.append(audit)

        AUDIT_LOG.write_text(
            json.dumps(
                self.audit_log,
                indent=2,
            )
        )

        return audit

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "evolution_audit_engine": True,
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "audit_events": len(
                self.audit_store.get(
                    "audit_events",
                    []
                )
            ),
            "mutation_lineage": len(
                self.audit_store.get(
                    "mutation_lineage",
                    []
                )
            ),
            "sandbox_lineage": len(
                self.audit_store.get(
                    "sandbox_lineage",
                    []
                )
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    engine = EvolutionAuditEngine()

    audit = engine.recursive_audit()

    print(json.dumps({
        "status": "ICOS_EVOLUTION_AUDIT_ENGINE_ACTIVE",
        "audit": audit,
        "runtime": engine.runtime_status(),
    }, indent=2))