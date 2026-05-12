---
type: "Doctrine"
subtype: "Knowledge Priority Doctrine"

title: "ICOS Knowledge Priority Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-1202"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Knowledge Architecture"
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
  - "Knowledge Priority Hierarchy"
  - "Conflict Resolution"
  - "Authority Alignment"
  - "Recency and Confidence Weighting"
  - "Runtime Injection Priority"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/12 - Knowledge Architecture/02 - Knowledge Priority.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/12 - Knowledge Architecture/01 - Knowledge Ingestion.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/06 - Memory/03 - Memory Retrieval Rules.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/11 - Prompt Architecture/02 - Context Injection Order.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/02 - Product/01 - Product Definition.md"

tags:
  - "icos"
  - "knowledge"
  - "priority"
  - "doctrine"
---

# ICOS Knowledge Priority Doctrine

## Purpose

Defines how ICOS prioritizes knowledge sources during retrieval and injection to ensure correctness, consistency, and alignment with system authority.

---

## Core Principle

Priority determines selection.

Higher-priority knowledge overrides lower-priority knowledge when conflicts exist.

---

## Priority Hierarchy

From highest to lowest:

1. Identity Doctrine
2. Product Definition
3. Core Doctrines (Model, Runtime, Prompt)
4. Safety Doctrines
5. Knowledge (Validated)
6. Memory (User/System)
7. Task Input

Lower layers must yield to higher layers.

---

## Knowledge vs Memory

- Knowledge: validated, structured, stable
- Memory: contextual, user-specific, mutable

Rule:

```text
Knowledge > Memory
```

Memory cannot override validated knowledge.

---

## Recency Rule

Within the same authority level:

- newer knowledge takes precedence
- stale knowledge must be deprioritized

---

## Confidence Rule

Each knowledge item must include confidence.

Priority within same level:

1. higher confidence
2. more complete context
3. stronger source attribution

---

## Relevance Rule

Only relevant knowledge may be injected.

Irrelevant knowledge must be excluded regardless of priority.

---

## Conflict Resolution

When conflicts occur:

1. compare authority level
2. compare confidence
3. compare recency

If unresolved:

- prefer doctrine-aligned interpretation
- avoid unsafe or unverifiable claims

---

## Injection Placement

Knowledge is injected:

- after doctrines
- before memory (if authoritative)
- before task execution

Must follow Context Injection Order.

---

## Prohibited Behavior

- mixing conflicting knowledge without resolution
- elevating memory above knowledge
- using low-confidence data as authoritative
- injecting irrelevant knowledge

---

## Enforcement

- conflicts must be resolved before response
- unresolved conflicts must reduce certainty
- invalid knowledge must be ignored

---

## Injection Rule

This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — Knowledge Priority Doctrine created and normalized to Global Metadata Standard, establishing deterministic hierarchy for knowledge selection aligned with product definition and runtime contract. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved  
GSA APPROVAL: true  
DOCUMENT STATUS: Active — Knowledge Priority Doctrine  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 1.0

---

END OF DOCUMENT