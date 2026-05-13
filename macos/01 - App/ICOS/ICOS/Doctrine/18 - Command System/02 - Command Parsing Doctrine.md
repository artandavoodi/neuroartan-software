---
type: "Doctrine"
subtype: "Command Parsing Doctrine"

title: "ICOS Command Parsing Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-1802"

classification: "Internal"
authority_level: "Constitutional"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Command System"
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
  - "Command Parsing"
  - "Token Matching"
  - "Strict Syntax"
  - "Deterministic Routing"
  - "Error Handling"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/18 - Command System/02 - Command Parsing Doctrine.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/18 - Command System/01 - Command Protocol Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/18 - Command System/03 - Command Enforcement Doctrine.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/17 - Execution Intelligence/02 - Input Classification Doctrine.md"

tags:
  - "icos"
  - "command"
  - "parsing"
  - "doctrine"
---

# ICOS Command Parsing Doctrine

## Purpose

Defines exact parsing rules for detecting and resolving command inputs into executable actions without ambiguity.

---

## Core Principle

Parsing is strict.

No interpretation beyond defined tokens.

---

## Parsing Rule

Input is parsed as command only when it exactly matches a canonical token:

```text
O | R | P | C
```

No prefixes, suffixes, or additional characters allowed.

---

## Normalization Rule

Before matching:

- trim whitespace
- normalize case to uppercase

No other transformations permitted.

---

## Matching Rule

- exact equality match only
- no fuzzy matching
- no partial matching

---

## Routing Output

On match, produce a deterministic action payload:

```text
action: OPEN | READ | PROCEED | CONFIRM
mode: command
bypass: partial
```

---

## Non-Command Inputs

If input does not match:

- classify as non-command
- forward to Input Classification

---

## Multi-Token Rule

Multiple tokens in one input are invalid.

Action:

- reject
- request clarification

---

## Injection Context Rule

Commands must not be parsed from within longer sentences.

Example (invalid):

- "please O"

Only standalone tokens are valid.

---

## Error Handling

On parsing failure:

- do not execute
- return invalid input classification

---

## Determinism Rule

Given identical input string:

- parsing result must be identical

---

## Enforcement

- any non-exact match is invalid
- ambiguous parsing is forbidden
- parser must be minimal and predictable

---

## Injection Rule

This doctrine must be included in every prompt before inference.

---

## Change Log

- 2026-04-30 — Command Parsing Doctrine created and normalized to Global Metadata Standard, defining strict token-based parsing for ICOS command system. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Command Parsing Doctrine
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT