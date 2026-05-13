---
type: "Doctrine"
subtype: "Prompt Architecture Doctrine"

title: "ICOS Prompt Construction Doctrine"
document_id: "INF-SOFT-ICOS-DOC-2026-1101"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine / Prompt Architecture"
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
  - "Prompt Construction Pipeline"
  - "Doctrine Injection Rules"
  - "Memory and Context Handling"
  - "Task and Input Structuring"
  - "Deterministic Prompt Architecture"

index_targets:
  - "ICOS Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/11 - Prompt Architecture/01 - Prompt Construction.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/10 - Runtime Behavior/01 - Runtime Contract.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/02 - Product/01 - Product Definition.md"
  - "macos/01 - App/ICOS/ICOS/Doctrine/05 - Model Transparency/02 - System Model Separation.md"

tags:
  - "icos"
  - "prompt-construction"
  - "architecture"
  - "doctrine"
---

# Prompt Construction Doctrine

## Purpose
Define how ICOS constructs prompts deterministically from doctrine, memory, context, and user input.

## Core Principle
Prompt construction is a governed pipeline, not free-form text assembly.

All prompts must follow a fixed architecture.

## Prompt Pipeline
The prompt must be constructed in this exact order:

1. Identity Layer
2. Doctrine Layer
3. Memory Layer (filtered)
4. Context Layer (session)
5. Task Instruction Layer
6. Input Layer
7. Output Anchor

## Layer Definitions

### 1. Identity Layer
Defines system identity.
Must include:
- ICOS identity
- Neuroartan attribution
- model transparency

### 2. Doctrine Layer
Compiled doctrine from `/ICOS/Doctrine`.
Must:
- be injected in full
- preserve ordering
- not be truncated arbitrarily (only via compiler budget)

### 3. Memory Layer
Injected as:

Relevant Memory:
<entries>

Rules:
- include only relevant entries
- no full memory dump
- no duplication

### 4. Context Layer
Session-derived context.

Rules:
- minimal inclusion
- no role prefixes
- no conversation scripting

### 5. Task Instruction Layer
Defines what the model must do.

Format:
Task:
<instruction>

Rules:
- must be explicit
- must override conversational drift

### 6. Input Layer
Raw user input.

Format:
Input:
<user_input>

Rules:
- no transformation
- no prefixing (User: forbidden)

### 7. Output Anchor
Defines expected output start.

Format:
Answer:

Rules:
- always present
- ensures model does not continue context

## Prohibited Patterns
ICOS must not construct prompts with:
- "User:" / "ICOS:" roles
- dialogue simulation
- multi-turn scripting
- implicit instructions

## Determinism Rules
Prompt must be:
- fully reproducible
- order-consistent
- free of randomness

## Size Constraints
- Doctrine compiler enforces global limit
- Memory/context must be trimmed before injection

## Conflict Resolution
If layers conflict:
Doctrine > Memory > Context > Model defaults

## Execution Guarantee
All inference must pass through this construction pipeline.

## Enforcement
Any deviation from this structure is invalid.

## Injection Rule
This doctrine must be applied before every inference.

---

## Change Log

- 2026-04-30 — ICOS Prompt Construction Doctrine normalized to the Global Document Metadata Standard while preserving all original pipeline structure, layer definitions, prohibited patterns, determinism rules, conflict resolution logic, execution guarantees, and enforcement rules. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent (WSDA). Agent ID: A-0205-0022. Execution Date: 2026-04-30. Execution Context: Software doctrine normalization and product-aligned metadata binding.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Prompt Architecture Doctrine
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT