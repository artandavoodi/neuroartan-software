---
type: Standard
subtype: Ollama Deprecation & Migration

title: ICOS Ollama Deprecation & Migration Standard
document_id: SW-ICOS-STD-2026-0023

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
  - "Ollama Deprecation"
  - "Runtime Migration"
  - "Model Transfer"
  - "Execution Transition"
  - "System Continuity During Migration"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/02 - Ollama Deprecation & Migration/01 - Ollama Deprecation & Migration Standard.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

 tags:
  - "icos"
  - "ollama"
  - "migration"
  - "runtime"
  - "software-direction"
---

## PURPOSE

Define the structured, controlled removal of Ollama as a runtime dependency and the migration to a fully native ICOS runtime.

---

## CORE POSITION

Ollama is transitional.

ICOS must not depend on it for core execution.

Migration must enforce strict separation between execution layer (ICOS runtime), coordination layer (Supabase), and distribution layer (model delivery).

---

## CURRENT ROLE OF OLLAMA

Ollama dependency has been fully removed from the system. This section is retained for historical and migration documentation purposes only.

Ollama currently provides:

- local model loading
- inference serving
- API bridge
- process management

This role must be replaced.

---

## DEPRECATION PRINCIPLE

Deprecation must be:

- controlled
- staged
- non-disruptive

System continuity must be preserved.

---

## MIGRATION PHASES

### Phase 1 · Parallel Runtime

- keep Ollama active
- introduce native runtime
- mirror execution paths

### Phase 2 · Dual Execution Validation

- validate output parity
- test performance and stability
- ensure feature completeness

### Phase 3 · Traffic Shift

- route execution to native runtime
- reduce Ollama dependency

### Phase 4 · Full Removal

- disable Ollama runtime
- remove dependency from system

---

## EXECUTION OWNERSHIP TRANSITION

Ownership must shift in sequence:

- model loading → ICOS
- inference execution → ICOS
- API routing → ICOS
- process lifecycle → ICOS

No shared ownership is allowed in final state.

---

## MODEL TRANSFER

Model files must be:

- copied from Ollama-managed directories
- relocated into ICOS-owned directories
- reindexed by ICOS runtime

No dependency on Ollama file structure.

---

## MODEL COMPATIBILITY NORMALIZATION

Transferred models must be:

- validated against ICOS runtime
- normalized to ICOS storage format
- reindexed into model registry

No direct execution from Ollama format.

---

## DIRECTORY MIGRATION RULE

System must:

- identify Ollama model paths
- extract model artifacts
- rebind to ICOS storage architecture

---

## API MIGRATION

Replace Ollama API with:
- external inference endpoint compatibility (for cloud execution)
- ICOS native API gateway
- direct runtime binding

---

## API PARITY REQUIREMENT

The ICOS API must:

- match or exceed Ollama capabilities
- support streaming, sessions, parameters
- preserve request/response structure consistency

Migration must not degrade functionality.

---

## EXECUTION MIGRATION

All execution paths must transition from:

Ollama → ICOS Native Runtime

Without altering system behavior.

---

## COMPATIBILITY REQUIREMENT

During migration:

- maintain response consistency
- maintain session continuity
- maintain model behavior

---

## FAILURE PROTECTION

If native runtime fails:

- fallback to Ollama (temporary)
- log failure
- prevent system disruption

Fallback must be removed after stabilization.

---

## FALLBACK CONTROL

Fallback to Ollama must be:

- explicitly enabled
- logged and traceable
- automatically disabled after stabilization

Fallback must not become permanent.

---

## DATA INTEGRITY

Ensure:

- no data loss
- no model corruption
- consistent model references

---

## SECURITY

During migration:

- protect model files
- enforce access control
- validate execution boundaries

---

## NO PARTIAL DEPENDENCY RULE

The system must not remain partially dependent on Ollama.

Either:

- fully integrated
or
- fully removed

---

## MIGRATION VALIDATION

Each phase must be validated with:

- execution parity tests
- performance benchmarks
- stability verification

Migration must not proceed without validation.

---

## FINAL STATE

ICOS runtime must:
- execute models locally or via external inference infrastructure (not Supabase)
- own all model execution
- own all model storage
- expose its own API

Ollama dependency is permanently removed. No execution, storage, or API pathway depends on Ollama. System is currently in post-removal stabilization phase toward full native operational readiness.

---

## FAILURE CONDITION

System still relies on Ollama for core inference.

---

## SUCCESS CONDITION

Ollama is completely removed and ICOS operates on native runtime architecture. System may be in stabilization phase but contains zero dependency on Ollama.

---

## Change Log

- 2026-04-29 — v2.2 Full Ollama removal. Ollama dependency permanently removed from system. Runtime now operates without any Ollama dependency; system in post-removal stabilization phase toward full operational readiness. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Ollama removal finalization during ICOS runtime transition.
- 2026-04-29 — v2.1 Runtime transition enforcement. Ollama deprecation aligned with ICOS runtime architecture separation (execution vs coordination vs distribution). Cloud execution clarified as external inference infrastructure, not Supabase runtime. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Runtime transition phase during model installation.
- 2026-04-28 — v2.0 Ollama deprecation and migration strategy defined with phased execution and full runtime sovereignty objective. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Runtime sovereignty expansion.
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