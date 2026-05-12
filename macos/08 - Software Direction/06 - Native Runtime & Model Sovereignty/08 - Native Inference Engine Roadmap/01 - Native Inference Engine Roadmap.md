---
type: Roadmap
subtype: Native Inference Engine

title: ICOS Native Inference Engine Roadmap
document_id: SW-ICOS-RDM-2026-0029

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
approval_status: Approved

gsa_protocol: "Active"
gsa_approved: true

status: Active
lifecycle: Canonical
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v2.0.2"
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
  - "Inference Engine Development"
  - "Runtime Evolution"
  - "Performance Optimization"
  - "GPU/CPU Execution"
  - "Production Readiness"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/08 - Native Inference Engine Roadmap/01 - Native Inference Engine Roadmap.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

tags:
  - "icos"
  - "inference"
  - "runtime"
  - "roadmap"
  - "software-direction"
---

## PURPOSE

Define the phased development of ICOS native inference engine from initial runtime to fully optimized production system.

---

## CORE POSITION

Inference is owned internally.

Performance and control are first-class priorities.

---

## CURRENT RUNTIME STATUS · 2026-04-29

ICOS has crossed the first local execution boundary, but the CLI-process bridge is not the production runtime architecture.

The previous JavaScriptCore/native.runtime.js path is deprecated and must be removed from active product direction.

The llama-cli bridge is classified as a diagnostic validation tool only.

It may validate that GGUF models, llama.cpp builds, and local model execution work, but it must not remain the market-ready runtime boundary.

The active production architecture is now:

```text
ICOS App
→ RuntimeManager
→ ModelRegistry
→ Provider Router
→ Local Native Runtime Service OR Cloud Frontier Provider
→ Streaming Response UI
```

The downloaded source model was converted into executable GGUF format.

The current runtime model set is:

```text
Runtime/Models/icos-base.gguf        → Q4_K_M active fast local candidate
Runtime/Models/icos-base-bf16.gguf   → BF16 preserved reference model
```

The system has validated local model assets, but production readiness requires replacement of the process-based `llama-cli` execution bridge with a native runtime service or library binding.

---

## ACHIEVED WORK · RUNTIME FOUNDATION

- Ollama removed from the active architecture.
- JavaScriptCore/native.runtime.js deprecated for active execution.
- Hugging Face source model converted into GGUF runtime format.
- BF16 reference model preserved.
- Q4_K_M runtime model created and activated as the fast local candidate.
- llama.cpp compiled and validated locally.
- Real GGUF inference validated through terminal execution.
- Xcode project delinked from llama.cpp dynamic libraries.
- Runtime binaries moved outside the synchronized ICOS source tree.
- App binary verified clean from libggml, libllama, libmtmd, libssl, and libcrypto linkage.
- Legacy runtime folder identified for safe removal: `software/runtime/`.

---

## CURRENT BLOCKERS

- `llama-cli` process execution is not a production-grade runtime boundary.
- UI response delivery must be implemented through streaming callbacks, not terminal-style CLI capture.
- Local runtime must be implemented as a native llama.cpp library binding or dedicated runtime service.
- Cloud frontier fallback must be integrated through the Provider Router for Codex-level coding and platform-building tasks.
- ModelRegistry must distinguish source, runtime, quantized-runtime, local, and cloud provider models.
- Legacy JavaScript runtime folders must be removed from the active product tree after documentation and source-control safety checks.

---

## QUANTIZATION POSITION

Quantization is an optimization process for GGUF runtime models.

It creates a new model file and does not destroy the higher-precision model unless explicitly deleted.

The current BF16 model must be preserved until optimized runtime models are validated.

The required test sequence is:

```text
icos-base.gguf              → BF16 reference runtime model
icos-base-q4_k_m.gguf       → fast product baseline candidate
icos-base-q5_k_m.gguf       → higher-quality product baseline candidate
```

Q4_K_M is the first practical performance target.

Q5_K_M should be tested after Q4_K_M to evaluate quality retention.

No source or reference model should be deleted until the optimized model is verified through the ICOS UI and runtime logs.

---

## PRODUCT POSITIONING STANDARD

ICOS must not be marketed as Gemma.

ICOS is the cognitive operating system.

Gemma, Mistral, local GGUF models, and cloud models are interchangeable model engines.

The correct product framing is:

```text
ICOS provides the cognitive operating system, workspace architecture, memory layer, model routing, execution interface, and continuity system.
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

## SHIPPING REQUIREMENT

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
- local/cloud model switching
- runtime health status
- model deletion and storage management
- fallback provider routing
- native runtime service or library binding
- provider router for cloud frontier fallback
- streaming token callback interface

The software must operate as an installable product, not as a developer setup.

---

## PHASE 01 · BASIC EXECUTION LAYER

Objective:

- load local model
- execute simple inference
- return output

Requirements:

- model loading
- token generation loop
- minimal memory handling

---

## PHASE 01 · EXECUTION CONTRACT

The basic execution layer must define:

- deterministic token loop
- input/output schema
- error boundaries

Execution must be reproducible for identical inputs.

---

## PHASE 02 · STREAMING & SESSION SUPPORT

Objective:

- implement token streaming
- bind sessions
- preserve context

Requirements:

- incremental output
- session memory link

---

## STREAMING CONTRACT

Streaming must:

- emit tokens incrementally
- preserve order
- support interruption

Streaming must be consistent across all models.

---

## PHASE 03 · RESOURCE MANAGEMENT

Objective:

- control CPU/GPU usage
- manage memory
- prevent overload

Requirements:

- batching
- queueing
- concurrency limits

---

## SCHEDULER MODEL

Scheduler must:

- queue requests
- batch compatible workloads
- prioritize based on policy

Scheduler must prevent starvation and overload.

---

## PHASE 04 · MULTI-MODEL SUPPORT

Objective:

- load multiple models
- switch dynamically

Requirements:

- model registry binding
- runtime switching

---

## MODEL LIFECYCLE MANAGEMENT

Each model must support:

- load
- unload
- hot-swap

Lifecycle must be controlled by runtime.

---

## PHASE 05 · OPTIMIZATION LAYER

Objective:

- reduce latency
- improve throughput

Methods:

- quantization support
- caching
- optimized kernels

Immediate optimization target:

- create Q4_K_M GGUF from the BF16 reference model
- validate response speed through terminal
- bind Q4_K_M as a selectable model variant
- test Q5_K_M for higher-quality comparison
- select default local model based on speed-quality balance

---

## OPTIMIZATION GUARANTEES

Optimization must not:

- alter output determinism
- break compatibility

All optimizations must be measurable.

---

## PHASE 06 · GPU ACCELERATION

Objective:

- maximize hardware performance

Requirements:

- GPU execution paths
- device-aware scheduling

---

## DEVICE ABSTRACTION

Runtime must abstract:

- CPU
- GPU
- future accelerators

Execution must remain consistent across devices.

---

## PHASE 07 · STABILITY & FAULT TOLERANCE

Objective:

- ensure continuous operation

Requirements:

- error isolation
- retry mechanisms
- fallback handling

---

## FAULT ISOLATION

Failures must:

- be isolated per request
- not cascade across sessions

System must recover automatically.

---

## PHASE 08 · SECURITY HARDENING

Objective:

- protect runtime execution

Requirements:

- sandboxing
- execution boundaries
- permission enforcement

---

## EXECUTION SANDBOX

Inference must run within:

- controlled memory space
- restricted execution boundaries

No access to host system beyond defined scope.

---

## PHASE 09 · PRODUCTION READINESS

Objective:

- enterprise-level reliability

Requirements:

- monitoring
- logging
- metrics
- autoscaling readiness

---

## OBSERVABILITY

System must expose:

- metrics (latency, throughput)
- logs
- health status

Observability is required for production operation.

---

## PERFORMANCE TARGETS

The engine must achieve:

- predictable latency
- stable throughput
- efficient resource usage

Targets must be defined and monitored.

---

## FINAL STATE

The inference engine must:

- operate independently
- outperform bridge-based solutions
- integrate seamlessly with ICOS runtime

The final state must follow this runtime chain:

```text
ICOS App
→ RuntimeManager
→ ModelRegistry
→ Provider Router
→ Local Native Runtime Service OR Cloud Frontier Provider
→ Streaming Response UI
```

---

## FAILURE CONDITION

System remains dependent on CLI-process bridges, legacy JavaScript runtime layers, unmanaged external runtimes, or lacks performance, streaming, and stability.

---

## SUCCESS CONDITION

ICOS operates through RuntimeManager, ModelRegistry, Provider Router, native local runtime service, and cloud frontier fallback, with complete control, streaming output, measurable performance, and production-grade reliability.

---

## Change Log

- 2026-04-29 — v2.2 Corrected runtime direction from llama-cli process bridge to production architecture: RuntimeManager → ModelRegistry → Provider Router → Local Native Runtime Service OR Cloud Frontier Provider → Streaming Response UI. Classified llama-cli as diagnostic only, recorded Q4_K_M active local candidate, preserved BF16 reference, confirmed Xcode delinking from llama dynamic libraries, identified legacy `software/runtime/` for safe removal, and restored market-ready runtime path. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS production runtime correction after CLI bridge failure.
- 2026-04-29 — v2.1 Documented active runtime migration from JavaScriptCore/native.runtime.js to embedded llama.cpp + GGUF architecture; recorded achieved work, remaining blockers, quantization plan, product positioning standard, shipping requirements, and final RuntimeManager → ModelRegistry → embedded engine → streaming UI target. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS local inference runtime integration and product architecture hardening.
- 2026-04-28 — v2.0 Native inference engine roadmap defined with phased development from basic execution to production readiness. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Runtime sovereignty roadmap.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Active  
GSA APPROVAL: true  
DOCUMENT STATUS: Active — Approved  
VERSION: 2.2

---

END OF DOCUMENT