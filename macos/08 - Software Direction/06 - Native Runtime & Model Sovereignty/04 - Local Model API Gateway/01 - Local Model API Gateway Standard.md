---
type: Standard
subtype: Local Model API Gateway

title: ICOS Local Model API Gateway Standard
document_id: SW-ICOS-STD-2026-0025

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
version: "2.3"

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
  - "Local API Gateway"
  - "Runtime Request Routing"
  - "Session Binding"
  - "Token Streaming"
  - "Provider Abstraction"
  - "Security & Rate Control"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/07 - Runtime Provider Abstraction/01 - Runtime Provider Abstraction Standard.md"

tags:
  - "icos"
  - "api"
  - "gateway"
  - "runtime"
  - "software-direction"
---

## PURPOSE

Define the ICOS-native API gateway that exposes local model execution through a controlled, deterministic, and secure interface.

---

## CORE POSITION

ICOS must expose its own API layer.

No dependency on external API bridges.

Ollama dependency is permanently removed. The gateway must not reference or route through Ollama in any execution pathway.

---

## ACTIVE GATEWAY POSITION · 2026-04-29

The active gateway direction must support the final ICOS runtime chain:

```text
ICOS App
→ RuntimeManager
→ ModelRegistry
→ embedded llama.cpp engine
→ selected GGUF model
→ streaming response UI
```

The gateway must not route through JavaScriptCore, `native.runtime.js`, Ollama, Node, Python, Homebrew, or unmanaged developer paths.

The gateway is responsible for structured request orchestration only.

The runtime engine is responsible for inference execution.

The model registry is responsible for selecting the correct model artifact, including BF16 reference models and Q4/Q5 quantized variants.

---

## CURRENT IMPLEMENTATION STATUS · 2026-04-29

The local runtime path has advanced from bridge-based execution to embedded GGUF execution.

Achieved:

- Ollama removed from the gateway direction.
- JavaScriptCore/native.runtime.js path deprecated for active execution.
- `ICOSCoreRuntime` established as Swift runtime facade.
- `ICOSExecutionEngine` established as local execution bridge.
- embedded llama.cpp execution validated.
- GGUF runtime model validated through terminal execution.
- runtime dependencies identified and embedded through the app build pipeline.
- output action controls initiated in the message bubble UI.

Current blockers:

- BF16 GGUF latency is not acceptable for product interaction.
- process output appears in terminal but does not yet route cleanly into the ICOS UI message stream.
- streaming response handling is not implemented.
- RuntimeManager and ModelRegistry abstractions must replace direct execution path calls.

---

## QUANTIZED MODEL ROUTING REQUIREMENT

The gateway must support multiple local runtime variants for the same model family.

Required local model variants:

```text
icos-base.gguf              → BF16 reference runtime model
icos-base-q4_k_m.gguf       → first fast product baseline candidate
icos-base-q5_k_m.gguf       → higher-quality product baseline candidate
```

The gateway must never assume a single hardcoded model file.

Model selection must be resolved through ModelRegistry.

The selected model must return metadata including:

- model_id
- model_family
- runtime_backend
- model_format
- quantization_level
- local_path
- context_window
- expected_memory_profile
- default_candidate

---

## RESPONSE DELIVERY REQUIREMENT

The gateway must support structured and streaming response delivery.

For process-based local execution, stdout and stderr must be captured without blocking the UI.

The gateway must route generated content into the active ICOS session message stream.

Terminal-visible output alone is not a valid gateway success condition.

A successful response requires:

- model execution completes or streams
- output is captured by the runtime layer
- output is normalized by the gateway
- output is appended to active session messages
- copy and action controls remain available in the UI

---

## NO-USER-DEPENDENCY SHIPPING RULE

Production users must never install runtime dependencies manually.

The gateway must assume runtime dependencies are managed by ICOS.

Forbidden user requirements:

- install llama.cpp
- install Python
- install Homebrew
- install Node
- manually place model files
- manually convert models
- manually sign runtime binaries

Production ICOS must provide runtime and model lifecycle through the application.

---

---

## GATEWAY ROLE

The Local Model API Gateway is responsible for:

- receiving requests
- routing to runtime
- managing sessions
- streaming responses

It is the interface between UI/agent and runtime.

---

## REQUEST MODEL

Requests must include:

- model_id
- session_id
- input content
- execution parameters

Requests must be validated before execution.

---

## REQUEST VALIDATION PIPELINE

Every request must pass through:

- schema validation
- permission validation
- model availability check
- parameter validation

Invalid requests must be rejected before routing.

---

## ROUTING LAYER

The gateway must:

- resolve model via registry
- bind request to correct runtime instance
- enforce provider abstraction
- enforce strict separation between execution layer (runtime inference), coordination layer (Supabase), and distribution layer (model delivery)
- resolve quantized model variants through ModelRegistry
- select local or cloud provider through RuntimeManager policy
- reject unmanaged absolute runtime paths

---

## ROUTING DETERMINISM

Routing must be:

- fully deterministic
- based on registry + policy
- reproducible for identical inputs

No dynamic or hidden routing behavior.

---

## SESSION BINDING

Each request must:

- attach to a session
- preserve context
- carry model state

Session is a first-class object.

---

## SESSION STATE MANAGEMENT

The system must maintain:

- session history
- active model state
- context window

Session state must persist across requests.

---

## TOKEN STREAMING

The gateway must support:

- streaming responses
- partial output delivery
- real-time feedback

Streaming must become the default response mode for local GGUF execution.

The gateway must not wait for full process completion before updating the UI when the runtime supports token-level output.

---

## RESPONSE MODEL

Responses must include:

- structured output
- metadata (model, timing, tokens)
- status

Responses must also include:

- runtime_backend
- quantization_level
- elapsed_time
- streaming_status
- error_boundary when applicable

---

## RESPONSE NORMALIZATION

All responses must be normalized:

- consistent structure
- consistent metadata format
- consistent streaming protocol

No provider-specific variations.

---

## PROVIDER ABSTRACTION

Gateway must abstract:

- local runtime
- remote providers (optional)

Interface must remain consistent.

Remote providers must operate through external inference infrastructure (GPU endpoints or dedicated runtime services). Supabase must not be used as a model execution engine.

---

## SECURITY

Gateway must enforce:

- authentication
- authorization
- request validation

No unauthorized execution.

---

## DATA BOUNDARY ENFORCEMENT

The gateway must:

- prevent cross-session data leakage
- enforce strict isolation
- restrict sensitive data exposure

---

## RATE CONTROL

Gateway must enforce:

- rate limits
- quota usage
- concurrency control

---

## CONCURRENCY MODEL

The system must support:

- parallel request handling
- queue management
- controlled execution scheduling

Concurrency must not degrade stability.

---

## ERROR HANDLING

On error:

- return structured error
- log event
- preserve system stability

---

## LOGGING

All requests must log:

- input
- output
- model used
- execution time
- errors

Logs must be auditable.

---

## TRACEABILITY

Each request must be traceable with:

- unique request_id
- session_id linkage
- model execution path

Traceability must support full audit.

---

## PERFORMANCE

Gateway must:

- minimize latency
- support parallel requests
- handle high throughput

BF16 GGUF execution is not acceptable as the default interactive baseline.

Q4_K_M must be tested first as the fast baseline candidate.

Q5_K_M must be tested after Q4_K_M as the higher-quality baseline candidate.

Performance success must be measured through UI response time, not terminal-only execution.

---

## SYSTEM INTEGRATION

Gateway integrates with:

- native runtime
- model registry
- session system
- permission system

---

## NO EXTERNAL DEPENDENCY

Gateway must not rely on:

- Ollama APIs
- third-party routing layers
- Supabase execution routing (Supabase may only act as coordination layer, not execution layer)

- Ollama runtime (fully deprecated and removed)

---

## GATEWAY–RUNTIME CONTRACT

The gateway must:

- never execute logic itself
- only orchestrate and route

The runtime must:

- perform all inference
- return structured results

Separation must remain strict.

Execution must remain isolated from coordination systems such as Supabase and must not route inference through storage-layer services.

---

## FAILURE CONDITION

System routes requests through unauthorized external APIs, reintroduces dependency on deprecated runtime layers (including Ollama), or lacks deterministic control.

---

## SUCCESS CONDITION

ICOS exposes a fully controlled API layer that reliably routes requests to native runtime or approved external inference endpoints, with zero dependency on Ollama and strict separation between execution, coordination, and distribution layers.

For the active local runtime path, success also requires that embedded GGUF execution returns a normalized, copyable, visible response inside the ICOS UI without requiring user-installed runtime dependencies.

---

## Change Log

- 2026-04-29 — v2.3 Documented active local gateway direction for RuntimeManager → ModelRegistry → embedded llama.cpp → selected GGUF → streaming response UI; recorded current implementation status, quantized model routing requirement, response delivery requirement, no-user-dependency shipping rule, and UI-visible response success condition. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS local inference gateway and product-runtime hardening.
- 2026-04-29 — v2.2 Enforcement update. Added explicit failure conditions for unauthorized external APIs and deprecated runtime layers. Strengthened routing and dependency rules to enforce strict execution/coordination/distribution separation. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Runtime transition enforcement during model installation.
- 2026-04-29 — v2.1 Runtime gateway alignment. Ollama dependency removed from API gateway layer; routing updated to support local runtime and external inference endpoints only. Supabase excluded from execution path. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Runtime transition during model installation.
- 2026-04-28 — v2.0 Local API gateway defined to provide native request routing, session binding, streaming, and security for ICOS runtime. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Runtime sovereignty completion.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.3

---

END OF DOCUMENT
