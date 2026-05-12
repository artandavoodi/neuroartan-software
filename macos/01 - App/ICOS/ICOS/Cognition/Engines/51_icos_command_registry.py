from __future__ import annotations

from dataclasses import dataclass, asdict
from datetime import datetime
from typing import Callable, Dict, List, Optional, Any
import json


@dataclass
class ICOSCommand:
    name: str
    domain: str
    description: str
    handler: str
    authority: str
    tags: List[str]
    requires_verification: bool = False
    requires_governance_review: bool = False
    enabled: bool = True


class ICOSCommandRegistry:
    def __init__(self) -> None:
        self.commands: Dict[str, ICOSCommand] = {}
        self.handlers: Dict[str, Callable[..., Any]] = {}
        self.created_at = datetime.now().isoformat(timespec="seconds")

    def register(
        self,
        command: ICOSCommand,
        handler: Optional[Callable[..., Any]] = None
    ) -> None:
        self.commands[command.name] = command

        if handler:
            self.handlers[command.name] = handler

    def unregister(self, name: str) -> None:
        self.commands.pop(name, None)
        self.handlers.pop(name, None)

    def resolve(self, name: str) -> Optional[ICOSCommand]:
        return self.commands.get(name)

    def resolve_handler(self, name: str):
        return self.handlers.get(name)

    def command_exists(self, name: str) -> bool:
        return name in self.commands

    def commands_by_domain(self, domain: str) -> List[Dict[str, Any]]:
        return [
            asdict(command)
            for command in self.commands.values()
            if command.domain == domain
        ]

    def commands_by_tag(self, tag: str) -> List[Dict[str, Any]]:
        return [
            asdict(command)
            for command in self.commands.values()
            if tag in command.tags
        ]

    def governance_required_commands(self) -> List[Dict[str, Any]]:
        return [
            asdict(command)
            for command in self.commands.values()
            if command.requires_governance_review
        ]

    def verification_required_commands(self) -> List[Dict[str, Any]]:
        return [
            asdict(command)
            for command in self.commands.values()
            if command.requires_verification
        ]

    def registry_summary(self) -> Dict[str, Any]:
        domains = sorted({
            command.domain
            for command in self.commands.values()
        })

        return {
            "status": "ICOS_COMMAND_REGISTRY_ACTIVE",
            "created_at": self.created_at,
            "total_commands": len(self.commands),
            "domains": domains,
            "governance_review_commands": len(
                self.governance_required_commands()
            ),
            "verification_required_commands": len(
                self.verification_required_commands()
            ),
            "registered_commands": [
                command.name
                for command in self.commands.values()
            ]
        }

    def export_registry(self) -> Dict[str, Any]:
        return {
            "status": "ICOS_COMMAND_REGISTRY_EXPORT",
            "commands": {
                name: asdict(command)
                for name, command in self.commands.items()
            }
        }


REGISTRY = ICOSCommandRegistry()


REGISTRY.register(
    ICOSCommand(
        name="institutional.memory.record",
        domain="institutional",
        description="Record constitutional memory event into persistent memory engine.",
        handler="08_persistent_constitutional_memory_engine.record",
        authority="Executive",
        tags=[
            "memory",
            "institutional",
            "persistence"
        ],
        requires_verification=True,
        requires_governance_review=False
    )
)


REGISTRY.register(
    ICOSCommand(
        name="institutional.document.create",
        domain="institutional",
        description="Generate constitutional document creation protocol.",
        handler="16_document_creation_protocol.create_protocol",
        authority="Departmental",
        tags=[
            "documents",
            "governance",
            "protocol"
        ],
        requires_verification=True,
        requires_governance_review=True
    )
)


REGISTRY.register(
    ICOSCommand(
        name="runtime.schedule.generate",
        domain="runtime",
        description="Generate dependency-aware execution schedule.",
        handler="20_dependency_resource_scheduler.generate_schedule",
        authority="Departmental",
        tags=[
            "runtime",
            "scheduler",
            "dependencies"
        ],
        requires_verification=False,
        requires_governance_review=False
    )
)


REGISTRY.register(
    ICOSCommand(
        name="runtime.failure.learn",
        domain="advanced",
        description="Record runtime failure and derive adaptive correction rule.",
        handler="09_failure_learning.learn_failure",
        authority="Executive",
        tags=[
            "adaptive-learning",
            "runtime",
            "failure"
        ],
        requires_verification=True,
        requires_governance_review=False
    )
)


if __name__ == "__main__":
    print(json.dumps(
        REGISTRY.registry_summary(),
        indent=2
    ))