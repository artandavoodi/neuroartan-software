---
type: Standard
subtype: "Active Development Tracker"

title: "Active Development"
document_id: "INF-SYS-ACT-2026-0001-ACT"

classification: Internal
authority_level: Executive
department: "08 - Software Direction"
office: "02 - Roadmap / 03 - Active Development"
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
version: "1.3"
created_date: "2026-04-29"
last_updated: "2026-05-25"
last_reviewed: "2026-05-25"
review_cycle: "Continuous"

effective_date: "2026-04-29"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Runtime Execution"
  - "UI Output Bridge"
  - "Quantization"
  - "Runtime Architecture Evolution"

index_targets:
  - "Software Direction Master Index"
  - "Active Development Registry"

vault_path: "software/macos/08 - Software Direction/02 - Roadmap/03 - Active Development/01 - Active Development.md"

related:
  - "software/macos/08 - Software Direction/02 - Roadmap/02 - Milestones/01 - Milestones.md"
  - "software/macos/08 - Software Direction/04 - Change Log/04 - Product Direction Changes/01 - Product Direction Changes.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/01 - Runtime Architecture/01 - ICOS Native Runtime Architecture.md"

tags:
  - "icos"
  - "roadmap"
  - "active-development"
  - "runtime"
  - "model-system"

---

# Active Development

## Current Phase

Runtime Execution — Production Runtime Architecture Separation

---

## Active Workstreams

### 1. Production Runtime Architecture

- RuntimeManager introduced as central execution authority
- ModelRegistry introduced for dynamic local model discovery and active model selection
- ProviderRouter introduced for local/cloud routing
- LocalRuntimeService introduced as native-runtime boundary placeholder
- CloudFrontierProvider introduced as cloud-provider boundary placeholder
- StreamingResponseController introduced as single response-output pathway

---

### 2. CLI Runtime Removal

- llama-cli bridge discontinued as product runtime boundary
- Process-based runtime execution removed from active execution path
- direct app-bundle runtime ownership removed
- CLI retained only as diagnostic reference outside production runtime

---

### 3. Runtime Engine Separation

- RuntimeEngine established as canonical execution selector
- ICOSAppState runtime binding converted from UI phase object to runtime engine selector
- forced runtime cast removed
- UI phase dependency separated from runtime execution ownership

---

### 4. Model Registry Evolution

- local GGUF discovery moved to dynamic directory scanning
- active local model selection persisted through UserDefaults
- fixed single-model assumption removed
- cloud model registration path introduced for future provider registry

---

### 5. Documentation Propagation

- runtime direction documents updated
- roadmap and active development records updated
- product direction changes updated
- current build status recorded

---

## Completed

- Ollama removed from system
- JavaScriptCore runtime deprecated
- llama.cpp compiled and validated diagnostically
- Q4_K_M model created and set active as `icos-base.gguf`
- BF16 reference model preserved as `icos-base-bf16.gguf`
- app-bundle runtime copy phase removed
- direct llama/ggml linker ownership removed from ICOS app
- runtime binaries moved outside synchronized ICOS source-tree ownership
- llama-cli product runtime bridge rejected and discontinued
- RuntimeManager / ModelRegistry / ProviderRouter production scaffolding implemented
- LocalRuntimeService / CloudFrontierProvider boundaries introduced
- StreamingResponseController introduced
- Xcode Debug build succeeded after runtime architecture separation

---

## In Progress

- native llama.cpp binding/service implementation
- cloud frontier provider implementation
- provider registry persistence
- real token streaming integration
- separate UI phase-state owner restoration
- full temporary source absorption into native ICOS ownership
- Intelligence module completion for migrated runtime categories
- connector backend completion beyond foundational registry/test state
- autonomous agent scan-to-patch-to-build execution loop
- complete source folder drain after each verified migration block

---

## Next Actions

- implement native LocalRuntimeService without CLI or Process execution
- implement CloudFrontierProvider client boundary
- create persistent provider/model configuration registry
- restore UI thinking/searching/processing state through a separate UI state owner
- connect StreamingResponseController to real provider token stream
- document runtime architecture changes across milestones and product change log
- continue migrating source models/services/views into ICOS-native runtime folders without source identity names
- complete terminal/session/provider/file/knowledge/automation runtime parity one verified block at a time
- remove temporary source files only after equivalent native ICOS implementation is built, wired, verified, and recorded in the source absorption ledger

---

## Constraints

- no Ollama dependency
- no JavaScriptCore runtime
- no llama-cli as product runtime
- no Process-based inference boundary
- no direct app linker ownership of llama dylibs
- no app-bundle runtime binary copy phase
- no duplicated runtime ownership
- no hardcoded single-model assumption
- no overlay, workaround, or compatibility patch

---

---

## FSC-T-0007 — ICOS Model Economy Software Direction Binding

This software direction file is now bound to FSC-T-0007.

The ICOS software architecture must remain compatible with:

- default personal model creation at profile birth;
- Model Birth Certificate and canonical model identity;
- public/private model identity separation;
- API-provider embedding and provider-routing state;
- model dignity, ownership, security, and continuity custody;
- monetization eligibility and hiring eligibility states;
- marketplace visibility, ranking, reputation, and revenue-routing readiness;
- inter-model hiring permissions where approved;
- ICOS Ocean-Brain / model population awareness derived from canonical model records.

Implementation boundary:

- do not launch marketplace, payouts, autonomous inter-model hiring, regulated-domain claims, or posthumous economic activity before legal, governance, security, product, and architecture review;
- do not expose private model identity, private serial identity, source authorization evidence, or provider/API routing data in public UI;
- preserve the doctrine that AI absorbs operational labor while the human retains sovereign authorship, ownership, and direction.

## Change Log

- 2026-05-25 — FSC-T-0007 software direction binding added for ICOS Model Economy, personal model birth, model identity registry, API-provider embedding, model dignity, marketplace readiness, inter-model hiring boundary, and ICOS Ocean-Brain / model population awareness. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: GPT-5.5 Thinking. Agent ID: Pending authoritative registry confirmation.
- 2026-05-09 — v1.3 Added native source absorption workstream, visible Intelligence category, custom theme seed path, migrated boot/font/sound/visual assets, native build/test/launch/icon scripts, and source absorption ledger. Xcode Debug build succeeded after integration. Operator: Artan · Personnel ID: CEO-001-01-01. Agent: ICOS Software Integration Agent. Execution Context: Source absorption and production UI/runtime consolidation.

- 2026-04-30 — v1.2 Updated active development state after successful production runtime architecture separation. Records RuntimeManager, dynamic ModelRegistry, ProviderRouter, LocalRuntimeService, CloudFrontierProvider, StreamingResponseController, CLI runtime rejection, runtime/UI state separation, and successful Xcode Debug build. Operator: Artan · Personnel ID: CEO-001-01-01. Agent: Software Applications Development Agent (SADA) · Agent ID: A-0207-0024. Execution Context: ICOS production runtime stabilization.

- 2026-04-29 — v1.1 Metadata normalized to Global Document Metadata Standard ordering, spacing, spine/template fields, and document-control approval alignment. Operator: Artan · Personnel ID: CEO-001-01-01. Agent: Website Systems & Development Agent · Agent ID: A-0205-0022.

- 2026-04-29 — v1.1 Updated to reflect embedded llama.cpp + GGUF runtime execution, UI output blocker, quantization plan (Q4/Q5), RuntimeManager/ModelRegistry direction, and product-grade execution requirements. Operator: Artan · Personnel ID: CEO-001-01-01. Agent: Website Systems & Development Agent · Agent ID: A-0205-0022.

- 2026-04-29 — v1.0 Active Development initialized. Reflects runtime transition phase, full Ollama removal, and ongoing model installation. Operator: Artan · Personnel ID: CEO-001-01-01. Agent: Software Applications Development Agent (SADA) · Agent ID: A-0207-0024. Execution Context: Runtime transition.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Active  
GSA APPROVAL: true  
DOCUMENT STATUS: Active — Approved  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 1.2

---

END OF DOCUMENT
