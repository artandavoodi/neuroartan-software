---
type: Standard
subtype: "Product Direction Change Log"

title: "Product Direction Changes"
document_id: "INF-SYS-CHG-2026-0001-ACT"

classification: Internal
authority_level: Executive
department: "08 - Software Direction"
office: "04 - Change Log"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO"
  - "ICOS Runtime System"
  - "Model Registry"
  - "Runtime Provider Layer"
  - "All Development Agents"

legal_sensitive: false
requires_gc_review: true
requires_creo_review: true
approval_status: Approved

gsa_protocol: "Active"
gsa_approved: true

status: Active
lifecycle: Canonical
system: "ICOS-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v2.0.2"
version: "1.1"

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
  - "Model Acquisition Tracking"
  - "Runtime Architecture Evolution"
  - "Provider Abstraction Updates"
  - "Model Registry Synchronization"
  - "System Execution State Tracking"

index_targets:
  - "Software Direction Master Index"
  - "Change Log Registry"
  - "Model Integration Tracker"

vault_path: "software/macos/08 - Software Direction/04 - Change Log/04 - Product Direction Changes/01 - Product Direction Changes.md"

related:
  - "software/macos/08 - Software Direction/02 - Roadmap/02 - Milestones/01 - Milestones.md"
  - "software/macos/08 - Software Direction/01 - Directives/05 - Model Registry Directives/01 - Model Registry Directive.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/01 - Runtime Architecture/01 - ICOS Native Runtime Architecture.md"

tags:
  - "product-direction"
  - "change-log"
  - "icos"
  - "runtime"
  - "model-system"

---

## PRODUCT CHANGE SUMMARY

Current active operation: ICOS local runtime migration from model acquisition into embedded llama.cpp + GGUF execution, followed by quantized runtime optimization and UI-visible response delivery.

---

## ACTIVE CHANGE

### CH-001 — Model Acquisition and Runtime Conversion

Status: COMPLETED — RUNTIME ARTIFACT CREATED

- Model Source: Hugging Face source package
- Source Format: safetensors + tokenizer/config files
- Runtime Format: GGUF
- Active Runtime Artifact: `macos/01 - App/ICOS/ICOS/Runtime/Models/icos-base.gguf`
- Runtime Backend: embedded llama.cpp
- Execution Boundary: Swift → ICOSCoreRuntime → ICOSExecutionEngine → llama-cli → GGUF model

System Impact:
- First external large-scale model acquired and converted into an ICOS-executable local runtime artifact
- Ollama removed from the active execution direction
- JavaScriptCore/native.runtime.js deprecated from the active app runtime direction
- Local runtime execution validated through terminal output
- Product direction moved from acquisition into embedded runtime packaging, quantization, and UI response delivery

### CH-002 — Embedded Runtime Packaging

Status: IN PROGRESS

- llama.cpp runtime compiled locally
- `llama-cli` moved into ICOS runtime structure
- llama.cpp dynamic libraries identified and moved into ICOS runtime framework structure
- OpenSSL runtime dependency identified and embedded
- Xcode build phases updated to copy runtime executable, model artifact, and required dynamic libraries
- Runtime path now targets app-owned bundled assets instead of external developer paths

Current technical issue:
- Embedded runtime executes slowly with BF16 model
- `llama-cli` terminal output is visible but does not yet return into the ICOS message UI
- final runtime bridge must capture stdout/stderr, clean output, and append response to active session message stream

### CH-003 — Quantized Runtime Optimization

Status: NEXT

Required model variants:

```text
icos-base.gguf              → BF16 reference runtime model
icos-base-q4_k_m.gguf       → first fast product baseline candidate
icos-base-q5_k_m.gguf       → higher-quality product baseline candidate
```

Direction:
- preserve BF16 reference until optimized variants are validated
- generate Q4_K_M first for usable interactive performance
- generate Q5_K_M after Q4 for quality comparison
- select default local model through speed-quality measurement
- do not delete reference model until Q4/Q5 and UI output routing are verified

---

## SYSTEM STATE

- Runtime Architecture: Migrating from direct execution bridge toward RuntimeManager → ModelRegistry → embedded engine → streaming UI
- Model Registry: Active but requires quantized variant fields and default-runtime candidate support
- Execution Layer: Local embedded llama.cpp path active, but not yet product-grade
- External Dependency Layer: No user-facing dependency allowed; developer-only tooling must not remain in production path
- Model State: GGUF BF16 runtime model created and embedded; Q4/Q5 variants pending
- UI State: message action controls initiated; output capture into message stream still incomplete

Completion Index: 78%

---

## COMPLETED CHANGES

### CH-000 — Runtime Cleanup
- Ollama dependency fully removed
- Legacy execution paths eliminated
- JS runtime stabilized
- Swift bridge corrected

### CH-000.5 — Provider Abstraction Layer
- Provider-agnostic execution implemented
- Local/cloud/native separation defined
- Registry-driven routing enforced

### CH-001 — Source Model Acquisition
- Hugging Face model acquisition completed
- Source model converted into GGUF runtime artifact
- BF16 GGUF reference runtime model created

### CH-002 — Ollama and JavaScriptCore Direction Cleanup
- Ollama removed from active execution direction
- JavaScriptCore/native.runtime.js deprecated from active app runtime direction
- Swift runtime facade established through `ICOSCoreRuntime`
- Local execution bridge established through `ICOSExecutionEngine`

### CH-003 — Embedded Runtime Foundation
- llama.cpp compiled and validated locally
- llama-cli moved into ICOS runtime structure
- required llama.cpp dynamic libraries identified
- OpenSSL dependency identified
- app bundle runtime packaging initiated

### CH-004 — Message Output Controls
- output action menu initiated in `MessageBubbleView`
- Copy action implemented
- Feedback and Bookmark placeholders added for future routing

---

## NEXT SYSTEM ACTIONS

### CH-005 — UI Output Bridge
- capture llama-cli stdout/stderr without blocking UI
- normalize generated response
- remove terminal-only output dependency
- append response into active session messages
- keep copy/action controls available on generated response

### CH-006 — Quantized Model Creation
- create `icos-base-q4_k_m.gguf`
- test speed through terminal
- bind Q4 model as selectable runtime variant
- create `icos-base-q5_k_m.gguf`
- compare quality and speed against Q4

### CH-007 — RuntimeManager and ModelRegistry Layer
- replace direct hardcoded model path with registry-based selection
- introduce RuntimeManager as execution policy layer
- support local/cloud model switching
- expose runtime health status
- prepare streaming response UI

### CH-008 — Product Documentation Propagation
- update Model Registry Directive
- update Milestones
- update Active Development
- update Runtime Architecture implementation document
- update Platform Builder runtime modules

---

## EXECUTION NOTE

The system has moved beyond acquisition and has reached embedded local runtime execution.

The current runtime is not yet product-grade because BF16 execution is too slow and UI response routing is incomplete.

The immediate professional sequence is:

```text
Document achieved architecture
→ fix UI-visible response bridge
→ generate Q4_K_M model
→ test Q4 speed
→ generate Q5_K_M model
→ register model variants
→ introduce RuntimeManager and ModelRegistry execution path
→ implement streaming response UI
```

The product direction remains valid: ICOS is the cognitive operating system; third-party and open models are interchangeable inference engines.

---

## CHANGE LOG

- 2026-04-29 — CH-002/CH-003 documented: recorded local runtime migration from source model acquisition into embedded llama.cpp + GGUF execution, active BF16 runtime artifact, UI output blocker, quantization plan, RuntimeManager/ModelRegistry target, product positioning standard, and no-user-dependency shipping direction. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS runtime product direction hardening.

- 2026-04-28 — CH-001 initiated: Gemma 4 E4B-it model acquisition started. Runtime remains stable and provider-agnostic. Integration pending post-download validation. Operator: ARTAN. System: ICOS Runtime Core.

---

## DOCUMENT CONTROL & VALIDATION

GSA PROTOCOL STATUS: Active
GSA APPROVAL: true
DOCUMENT STATUS: Active — Approved
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.1

---

END OF DOCUMENT