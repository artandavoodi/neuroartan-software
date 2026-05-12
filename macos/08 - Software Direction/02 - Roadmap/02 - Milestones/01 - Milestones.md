---
type: Standard
subtype: "Milestone Tracker"

title: "ICOS Milestones"
document_id: "INF-SYS-MIL-2026-0001-ACT"

classification: Internal
authority_level: Executive
department: "08 - Software Direction"
office: "02 - Roadmap / 02 - Milestones"
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
  - "Model Acquisition"
  - "Runtime Architecture Stabilization"
  - "Provider Abstraction Layer"
  - "Model Registry Integration"

index_targets:
  - "Software Direction Master Index"
  - "Milestone Registry"
  - "Model Integration Tracker"

vault_path: "software/macos/08 - Software Direction/02 - Roadmap/02 - Milestones/01 - Milestones.md"

related:
  - "software/macos/08 - Software Direction/04 - Change Log/04 - Product Direction Changes/01 - Product Direction Changes.md"
  - "software/macos/08 - Software Direction/01 - Directives/05 - Model Registry Directives/01 - Model Registry Directive.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/01 - Runtime Architecture/01 - ICOS Native Runtime Architecture.md"

tags:
  - "icos"
  - "roadmap"
  - "milestones"
  - "runtime"
  - "model-system"

---

## MILESTONE OVERVIEW

This document tracks execution milestones for the ICOS system runtime and model integration lifecycle.

Current focus: ICOS local runtime migration to embedded llama.cpp + GGUF execution, followed by quantized runtime optimization and UI response delivery.

---

## CURRENT SYSTEM STATE

- Runtime: Embedded llama.cpp execution active (not yet product-grade)
- Ollama dependency: Removed
- JavaScriptCore runtime: Deprecated for active execution
- Model Registry: Active (requires quantized variant support)
- Execution Layer: Local runtime validated through terminal
- Model State: BF16 GGUF runtime model created and embedded
- UI State: output visible in terminal, not yet routed into ICOS message stream

Completion Index: 78%

---

## ACTIVE MILESTONE

### M1 — Model Acquisition and Runtime Conversion

Status: COMPLETED

- Source model acquired from Hugging Face
- Model converted into GGUF runtime format
- BF16 runtime artifact created: `icos-base.gguf`
- Runtime execution validated via embedded llama.cpp (terminal-level)

Objective achieved:
- Model acquisition
- Model conversion
- First local inference execution

---

### M2 — Embedded Runtime Packaging

Status: IN PROGRESS

- llama.cpp compiled and embedded
- runtime binary (`llama-cli`) integrated into ICOS
- dynamic libraries embedded
- OpenSSL dependency embedded
- Xcode build pipeline updated for runtime packaging

Blocker:
- UI does not yet receive model output
- runtime output remains terminal-only
- BF16 model too slow for interactive use

---

## COMPLETED MILESTONES

### M0 — Runtime Stabilization
- Ollama fully removed
- Legacy execution paths eliminated
- JS runtime stabilized
- Swift bridge corrected

### M0.5 — Provider Abstraction Layer
- Provider-agnostic execution implemented
- Local/cloud/native separation defined
- Registry-driven routing enforced

### M1 — Model Acquisition and Conversion
- Hugging Face model acquired
- Model converted into GGUF runtime format
- BF16 runtime model created
- First inference executed successfully (terminal)

### M1.5 — Runtime Direction Cleanup
- Ollama removed from execution path
- JavaScriptCore runtime deprecated
- Swift runtime facade (`ICOSCoreRuntime`) established
- Local execution bridge (`ICOSExecutionEngine`) established

---

## NEXT MILESTONES

### M3 — UI Output Bridge
- capture llama-cli stdout/stderr
- normalize output
- append response into ICOS message stream
- ensure output is visible and copyable in UI

### M4 — Quantized Runtime Optimization
- create `icos-base-q4_k_m.gguf`
- test performance improvement
- create `icos-base-q5_k_m.gguf`
- compare quality vs speed
- select default runtime model

### M5 — RuntimeManager & ModelRegistry Integration
- remove hardcoded model paths
- introduce RuntimeManager
- enable model selection via registry
- support local/cloud switching
- expose runtime health

### M6 — Streaming UI
- implement token streaming
- real-time message rendering
- improve perceived speed

---

## SYSTEM NOTE

The system has moved from architecture stabilization into real local inference execution.

The current state is not product-ready.

The critical gap is not model availability but:

- UI response delivery
- runtime performance

The correct sequence is:

```text
Fix UI output bridge
→ Quantize model (Q4)
→ Validate speed
→ Quantize model (Q5)
→ Compare quality
→ Introduce RuntimeManager & ModelRegistry
→ Implement streaming UI
```

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