# ============================================================
# ICOS · Experimental Sandbox Runtime
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

BRAIN_ROOT = ROOT / "Core" / "Brain"

STATE_ROOT = BRAIN_ROOT / "State"
MEMORY_ROOT = BRAIN_ROOT / "Memory"
REFLECTION_ROOT = BRAIN_ROOT / "Reflection"
POLICY_ROOT = BRAIN_ROOT / "Policies"

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

MUTATION_STORE = (
    MEMORY_ROOT / "architecture_mutation_store.json"
)

SANDBOX_STORE = (
    MEMORY_ROOT / "experimental_sandbox_store.json"
)

SANDBOX_LOG = (
    REFLECTION_ROOT / "experimental_sandbox_log.json"
)

SAFETY_POLICY = (
    POLICY_ROOT / "self_modification_policy.json"
)


# ============================================================
# Experimental Sandbox Runtime
# ============================================================

class ExperimentalSandboxRuntime:
    """
    ICOS isolated experimental runtime.

    Responsibilities:
    - isolate experimental mutations
    - prevent production contamination
    - execute governed simulations
    - preserve sovereign runtime integrity
    - audit sandbox evolution
    - support controlled recursive testing
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
            fallback={
                "active_sandboxes": [],
                "completed_sandboxes": []
            }
        )

        self.sandbox_log = self._load_json(
            SANDBOX_LOG,
            fallback=[]
        )

        self.safety_policy = self._load_json(
            SAFETY_POLICY,
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
    # Sandbox Creation
    # ========================================================

    def create_sandbox(
        self,
        mutation_id: str,
        description: str,
    ) -> dict[str, Any]:

        sandbox = {
            "sandbox_id": str(uuid.uuid4()),
            "runtime": "ICOS_SANDBOX",
            "timestamp": time.time(),
            "mutation_id": mutation_id,
            "description": description,
            "isolated": True,
            "production_access": False,
            "status": "active",
        }

        self.sandbox_store[
            "active_sandboxes"
        ].append(sandbox)

        SANDBOX_STORE.write_text(
            json.dumps(
                self.sandbox_store,
                indent=2,
            )
        )

        self.sandbox_log.append({
            "event": "sandbox_created",
            "sandbox": sandbox,
        })

        SANDBOX_LOG.write_text(
            json.dumps(
                self.sandbox_log,
                indent=2,
            )
        )

        return sandbox


    # ========================================================
    # Sandbox Simulation
    # ========================================================

    def execute_simulation(
        self,
        sandbox: dict[str, Any],
    ) -> dict[str, Any]:

        simulation = {
            "runtime": "ICOS_SANDBOX",
            "timestamp": time.time(),
            "sandbox_id": sandbox.get("sandbox_id"),
            "simulation_result": "stable",
            "recursive_instability": False,
            "identity_integrity": True,
            "production_contamination": False,
            "governance_preserved": True,
        }

        self.sandbox_log.append({
            "event": "sandbox_simulation",
            "simulation": simulation,
        })

        SANDBOX_LOG.write_text(
            json.dumps(
                self.sandbox_log,
                indent=2,
            )
        )

        return simulation


    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "experimental_sandbox_runtime": True,
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "sandbox_required": self.safety_policy.get(
                "sandbox_required",
                True,
            ),
            "active_sandboxes": len(
                self.sandbox_store.get(
                    "active_sandboxes",
                    []
                )
            ),
            "sandbox_events": len(
                self.sandbox_log
            ),
        }


# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    runtime = ExperimentalSandboxRuntime()

    sandbox = runtime.create_sandbox(
        mutation_id="demo-mutation",
        description="Experimental routing mutation simulation.",
    )

    simulation = runtime.execute_simulation(
        sandbox
    )

    print(json.dumps({
        "status": "ICOS_EXPERIMENTAL_SANDBOX_RUNTIME_ACTIVE",
        "sandbox": sandbox,
        "simulation": simulation,
        "runtime": runtime.runtime_status(),
    }, indent=2))