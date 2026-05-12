---
type: Directive
subtype: Native LLM Runtime

title: ICOS Native LLM Runtime Directive
document_id: SW-ICOS-DIR-2026-0022

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Native Runtime & Model Sovereignty"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"
  - "Legal Operations"

legal_sensitive: true
requires_gc_review: true
requires_creo_review: true
approval_status: Draft

gsa_protocol: "Pending Executive Validation"
gsa_approved: false

status: Active
lifecycle: Draft
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v1.6"
version: "2.2"

created_date: "2026-04-28"
last_updated: "2026-04-29"
last_reviewed: "2026-04-29"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Native LLM Runtime Ownership"
  - "Model Execution Control"
  - "Inference Infrastructure"
  - "Removal of External Runtime Dependency"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/02 - Ollama Deprecation & Migration/01 - Ollama Deprecation & Migration Standard.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

tags:
  - "icos"
  - "runtime"
  - "llm"
  - "sovereignty"
  - "software-direction"
---

## PURPOSE

Define the transition to a fully native ICOS LLM runtime where model execution, loading, and serving are fully controlled by ICOS.

---

## CORE POSITION

ICOS must own its runtime.

External runtime dependency is transitional only.

Ollama dependency is permanently removed. No execution, storage, or API pathway may depend on Ollama.

The active native runtime direction is embedded llama.cpp execution over GGUF model artifacts, routed through ICOS-owned Swift runtime interfaces.

The runtime must be treated as an internal product subsystem, not as a developer dependency.

---

## CURRENT STATE

The system no longer relies on external runtime layers. This section is retained for historical context of the transition from external runtime dependency to native ICOS runtime.

- model loading
- inference serving
- API exposure

This is not the final architecture.

---

## TARGET STATE

ICOS must operate a native runtime that:

- loads models directly
- executes inference internally
- exposes its own API layer
- manages memory and resources

Cloud execution must operate through external inference infrastructure (GPU servers, endpoints, or dedicated runtime services). Supabase must not be used as a model execution engine.

---

## ACTIVE RUNTIME ARCHITECTURE · 2026-04-29

The active target runtime chain is:

```text
ICOS App
→ RuntimeManager
→ ModelRegistry
→ embedded llama.cpp engine
→ selected GGUF model
→ streaming response UI
```

The previous JavaScriptCore/native.runtime.js path is deprecated for active execution.

The current native implementation uses:

- `ICOSCoreRuntime` as the Swift runtime facade
- `ICOSExecutionEngine` as the local execution bridge
- embedded `llama-cli` as the first executable llama.cpp runtime boundary
- embedded GGUF model files as local model artifacts
- managed runtime dependencies packaged inside the ICOS application bundle

The runtime must evolve from direct process execution into a governed RuntimeManager layer with model selection, cancellation, streaming, health reporting, and storage control.

---

## MODEL FORMAT STANDARD

Local executable models must use GGUF runtime format unless superseded by a future approved native engine.

Hugging Face source model files such as `safetensors`, tokenizer files, and configuration files may be retained as source/reference artifacts during development, but the shipped local runtime path must use verified executable runtime formats.

Current model format state:

```text
Source package        → Hugging Face model files
Executable package    → GGUF runtime model
Optimization package  → Quantized GGUF variants
```

The current BF16 GGUF model is valid as a reference runtime model, but it is not acceptable as the default product runtime model because latency is too high for interactive ICOS use.

The required optimization track is:

```text
icos-base.gguf              → BF16 reference runtime model
icos-base-q4_k_m.gguf       → first fast product baseline candidate
icos-base-q5_k_m.gguf       → higher-quality product baseline candidate
```

Quantization creates additional model variants. It must not overwrite or delete the reference model until the optimized model is verified.

---

## SHIPPING STANDARD

ICOS must ship as a complete installable application.

The user must never be required to install:

- llama.cpp
- Python
- Homebrew
- Node
- manual model files
- developer tooling

Production ICOS must provide:

- embedded runtime engine
- managed model downloader
- model verification
- model registry registration
- local and cloud model switching
- runtime health status
- model deletion and storage management
- fallback provider routing
- streaming response UI

Runtime dependencies must be packaged, signed, and loaded through ICOS-controlled bundle or application-support paths.

External absolute paths are forbidden in production runtime execution.

---

## PRODUCT POSITIONING STANDARD

ICOS must not be positioned as Gemma or any other third-party model.

ICOS is the cognitive operating system.

Third-party or open local models are supported inference engines.

The correct market framing is:

```text
ICOS provides the cognitive operating system, workspace architecture, memory layer, model routing, execution interface, continuity system, and governance layer.
Supported local or cloud models provide inference capacity.
```

Transparent public positioning may state:

```text
The current local inference prototype uses a supported open model converted into GGUF format and executed through an embedded local runtime. ICOS owns the orchestration, memory, interface, governance, and cognitive operating layer.
```

Long-term positioning remains:

```text
ICOS will support multiple local and cloud model engines, with a future Neuroartan-owned model as the sovereign intelligence layer when technically and commercially ready.
```

---

## EXECUTION LAYER DEFINITION

The native runtime must consist of the following layers:

- Model Loader (weights, tokenizer, config)
- Inference Core (token generation loop)
- Scheduler (batching, queueing, concurrency)
- Session Engine (context binding, history)
- Streaming Engine (token emission, partial responses)
- Resource Manager (CPU/GPU, memory)

Each layer must be independently testable and composable.

---

## RUNTIME OWNERSHIP

ICOS must own:

- model loading pipeline
- inference execution
- batching and token streaming
- resource allocation

ICOS must also own:

- embedded runtime packaging
- runtime dependency signing
- model variant lifecycle
- model storage cleanup
- local/cloud provider selection
- execution telemetry and runtime health reporting

No external dependency for core execution.

---

## MODEL EXECUTION LAYER

The runtime must support:

- local model execution (e.g. Gemma, future models)
- multiple model instances
- controlled switching

---

## API CONTROL

ICOS must expose its own API:

- request handling
- response streaming
- session binding

External APIs must be optional, not required.

---

## STORAGE INTEGRATION

Model files must be:

- stored in ICOS-controlled directories
- referenced by ICOS runtime

No external folder ownership.

---

## RESOURCE MANAGEMENT

Runtime must manage:

- CPU/GPU usage
- memory allocation
- concurrency

---

## RUNTIME INTERFACES

The runtime must expose internal interfaces for:

- load(model_id)
- unload(model_id)
- infer(session_id, input, params)
- stream(session_id)
- interrupt(session_id)

Interfaces must be deterministic and stateless where possible.

---

## PROVIDER ABSTRACTION

The system must support:

- multiple model providers
- local + remote fallback

Remote execution must use external inference infrastructure and must not route through Supabase or any storage-layer system.

But local runtime remains primary.

---

## RUNTIME ISOLATION

Each model execution must be isolated:

- no shared mutable state across sessions
- memory boundaries per model/session
- failure in one execution must not affect others

Isolation is mandatory for stability and security.

---

## DEPRECATION RULE

All external runtime layers must:

- be phased out
- replaced with native equivalents

Ollama is considered fully deprecated and removed.

---

## SECURITY

Runtime must enforce:

- access control
- execution boundaries
- model isolation

---

## AGENT INTEGRATION

Agent must interact with runtime as:

- primary execution engine
- not via external bridge

---

## AGENT–RUNTIME CONTRACT

The agent must:

- call runtime only through API gateway
- never access model files directly
- rely on registry + gateway for execution

The runtime must:

- remain deterministic
- return structured responses
- expose execution metadata

---

## PERFORMANCE BASELINE

The native runtime must meet minimum thresholds:

- consistent token throughput
- stable latency under load
- predictable memory usage

The BF16 GGUF model is not the product performance baseline.

Q4_K_M must be tested as the first fast local runtime baseline.

Q5_K_M must be tested after Q4_K_M as the higher-quality local runtime baseline candidate.

Default local runtime selection must be based on measured speed-quality balance.

Performance must be measurable and monitored.

---

## FAILURE CONDITION

ICOS depends on any external runtime (including Ollama) for core execution or reintroduces any dependency on deprecated runtime layers.

---

## SUCCESS CONDITION

ICOS fully owns model execution, API layer, and runtime behavior with zero dependency on Ollama and strict separation between execution, coordination, and distribution layers.

---

## Change Log

- 2026-04-29 — v2.2 Documented embedded llama.cpp + GGUF as the active native runtime direction; recorded RuntimeManager → ModelRegistry → embedded engine → selected GGUF → streaming UI target, model format standard, quantization policy, shipping requirements, product positioning, and no-user-dependency packaging rule. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS local runtime architecture hardening and product-readiness documentation.
- 2026-04-29 — v2.1 Full Ollama removal enforcement. External runtime dependency removed, native runtime directive updated to enforce zero Ollama usage and strict execution/coordination/distribution separation. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Runtime transition during model installation.
- 2026-04-28 — v2.0 Native runtime directive established to enforce full sovereignty over LLM execution and remove dependency on external runtime layers. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Runtime sovereignty layer creation.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.2

---

END OF DOCUMENT