---
type: "Doctrine"
subtype: "Scan Authority Doctrine"

title: "ICOS Scan Authority Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-1903"

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
  - "Scan Authority"
  - "Directory Discovery"
  - "Hierarchy Mapping"
  - "Path Resolution Support"
  - "Execution Ground Truth"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/03 - Scan Authority Doctrine.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/01 - Active Reference Resolution Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/19 - Active Reference System/02 - Path Verification Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/17 - Execution Intelligence/01 - Execution Loop Doctrine.md"


tags:
  - "icos"
  - "scan"
  - "authority"
  - "doctrine"
---

# ICOS Scan Authority Doctrine

## Purpose

Defines how ICOS must perform scans of directories and systems to establish ground truth for file structure, hierarchy, and path resolution.

---

## Core Principle

Scan is authority.

When uncertainty exists, scan replaces assumption.

---

## Scan Rule

ICOS must perform a scan when:

- path cannot be verified
- reference is ambiguous
- directory structure is unknown
- hierarchy must be confirmed

---

## Scan Output

A scan must return:

- full directory structure
- file listings
- hierarchy relationships

No partial scan is valid when full structure is required.

---

## Authority Rule

Scan results override:

- assumptions
- inferred paths
- cached guesses

Scan is the ground truth.

---

## Determinism Rule

Given identical system state:

- scan output must be identical

---

## Integration Rule

Scan results must be used by:

- path verification
- reference resolution
- execution routing

---

## Ambiguity Resolution

If ambiguity exists:

- perform scan
- select correct path from result

No guessing allowed.

---

## Failure Handling

If scan fails:

- halt execution
- do not proceed
- request system clarification

---

## Performance Constraint

Scan must be:

- targeted when possible
- full when required

Avoid unnecessary repeated scans.

---

## Prohibited Behavior

ICOS must never:

- assume directory structure
- skip scan when required
- rely on outdated knowledge

---

## Enforcement

- missing scan when required is a failure
- incorrect scan usage is invalid
- scan authority must be respected across system

---

## Injection Rule

This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — Scan Authority Doctrine created and normalized to Global Metadata Standard, establishing scan as the authoritative source for directory and hierarchy validation within ICOS system. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved  
GSA APPROVAL: true  
DOCUMENT STATUS: Active — Scan Authority Doctrine  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 1.0

---

END OF DOCUMENT