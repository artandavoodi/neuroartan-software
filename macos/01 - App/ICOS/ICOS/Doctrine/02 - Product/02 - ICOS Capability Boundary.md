---
type: "Doctrine"
subtype: "Product Capability Boundary Doctrine"

title: "ICOS Capability Boundary Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-0202"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Product"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Governance Synchronization Authority (GSA)"
  - "Chief Technology Officer Agent (CTOA)"
  - "Software Applications Development Agent (SADA)"
  - "Website Systems & Development Agent (WSDA)"
  - "All ICOS Runtime Agents"

legal_sensitive: false
requires_gc_review: false
requires_creo_review: false
approval_status: "Approved"

gsa_protocol: "Approved"
gsa_approved: true

status: "Active"
lifecycle: "Canonical"
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v1.6"
version: "1.0"

created_date: "2026-04-30"
last_updated: "2026-04-30"
last_reviewed: "2026-04-30"
review_cycle: "Continuous"

effective_date: "2026-04-30"

publish: false
publish_to_website: false
featured: false
visibility: "Internal"
institutional_visibility: "Executive"

scope:
  - "ICOS Capability Boundary"
  - "Runtime Architecture Scope"
  - "Developer Console Definition"
  - "Cognitive Engine Integration"
  - "Website Integration Rules"
  - "Runtime Migration Strategy"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/02 - Product/02 - ICOS Capability Boundary.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/02 - Product/01 - Product Definition.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/10 - Runtime Behavior/01 - Runtime Contract.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/11 - Prompt Architecture/01 - Prompt Construction.md"

tags:
  - "icos"
  - "capability-boundary"
  - "doctrine"
  - "runtime"
---

# ICOS Capability Boundary Doctrine

## Purpose

Defines the exact functional boundary of ICOS as a Cognitive Operating System, aligning runtime architecture, developer console, cognitive engine, and cross-layer integration with the product definition.

---

## Runtime Architecture Scope

### Phase 1 — External Runtime

```text
Ollama Runtime
→ external process
→ model inference
```

### Phase 2 — Adapter Layer

```text
ModelRuntimeProvider
```

Implementations:

```text
OllamaProvider
MLXProvider (future)
```

Ensures:

- runtime replaceable without app changes
- migration stability

---

### Phase 3 — Native Runtime (Target)

```text
Neuroartan Native Runtime
→ MLX (Apple)
→ direct model execution
→ tokenizer + inference loop
→ memory integration
```

Requirements:

- Apple Silicon optimized
- no external dependency
- full execution control

---

## Developer Console (Primary Product Surface)

```text
Developer Console
```

Capabilities:

- prompt execution
- execution memory tracking
- document read / edit / create
- system scanning
- validation output
- error classification

Modules:

```text
Input Panel
Execution Panel
Command Panel
File Context Panel
Validation Panel
System State Panel
```

Replaces:

- terminal usage
- raw model chat

---

## Cognitive Engine Layer

Binds:

- Master Prompt
- Onboarding System
- Execution Protocol
- Prompt Packet Standard
- Validation Standard

Function:

```text
input → classification → routing → execution → validation → continuation
```

---

## Website & Platform Integration

Supports:

```text
Website builder
→ HTML / CSS / JS
→ fragments
→ layout
→ tokens
→ system wiring
```

Rules:

- must read WSAM before modification
- must map ownership chain
- must not create parallel systems

---

## Runtime Exit Strategy

Ollama must be removable.

Migration path:

```text
Ollama
→ Runtime Adapter
→ MLX Runtime
```

Removal conditions:

- MLX loading confirmed
- inference stable
- performance acceptable
- system control verified

---

## Product Boundary Statement

ICOS is:

```text
Cognitive Operating System
```

Not:

```text
AI Chat App
```

Core value:

- structured cognition
- execution intelligence
- system-building capability
- local sovereignty

---

## Implementation Priority

1. Native app shell (Xcode)
2. Developer console
3. Ollama adapter integration
4. Execution + validation loop
5. Document system control
6. Website builder integration
7. Runtime abstraction layer
8. MLX migration

---

## Success Condition

System is complete when:

- model runs inside native app
- agent executes tasks without terminal
- documents managed inside system
- website built inside system
- runtime switch without break

---

## Change Log

- 2026-04-30 — Capability Boundary Doctrine normalized to global metadata standard and aligned to product definition, preserving runtime architecture, developer console, cognitive engine, and migration strategy. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022. Execution Context: Product-aligned doctrine reconstruction.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Capability Boundary Doctrine
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT