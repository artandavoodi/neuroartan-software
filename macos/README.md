---
type: "Standard"
subtype: "Layer Definition"

title: "Software Layer Root Definition"
document_id: "INF-SOFT-STD-2026-0001"

classification: "Internal"
authority_level: "Constitutional"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Governance Synchronization Authority (GSA)"
  - "All Agents"
  - "All Departments"

legal_sensitive: false
requires_gc_review: true
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
  - "Software Layer Root Definition"
  - "Migration Clarification"
  - "Path Authority Enforcement"
  - "Agent Execution Clarity"

index_targets:
  - "Infrastructure Index"

vault_path: "software/macos/00 - README.md"

related:
  - "04 - Infrastructure/06 - Platform Infrastructure/01 - Standards & Governance/03 - Templates/00 - Standards/00 - Global Document Metadata Standard.md"

tags:
  - "software"
  - "infrastructure"
  - "root"
  - "migration"
---

# Software Layer Root Definition

## Purpose

This document defines the canonical location of the Neuroartan software layer.

It exists to eliminate ambiguity and enforce a single source of truth for all software-related operations.

---

## Canonical Software Root

The software layer is external to the Neuroartan root.

`/Users/artan/Neuroartan-software`

---

## Root Relationship

Institutional root:

`/Users/artan/Documents/Neuroartan`

Software is not inside this structure.

---

## Migration

Deprecated:

`/Users/artan/Documents/Neuroartan/software`

Active:

`/Users/artan/Neuroartan-software`

---

## Enforcement

- Old path is invalid
- New path is mandatory
- No agent may reference legacy path

---

## Execution Rule

Agents must:

- Use only the active software root
- Never assume software exists in Vault
- Treat software as sovereign

---

## Structural Context

Primary runtime layer:

`/Users/artan/Neuroartan-software/macos`

---

## Cross-Layer Interaction

Software integrates with:

- Vault
- Website
- ICOS

But remains physically separated.

---

## Change Log

- 2026-04-30 — Initial canonical software layer root definition established after migration.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Canonical Standard
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT