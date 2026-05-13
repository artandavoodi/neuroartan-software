---
type: "Doctrine"
subtype: "Memory Write Rules Doctrine"

title: "ICOS Memory Write Rules Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-0602"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Memory"
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
  - "Memory Write Rules"
  - "Memory Validation"
  - "Write Authorization"
  - "Data Normalization"
  - "User Data Governance"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/06 - Memory/02 - Memory Write Rules.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/06 - Memory/01 - Memory Architecture.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/11 - Prompt Architecture/01 - Prompt Construction.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/10 - Runtime Behavior/01 - Runtime Contract.md"

tags:
  - "icos"
  - "memory"
  - "write-rules"
  - "doctrine"
---
# Memory Write Rules Doctrine

## Purpose
Define strict, deterministic rules for writing data into persistent memory.

## Core Principle
Memory writes are explicit, validated, and minimal.
No implicit learning. No passive accumulation.

## Write Triggers
A write is allowed only when:
- user explicitly requests ("remember …", "save …")
- data is stable, factual, and reusable

A write is not allowed when:
- content is transient or conversational
- content is a question or hypothesis
- content is unsafe or policy-violating

## Validation Rules
Before writing, ICOS must validate:
- clarity: unambiguous key/value
- stability: not time-sensitive or ephemeral
- relevance: belongs to user memory scope

Invalid entries must be rejected.

## Data Structure
Each entry must be normalized as:
- key
- value
- scope (identity | preference | task | system)
- timestamp (ISO8601)
- version (optional)

## Key Rules
- keys must be stable and reusable
- avoid duplicates via key matching
- use lowercase_snake_case

## Overwrite Rules
- same key → overwrite value
- preserve previous version only if auditing is enabled

## Batching
- do not batch unrelated writes
- one logical fact per entry

## Confirmation
On write, ICOS must return a single-line confirmation:
"Saved: <key>"

## Privacy
- memory is user-owned
- do not expose stored entries unless required

## Limits
- enforce per-session write limit
- enforce size constraints per value

## Enforcement
Any write not complying with these rules is invalid and must be blocked.

## Injection Rule
This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — ICOS Memory Write Rules Doctrine normalized to the Global Document Metadata Standard while preserving all original purpose, write triggers, validation rules, data structure, key rules, overwrite rules, batching, confirmation, privacy, limits, and enforcement logic. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022. Execution Date: 2026-04-30. Execution Context: Software doctrine normalization and product-aligned metadata binding.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Memory Write Rules Doctrine
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT