# ============================================================
# ICOS · Self Modification Governor
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
POLICY_ROOT = BRAIN_ROOT / "Policies"

BRAIN_STATE = (
    STATE_ROOT / "brain_state.json"
)

GOAL_STORE = (
    MEMORY_ROOT / "executive_goal_store.json"
)

GOVERNOR_LOG = (
    REFLECTION_ROOT / "self_modification_governor_log.json"
)

SAFETY_POLICY = (
    POLICY_ROOT / "self_modification_policy.json"
)

# ============================================================
# Self Modification Governor
# ============================================================

class SelfModificationGovernor:
    """
    ICOS sovereign self-modification governor.

    Responsibilities:
    - inspect proposed mutations
    - enforce architectural constraints
    - prevent uncontrolled recursion
    - require governance validation
    - preserve sovereign continuity
    - sandbox experimental evolution
    """

    def __init__(self) -> None:
        self.brain_state = self._load_json(
            BRAIN_STATE,
            fallback={}
        )

        self.goal_store = self._load_json(
            GOAL_STORE,
            fallback={}
        )

        self.governor_log = self._load_json(
            GOVERNOR_LOG,
            fallback=[]
        )

        self.safety_policy = self._load_json(
            SAFETY_POLICY,
            fallback={
                "allow_self_modification": False,
                "sandbox_required": True,
                "governance_required": True,
                "max_recursion_depth": 3,
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
    # Proposal Inspection
    # ========================================================

    def inspect_mutation(
        self,
        mutation: dict[str, Any],
    ) -> dict[str, Any]:

        risk = "low"

        if mutation.get("targets_core_identity"):
            risk = "critical"

        if mutation.get("recursive_runtime_change"):
            risk = "high"

        approved = (
            risk == "low"
            and self.safety_policy.get(
                "allow_self_modification",
                False,
            )
        )

        result = {
            "runtime": "ICOS",
            "timestamp": time.time(),
            "mutation": mutation,
            "risk": risk,
            "approved": approved,
            "sandbox_required": self.safety_policy.get(
                "sandbox_required",
                True,
            ),
            "governance_required": self.safety_policy.get(
                "governance_required",
                True,
            ),
        }

        self.governor_log.append(result)

        GOVERNOR_LOG.write_text(
            json.dumps(
                self.governor_log,
                indent=2,
            )
        )

        return result

    # ========================================================
    # Runtime Status
    # ========================================================

    def runtime_status(self) -> dict[str, Any]:
        return {
            "runtime": "ICOS",
            "self_modification_governor": True,
            "brain_active": self.brain_state.get(
                "brain_active",
                False,
            ),
            "active_goals": len(
                self.goal_store.get(
                    "active_goals",
                    []
                )
            ),
            "governor_events": len(
                self.governor_log
            ),
            "self_modification_allowed": self.safety_policy.get(
                "allow_self_modification",
                False,
            ),
        }

# ============================================================
# Runtime Entry
# ============================================================

if __name__ == "__main__":
    governor = SelfModificationGovernor()

    sample = governor.inspect_mutation({
        "mutation": "architecture_upgrade",
        "targets_core_identity": False,
        "recursive_runtime_change": False,
    })

    print(json.dumps({
        "status": "ICOS_SELF_MODIFICATION_GOVERNOR_ACTIVE",
        "inspection": sample,
        "runtime": governor.runtime_status(),
    }, indent=2))