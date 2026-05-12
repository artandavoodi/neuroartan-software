---
type: Architecture
subtype: Native Runtime

title: ICOS Native Runtime Architecture
document_id: SW-ICOS-ARC-2026-0040

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Implementation Architecture"
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
  - "Native Runtime Engine"
  - "Inference Core"
  - "Session Binding"
  - "Streaming System"
  - "Resource Management"
  - "Execution Isolation"
  - "Provider-Agnostic Runtime Execution"
  - "Local / Cloud / Native Model Providers"
  - "Model Switching Runtime Binding"
  - "User-Created Model Execution Boundary"
  - "Training Lifecycle Runtime Boundary"
  - "Legacy Runtime Exclusion"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/08 - Implementation Architecture/01 - Runtime Architecture/01 - ICOS Native Runtime Architecture.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/07 - Runtime Provider Abstraction/01 - Runtime Provider Abstraction Standard.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/03 - Model Registry Architecture/01 - ICOS Model Registry Implementation Architecture.md"
  - "software/macos/08 - Software Direction/01 - Directives/05 - Model Registry Directives/01 - Model Registry Directive.md"

tags:
  - "icos"
  - "runtime"
  - "architecture"
  - "provider-routing"
  - "native-runtime"
  - "cloud-runtime"
  - "local-models"
  - "model-training"
---

## PURPOSE

Define the technical architecture of the ICOS native runtime engine, including inference, session handling, streaming, and resource control.

---

## CORE POSITION

Execution is owned internally.

Runtime must be deterministic, isolated, and fully controlled.

Runtime must execute through a provider-agnostic contract.
Runtime must clearly separate execution layer (inference), coordination layer (Supabase), and distribution layer (model delivery).

ICOS must support local models, native ICOS models, user-created models, trained derivative models, optional cloud models, and future providers without hardcoding, dependency lock, or duplicated execution paths.

Legacy runtime systems, legacy package assumptions, and dependency-specific execution logic must not exist inside active runtime code.

---

## RUNTIME PROVIDER CONTRACT

The runtime must resolve execution through provider contracts.

Supported provider classes include:

- local model provider
- native ICOS model provider
- user-created model provider
- trained derivative model provider
- cloud model provider
- future provider

Provider resolution must be registry-driven.

The runtime must not infer provider identity from directory names, file names, legacy package markers, or UI labels.

---

## MODEL SWITCHING CONTRACT

Model switching must update the active runtime binding.

A valid model switch must update:

- active model identifier
- provider type
- backend type
- package format
- permission state
- training state
- runtime session binding
- UI model indicator

A model selector that changes labels without changing runtime binding is invalid.

---

## LOCAL / NATIVE / CLOUD EXECUTION CONTRACT

The app layer must call one abstract runtime interface.

The runtime must resolve:

- selected model
- provider
- backend
- package format
- execution availability
- permission state
- runtime binding

Local execution is mandatory for sovereign runtime development.

Cloud execution is optional and must remain modular.
Cloud execution must operate through external inference infrastructure (GPU server, endpoint, or dedicated runtime service). Supabase must not be used as a model execution engine.

Native ICOS execution must use ICOS-compatible package structure.

No cloud pathway may replace, weaken, or lock the native runtime architecture.

---

## USER-CREATED MODEL RUNTIME CONTRACT

User-created models must be registry-bound before runtime execution.

Runtime may execute a user-created model only after validation of:

- owner identity
- source authorization
- training consent state
- data boundary
- verification status
- visibility status
- interaction permission state
- revocation state

User-created models must not bypass registry, permission, or session governance.

---

## TRAINING RUNTIME BOUNDARY

Training is a governed lifecycle, not an inference shortcut.

Runtime must distinguish:

- untrained
- configured
- training_pending
- training_active
- training_paused
- trained
- verified_trained
- revoked

Inference must not execute against unverified training artifacts.

Training must bind to source authorization, privacy controls, model ownership, and registry status.

---

## RUNTIME LAYERS

### 00 · PROVIDER RESOLVER

Responsible for:

- resolving provider type
- resolving backend type
- validating registry contract
- validating permissions
- validating package compatibility
- creating runtime binding

Provider resolver must run before model loading.

---

### 01 · MODEL LOADER

Responsible for:

- loading weights
- loading tokenizer
- validating configuration
 - validating package format
 - validating tokenizer availability
 - validating weights availability
 - rejecting partial shards
 - rejecting legacy runtime-dependent packages

---

### 02 · INFERENCE CORE

Responsible for:

- token generation loop
- sampling logic
- output construction
 - backend execution validation
 - provider execution dispatch
 - no-placeholder enforcement

Must be deterministic for identical inputs.

---

### 03 · SESSION ENGINE

Responsible for:

- binding session_id
- managing context window
- preserving history

Session must persist across requests.

---

### 04 · STREAMING ENGINE

Responsible for:

- token-by-token output
- ordered emission
- interruption support

---

### 05 · SCHEDULER

Responsible for:

- request queueing
- batching
- concurrency control

Must prevent overload and starvation.

---

### 06 · RESOURCE MANAGER

Responsible for:

- CPU/GPU allocation
- memory tracking
- load balancing

---

### 07 · ISOLATION LAYER

Responsible for:

- separating execution contexts
- preventing cross-session leakage
- containing failures

---

## RUNTIME INTERFACES

The runtime must expose:

- resolve(model_id)
- bind(session_id, model_id)
- load(model_id)
- unload(model_id)
- infer(session_id, input, params)
- stream(session_id)
- interrupt(session_id)
- registerProvider(provider_contract)
- validatePackage(model_id)
- reportAvailability(model_id)

Interfaces must be consistent and versioned.

---

## EXECUTION FLOW

Standard flow:

1. request received
2. model_id resolved via registry
3. provider contract resolved
4. permission state validated
5. package format validated
6. runtime session binding created
7. model loaded
8. inference backend verified
9. inference executed
10. tokens streamed
11. response finalized

---

## SESSION BINDING

Each session must maintain:

- active model
- context window
- history

Session must be isolated.

---

## RESOURCE CONTROL

Runtime must:

- enforce limits
- manage concurrency
- avoid memory overflow

---

## PACKAGE VALIDATION

Runtime must reject:

- partial fragments
- unassembled shards
- missing tokenizer
- missing config
- missing weights
- unverified legacy package layouts
- external dependency-bound packages
- packages without backend compatibility metadata

A model package may be registered only when it can be resolved into an ICOS-compatible provider contract.

---

## NO PLACEHOLDER EXECUTION RULE

Runtime must never produce fake inference.

Forbidden runtime behavior includes:

- echoing user input as model output
- returning static assistant text as intelligence
- pretending backend execution occurred
- masking backend absence with UI responses
- silently falling back to unrelated providers

If inference backend is unavailable, runtime must report explicit backend unavailability.

---

## ISOLATION GUARANTEE

Each execution must:

- be independent
- not share mutable state
- not affect other sessions

---

## PERFORMANCE BASELINE

Runtime must achieve:

- stable latency
- predictable throughput
- efficient resource usage

---

## FAILURE CONDITION

Runtime depends on an external execution layer, hardcodes a provider, executes through a legacy dependency, switches only UI labels, runs placeholder inference, accepts partial model fragments, bypasses the registry, or produces unstable, non-deterministic results.

---

## SUCCESS CONDITION

ICOS operates a fully native, stable, deterministic, provider-agnostic runtime engine with complete execution control, registry-driven model switching, local/native/cloud provider separation, user-created model governance, and no legacy dependency path.

---

## Change Log

- 2026-04-29 — v2.2 Runtime clarification. Explicit separation enforced between execution layer, coordination layer (Supabase), and distribution layer. Cloud execution redefined as external inference infrastructure, not Supabase runtime. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: ICOS runtime architecture correction during model installation phase.
- 2026-04-28 — v2.1 Provider-agnostic runtime execution, model switching runtime binding, local/native/cloud execution separation, user-created model runtime boundaries, training lifecycle runtime boundaries, package validation, and no-placeholder execution rules added. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: ICOS native runtime architecture rebuild after runtime contamination repair and model provider strategy correction.
- 2026-04-28 — v2.0 Native runtime architecture defined with layered execution model and deterministic flow. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Implementation architecture initialization.

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
