---
type: Standard
subtype: Ollama Deprecation & Migration

title: Ollama Deprecation & Migration Standard
document_id: SW-NRS-STD-2026-0003

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
version: "2.0"

created_date: "2026-04-28"
last_updated: "2026-04-28"
last_reviewed: "2026-04-28"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Ollama Dependency Removal"
  - "Migration Strategy"
  - "Runtime Decoupling"
  - "Model Transfer Protocol"
  - "Native ICOS Adoption"
  - "Legacy System Decommission"

index_targets:
  - "Native Runtime Sovereignty Index"

vault_path: "software/macos/06 - Native Runtime & Model Sovereignty/02 - Ollama Deprecation & Migration/01 - Ollama Deprecation & Migration Standard.md"

related:
  - "software/macos/06 - Native Runtime & Model Sovereignty/01 - Model Storage Ownership/01 - Model Storage Ownership Architecture.md"
  - "software/macos/06 - Native Runtime & Model Sovereignty/07 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"

tags:
  - "icos"
  - "ollama"
  - "migration"
  - "deprecation"
---

## PURPOSE

Define the controlled deprecation of Ollama and migration of all models into ICOS-native runtime and storage systems.

---

## CORE POSITION

Ollama is a temporary bridge layer.

It is not part of ICOS sovereignty.

---

## DEPRECATION STRATEGY

Ollama must be phased out through:

1. model extraction
2. storage migration
3. registry re-binding
4. runtime decoupling
5. execution replacement

---

## MIGRATION TARGET

All models must be migrated to:

ICOS Native Storage Layer

Path:
~/Library/Application Support/ICOS/models/

---

## MODEL EXTRACTION

Models currently in Ollama must be:

- identified
- exported
- validated

No runtime dependency may remain.

---

## REGISTRY RE-BINDING

Each migrated model must:

- be registered in Model Registry
- receive new model_id
- map to ICOS storage path

---

## RUNTIME DECISION RULE

After migration:

ICOS runtime must NEVER query Ollama.

Only ICOS registry is valid source.

---

## COMPATIBILITY LAYER

Temporary adapter may exist for:

- transition requests
- dual-run validation

Must be removed after migration completion.

---

## DECOMMISSION PLAN

Ollama must be:

- disconnected from inference path
- removed from active execution flow
- archived as legacy tool

---

## VALIDATION REQUIREMENTS

Migration is complete only when:

- zero active Ollama model usage
- all models registry-bound
- runtime fully ICOS-native

---

## FAILURE CONDITION

System still depends on Ollama for inference or storage.

---

## SUCCESS CONDITION

ICOS operates fully independent of Ollama with native runtime ownership.

---

## Change Log

- 2026-04-28 — v2.0 Ollama deprecation and migration standard defined for full runtime independence. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Native Runtime Sovereignty Agent. Agent ID: A-NRS-0001. Execution Context: Migration phase initialization.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation
GSA APPROVAL: false
DOCUMENT STATUS: Active — Draft
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 2.0

---

END OF DOCUMENT
