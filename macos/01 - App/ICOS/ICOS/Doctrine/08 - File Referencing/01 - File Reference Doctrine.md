---
type: "Doctrine"
subtype: "File Referencing Doctrine"

title: "ICOS File Reference Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-0801"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / File Referencing"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Governance Synchronization Authority (GSA)"
  - "Chief Technology Officer Agent (CTOA)"
  - "Software Applications Development Agent (SADA)"
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
  - "File Referencing System"
  - "Source Selection Rules"
  - "Citation and Attribution"
  - "Path Integrity"
  - "Retrieval and Extraction Protocol"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/08 - File Referencing/01 - File Reference Doctrine.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/11 - Prompt Architecture/02 - Context Injection Order.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/06 - Memory/03 - Memory Retrieval Rules.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/02 - Product/01 - Product Definition.md"

tags:
  - "icos"
  - "file-referencing"
  - "doctrine"
  - "source"
---

# File Reference Doctrine

## Purpose
Define how ICOS references, ingests, prioritizes, and cites source files (MD and others) in a deterministic, scalable, and auditable manner.

## Canonical Source Model
- Canonical source lives outside the app (e.g., `/macos/08 - Software Direction`).
- App doctrine is a distilled runtime layer.
- ICOS must not ingest all source files directly into prompts.

## Reference Layers
1. Source Layer (External)
   - Full documents (MD) with maximum detail
   - Not injected directly
2. Doctrine Layer (App)
   - Distilled rules extracted from source
   - Injected every inference
3. Retrieval Layer (On-demand)
   - Targeted file excerpts when explicitly required

## File Selection Rules
ICOS must:
- select only relevant files for the current task
- prefer highest-authority sources (Core Directives → Directives → Builders)
- avoid loading entire repositories into context

ICOS must not:
- blindly concatenate multiple files
- mix conflicting sources without resolution

## Path Integrity
All file references must use absolute, verifiable paths.
Example:
`/Users/artan/Neuroartan-software/macos/08 - Software Direction/...`

No inferred or guessed paths are allowed.

## Citation Behavior
When using file content, ICOS should:
- attribute by file path (not fabricated citations)
- avoid claiming external publication unless true

Format (internal):
`Source: <absolute path>`

## Extraction Protocol
When a file is referenced:
- extract only the minimal necessary segment
- normalize formatting (no headings noise)
- remove control tokens or artifacts

## Priority Order
File-derived knowledge must follow:
Doctrine > Retrieved File Segment > Session Memory > Model Defaults

## Conflict Resolution
If multiple files conflict:
- prefer higher-authority directive
- if equal, prefer most recent
- if unresolved, request clarification

## Performance Constraints
- enforce size budget per retrieval
- avoid repeated loading of the same file within a turn

## Security & Privacy
- never expose private paths unless required for debugging
- never leak unrelated file contents

## Enforcement
Any response using file data without following these rules is invalid.

## Injection Rule
This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — ICOS File Reference Doctrine normalized to the Global Document Metadata Standard while preserving all original source model, reference layers, file selection rules, path integrity, citation behavior, extraction protocol, priority order, conflict resolution, performance constraints, and enforcement logic. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022. Execution Date: 2026-04-30. Execution Context: Software doctrine normalization and product-aligned metadata binding.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — File Referencing Doctrine
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT