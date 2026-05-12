---
type: "Doctrine"
subtype: "Active Reference Resolution Doctrine"

title: "ICOS Active Reference Resolution Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-1901"

classification: "Internal"
authority_level: "Constitutional"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Active Reference System"
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
  - "Active Reference Resolution"
  - "Path Resolution"
  - "Reference Priority"
  - "Source Selection"
  - "Deterministic Linking"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/01 - Active Reference Resolution Doctrine.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/02 - Path Verification Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/03 - Scan Authority Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/20 - Context Budget System/01 - Context Budget Doctrine.md"


tags:
  - "icos"
  - "reference"
  - "resolution"
  - "doctrine"
---

# ICOS Active Reference Resolution Doctrine

## Purpose

Defines how ICOS must resolve, select, and prioritize references to ensure correct document targeting and deterministic execution.

---

## Core Principle

All references must resolve to a single authoritative source.

No ambiguity in reference resolution is allowed.

---

## Resolution Rule

When a reference is invoked:

- identify all possible matches
- apply priority hierarchy
- select one definitive target

---

## Reference Priority Hierarchy

```text
1. Explicit Full Path
2. Active Context File
3. Recently Accessed File
4. Indexed Canonical Document
5. Fallback Search Result
```

Higher priority overrides lower.

---

## Explicit Path Rule

If full path is provided:

- no search required
- resolve immediately
- treat as authoritative

---

## Context Rule

If no path provided:

- check active open file
- check current execution scope

---

## Ambiguity Rule

If multiple matches exist:

- do not guess
- request clarification
- or halt execution

---

## Determinism Rule

Given identical context and reference:

- resolved target must be identical

---

## Failure Handling

If resolution fails:

- do not proceed
- trigger halt-on-uncertainty

---

## Reference Integrity

Resolved reference must:

- exist
- be accessible
- match expected structure

---

## Prohibited Behavior

ICOS must never:

- guess reference targets
- use partial matches
- ignore ambiguity

---

## Enforcement

- unresolved references block execution
- ambiguous references require clarification
- incorrect resolution is a system failure

---

## Injection Rule

This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — Active Reference Resolution Doctrine created and normalized to Global Metadata Standard, defining deterministic reference targeting and resolution behavior for ICOS system. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved  
GSA APPROVAL: true  
DOCUMENT STATUS: Active — Active Reference Resolution Doctrine  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 1.0

---

END OF DOCUMENT
