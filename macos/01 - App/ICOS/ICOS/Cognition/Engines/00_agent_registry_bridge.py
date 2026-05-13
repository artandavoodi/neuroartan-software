from pathlib import Path
from datetime import datetime
import json

MEMORY = Path(__file__).resolve().parent / "constitutional_memory_state.json"
BRIDGE_STATE = Path(__file__).resolve().parent / "agent_registry_bridge_state.json"

AGENT_REGISTRY = {
    "WSDA": {
        "name": "Website Systems & Development Agent",
        "domain": "infrastructure",
        "authority": "Departmental",
        "capabilities": [
            "website",
            "runtime",
            "verification",
            "frontend"
        ]
    },
    "GCA": {
        "name": "General Counsel Agent",
        "domain": "legal",
        "authority": "Executive",
        "capabilities": [
            "legal",
            "privacy",
            "contracts",
            "compliance"
        ]
    },
    "VGA": {
        "name": "Vault Governance Agent",
        "domain": "governance",
        "authority": "Departmental",
        "capabilities": [
            "metadata",
            "routing",
            "document-structure",
            "governance"
        ]
    },
    "CCSOA": {
        "name": "Chief Cognitive Systems Officer Agent",
        "domain": "icos",
        "authority": "Executive",
        "capabilities": [
            "cognition",
            "runtime",
            "memory",
            "architecture"
        ]
    },
    "ECOA": {
        "name": "Executive Command Office Agent",
        "domain": "institutional",
        "authority": "Executive",
        "capabilities": [
            "executive-routing",
            "institutional-decisions",
            "constitutional-approval"
        ]
    }
}

def load_json(path, fallback):
    if not path.exists():
        return fallback

    try:
        return json.loads(path.read_text())
    except Exception:
        return fallback

def save_json(path, data):
    path.write_text(json.dumps(data, indent=2))

def classify_request(request):
    lowered = request.lower()

    scores = {}

    for agent_id, agent in AGENT_REGISTRY.items():
        scores[agent_id] = sum(
            lowered.count(capability)
            for capability in agent["capabilities"]
        )

    return max(scores, key=scores.get)

def determine_collaboration(primary_agent, request):
    lowered = request.lower()

    collaborators = []

    if any(k in lowered for k in [
        "legal",
        "contract",
        "privacy",
        "compliance"
    ]):
        collaborators.append("GCA")

    if any(k in lowered for k in [
        "governance",
        "metadata",
        "routing"
    ]):
        collaborators.append("VGA")

    if any(k in lowered for k in [
        "runtime",
        "memory",
        "cognition"
    ]):
        collaborators.append("CCSOA")

    if primary_agent not in collaborators:
        collaborators.insert(0, primary_agent)

    return list(dict.fromkeys(collaborators))

def build_agent_bridge(request):
    memory = load_json(MEMORY, {
        "events": []
    })

    primary_agent = classify_request(request)

    collaborators = determine_collaboration(
        primary_agent,
        request
    )

    bridge = {
        "status": "AGENT_REGISTRY_BRIDGE_RESOLVED",
        "evaluated_at": datetime.now().isoformat(timespec="seconds"),
        "request": request,
        "primary_agent": {
            "id": primary_agent,
            "profile": AGENT_REGISTRY[primary_agent]
        },
        "collaboration_chain": [
            {
                "id": agent_id,
                "profile": AGENT_REGISTRY[agent_id]
            }
            for agent_id in collaborators
        ],
        "shared_memory_available": len(memory.get("events", [])) > 0,
        "constitutional_routing": {
            "requires_executive_review": any(
                AGENT_REGISTRY[a]["authority"] == "Executive"
                for a in collaborators
            ),
            "routing_depth": len(collaborators),
            "cross_domain_collaboration": len({
                AGENT_REGISTRY[a]["domain"]
                for a in collaborators
            }) > 1
        },
        "recommended_execution_model": (
            "multi-agent"
            if len(collaborators) > 1
            else "single-agent"
        )
    }

    save_json(BRIDGE_STATE, bridge)

    return bridge

if __name__ == "__main__":
    print(json.dumps(
        build_agent_bridge(
            "Build persistent runtime memory governance and constitutional routing system for ICOS sovereign cognition."
        ),
        indent=2
    ))