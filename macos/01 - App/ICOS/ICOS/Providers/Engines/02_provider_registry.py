"""
ICOS Sovereign Provider Registry

Canonical Responsibility:
- provider registration
- local/cloud provider abstraction
- provider routing
- runtime dispatch coordination
- provider capability awareness
- model-provider compatibility

IMPORTANT:
This layer owns provider intelligence.
It does NOT own:
- cognition
- execution infrastructure
- interfaces
- memory persistence
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional


class ProviderType(str, Enum):
    LOCAL = "local"
    CLOUD = "cloud"
    HYBRID = "hybrid"


@dataclass
class ProviderCapability:
    supports_streaming: bool = False
    supports_tools: bool = False
    supports_vision: bool = False
    supports_voice: bool = False
    supports_local_models: bool = False
    max_context_window: Optional[int] = None


@dataclass
class Provider:
    provider_id: str
    name: str
    provider_type: ProviderType
    endpoint: Optional[str] = None
    active: bool = True
    models: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)
    capability: ProviderCapability = field(
        default_factory=ProviderCapability
    )


class SovereignProviderRegistry:
    """
    Sovereign provider authority.

    Responsibilities:
    - provider registration
    - provider routing
    - provider selection
    - local/cloud abstraction
    - capability awareness
    - runtime provider orchestration
    """

    def __init__(self) -> None:
        self.providers: Dict[str, Provider] = {}

        self.default_provider: Optional[str] = None

    def register_provider(self, provider: Provider) -> None:
        self.providers[provider.provider_id] = provider

        if self.default_provider is None:
            self.default_provider = provider.provider_id

    def unregister_provider(self, provider_id: str) -> None:
        if provider_id in self.providers:
            del self.providers[provider_id]

    def get_provider(self, provider_id: str) -> Optional[Provider]:
        return self.providers.get(provider_id)

    def get_default_provider(self) -> Optional[Provider]:
        if self.default_provider is None:
            return None

        return self.providers.get(self.default_provider)

    def set_default_provider(self, provider_id: str) -> None:
        if provider_id not in self.providers:
            raise ValueError(
                f"Provider does not exist: {provider_id}"
            )

        self.default_provider = provider_id

    def list_active_providers(self) -> List[Provider]:
        return [
            provider
            for provider in self.providers.values()
            if provider.active
        ]

    def list_local_providers(self) -> List[Provider]:
        return [
            provider
            for provider in self.providers.values()
            if provider.provider_type == ProviderType.LOCAL
        ]

    def list_cloud_providers(self) -> List[Provider]:
        return [
            provider
            for provider in self.providers.values()
            if provider.provider_type == ProviderType.CLOUD
        ]

    def select_provider_for_task(
        self,
        requires_tools: bool = False,
        requires_vision: bool = False,
        requires_voice: bool = False,
        prefer_local: bool = True,
    ) -> Optional[Provider]:
        providers = self.list_active_providers()

        if prefer_local:
            providers = sorted(
                providers,
                key=lambda p: p.provider_type != ProviderType.LOCAL,
            )

        for provider in providers:
            capability = provider.capability

            if requires_tools and not capability.supports_tools:
                continue

            if requires_vision and not capability.supports_vision:
                continue

            if requires_voice and not capability.supports_voice:
                continue

            return provider

        return None

    def export_registry_state(self) -> Dict[str, Any]:
        return {
            "providers": [
                {
                    "provider_id": provider.provider_id,
                    "name": provider.name,
                    "provider_type": provider.provider_type.value,
                    "endpoint": provider.endpoint,
                    "active": provider.active,
                    "models": provider.models,
                }
                for provider in self.providers.values()
            ],
            "default_provider": self.default_provider,
        }


if __name__ == "__main__":
    registry = SovereignProviderRegistry()

    registry.register_provider(
        Provider(
            provider_id="lmstudio_local",
            name="LM Studio Local Runtime",
            provider_type=ProviderType.LOCAL,
            endpoint="http://localhost:1234/v1",
            models=[
                "qwen-coder",
                "deepseek-coder",
            ],
            capability=ProviderCapability(
                supports_streaming=True,
                supports_tools=True,
                supports_local_models=True,
            ),
        )
    )

    provider = registry.select_provider_for_task(
        requires_tools=True,
        prefer_local=True,
    )

    print(
        {
            "selected_provider": provider.name if provider else None,
            "registry": registry.export_registry_state(),
        }
    )