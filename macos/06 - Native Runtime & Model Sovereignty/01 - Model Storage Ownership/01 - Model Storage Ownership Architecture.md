---
type: Architecture
subtype: Model Storage Ownership

title: Model Storage Ownership Architecture
document_id: SW-NRS-ARC-2026-0002

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
  - "Model Ownership"
  - "Storage Governance"
  - "Local Model Control"
  - "Filesystem Authority"
  - "Migration Independence"

index_targets:
  - "Native Runtime Sovereignty Index"

vault_path: "software/macos/06 - Native Runtime & Model Sovereignty/01 - Model Storage Ownership/01 - Model Storage Ownership Architecture.md"

related:
  - "software/macos/06 - Native Runtime & Model Sovereignty/02 - Ollama Deprecation & Migration/01 - Ollama Deprecation & Migration Standard.md"
  - "software/macos/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/03 - Model Registry Architecture/01 - ICOS Model Registry Implementation Architecture.md"

tags:
  - "icos"
  - "models"
  - "storage"
  - "sovereignty"
---

## PURPOSE

Define full ownership and control of model storage within ICOS, removing dependency on external runtime-managed directories.

---

## CORE PRINCIPLE

All models are system-owned assets.

No external runtime (including Ollama) owns or controls storage.

---

## STORAGE AUTHORITY

ICOS is the sole authority over:

- model file location
- model lifecycle
- model versioning
- model access control

---

## STANDARD STORAGE LOCATION

All models must reside under:

~/Library/Application Support/ICOS/models/

Each model must have:

- isolated directory
- version folder
- metadata manifest

---

## MODEL STRUCTURE

Each model must follow structure:

model_id/
  - version/
  - weights/
  - tokenizer/
  - config.json
  - manifest.json

---

## OWNERSHIP MODEL

Each model must define:

- owner_id = ICOS system or user profile
- origin = imported / system / fine-tuned
- provenance record

---

## MIGRATION RULES

External models (e.g., Ollama) must be:

- copied into ICOS storage
- re-registered in model registry
- detached from original runtime paths

No symbolic dependency allowed.

---

## RUNTIME DEPENDENCY RULE

Runtime must ONLY reference:

Model Registry → Storage Path

Never direct external directory access.

---

## VERSION ISOLATION

Each version must be:

- immutable
- independently addressable
- registry-bound

---

## SECURITY BOUNDARY

Model files must be protected against:

- external modification
- unauthorized read/write
- runtime bypass

---

## REGISTRY INTEGRATION

All storage must sync with:

- Model Registry Architecture

Registry is source of truth for location mapping.

---

## FAILURE CONDITION

Models remain dependent on external runtime directories or are not registry-bound.

---

## SUCCESS CONDITION

ICOS fully owns model lifecycle, storage, and access without external runtime dependency.

---

## Change Log

- 2026-04-28 — v2.0 Model storage ownership architecture defined establishing ICOS as sole storage authority. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Native Runtime Sovereignty Agent. Agent ID: A-NRS-0001. Execution Context: Sovereignty migration layer.

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