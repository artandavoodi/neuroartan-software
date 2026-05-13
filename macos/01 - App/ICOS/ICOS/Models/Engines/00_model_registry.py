"""
ICOS Sovereign Model Registry

Canonical Responsibility:
- sovereign model ownership
- local/cloud model registration
- model metadata tracking
- provider-model compatibility
- runtime model selection
- GGUF/safetensors awareness
- model capability indexing

IMPORTANT:
This layer owns model authority.
It does NOT own:
- provider routing
- cognition orchestration
- execution infrastructure
- interfaces
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional

class ModelFormat(str, Enum):
    GGUF = "gguf"
    SAFETENSORS = "safetensors"
    ONNX = "onnx"
    MLX = "mlx"
    REMOTE = "remote"

class ModelRuntime(str, Enum):
    LLAMA_CPP = "llama.cpp"
    LM_STUDIO = "lm_studio"
    VLLM = "vllm"
    TRANSFORMERS = "transformers"
    REMOTE_PROVIDER = "remote_provider"

@dataclass
class ModelCapability:
    supports_tools: bool = False
    supports_vision: bool = False
    supports_voice: bool = False
    supports_reasoning: bool = False
    supports_code: bool = False
    max_context_window: Optional[int] = None

@dataclass
class RegisteredModel:
    model_id: str
    name: str
    format: ModelFormat
    runtime: ModelRuntime
    path: Optional[str] = None
    provider_id: Optional[str] = None
    active: bool = True
    metadata: Dict[str, Any] = field(default_factory=dict)
    capability: ModelCapability = field(
        default_factory=ModelCapability
    )

class SovereignModelRegistry:
    """
    Sovereign model authority.

    Responsibilities:
    - model ownership
    - local model registration
    - model/runtime compatibility
    - model selection
    - capability indexing
    - local/cloud abstraction
    """

    def __init__(self) -> None:
        self.models: Dict[str, RegisteredModel] = {}

        self.default_model: Optional[str] = None

    def register_model(self, model: RegisteredModel) -> None:
        self.models[model.model_id] = model

        if self.default_model is None:
            self.default_model = model.model_id

    def unregister_model(self, model_id: str) -> None:
        if model_id in self.models:
            del self.models[model_id]

    def get_model(self, model_id: str) -> Optional[RegisteredModel]:
        return self.models.get(model_id)

    def set_default_model(self, model_id: str) -> None:
        if model_id not in self.models:
            raise ValueError(
                f"Unknown model: {model_id}"
            )

        self.default_model = model_id

    def get_default_model(self) -> Optional[RegisteredModel]:
        if self.default_model is None:
            return None

        return self.models.get(self.default_model)

    def list_active_models(self) -> List[RegisteredModel]:
        return [
            model
            for model in self.models.values()
            if model.active
        ]

    def list_local_models(self) -> List[RegisteredModel]:
        return [
            model
            for model in self.models.values()
            if model.path is not None
        ]

    def discover_local_models(
        self,
        directory: str,
    ) -> List[str]:
        discovered: List[str] = []

        root = Path(directory)

        if not root.exists():
            return discovered

        for file in root.rglob("*"):
            if file.suffix.lower() in [
                ".gguf",
                ".safetensors",
                ".onnx",
            ]:
                discovered.append(str(file))

        return discovered

    def select_model_for_task(
        self,
        requires_tools: bool = False,
        requires_vision: bool = False,
        requires_reasoning: bool = False,
        requires_code: bool = False,
        prefer_local: bool = True,
    ) -> Optional[RegisteredModel]:
        models = self.list_active_models()

        if prefer_local:
            models = sorted(
                models,
                key=lambda m: m.path is None,
            )

        for model in models:
            capability = model.capability

            if requires_tools and not capability.supports_tools:
                continue

            if requires_vision and not capability.supports_vision:
                continue

            if requires_reasoning and not capability.supports_reasoning:
                continue

            if requires_code and not capability.supports_code:
                continue

            return model

        return None

    def export_registry_state(self) -> Dict[str, Any]:
        return {
            "models": [
                {
                    "model_id": model.model_id,
                    "name": model.name,
                    "format": model.format.value,
                    "runtime": model.runtime.value,
                    "path": model.path,
                    "provider_id": model.provider_id,
                    "active": model.active,
                }
                for model in self.models.values()
            ],
            "default_model": self.default_model,
        }

if __name__ == "__main__":
    registry = SovereignModelRegistry()

    registry.register_model(
        RegisteredModel(
            model_id="qwen_coder_local",
            name="Qwen Coder Local",
            format=ModelFormat.GGUF,
            runtime=ModelRuntime.LM_STUDIO,
            path="/Models/qwen-coder.gguf",
            capability=ModelCapability(
                supports_tools=True,
                supports_reasoning=True,
                supports_code=True,
                max_context_window=32768,
            ),
        )
    )

    selected = registry.select_model_for_task(
        requires_code=True,
        requires_reasoning=True,
        prefer_local=True,
    )

    print(
        {
            "selected_model": selected.name if selected else None,
            "registry": registry.export_registry_state(),
        }
    )