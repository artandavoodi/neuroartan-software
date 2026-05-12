---
type: Architecture
subtype: Workspace Model

title: ICOS Workspace Model
document_id: SW-ICOS-ARC-2026-0016

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Workspace & File System Architecture"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"

legal_sensitive: false
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
  - "Workspace System Architecture"
  - "File System Integration"
  - "Project-Based Structure"
  - "Agent File Awareness"
  - "Local & Cloud Workspace Behavior"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/01 - Workspace Model/01 - Workspace Model.md"

related:
  - "software/macos/08 - Software Direction/00 - Index & Control/00 - Master Control/00 - Software Direction Master Control.md"
  - "software/macos/08 - Software Direction/01 - Directives/12 - Agent Build Engine Directives/07 - Agent Context Intake & Product Awareness Standard.md"

 tags:
  - "icos"
  - "workspace"
  - "file-system"
  - "architecture"
  - "software-direction"
---

## PURPOSE

Define the ICOS workspace as the canonical file system layer where all documents, structures, and projects are directly accessible to both user and agent.

---

## CORE POSITION

Workspace is the system.

Workspace is not a viewer.

Workspace is the source-of-truth file layer.

---

## WORKSPACE DEFINITION

The workspace is a structured directory environment similar to Obsidian.

It must:

- expose full folder hierarchy
- expose all documents
- allow navigation and editing
- serve as live system context

---

## PROJECT MODEL

Each project must:

- bind to a directory root
- expose all files inside that root
- define system context for the agent

Project = context container.

---

## DIRECTORY BINDING

When a project is created:

- its directory is registered
- agent receives full structural awareness
- no scanning is required

Directory is pre-known.

---

## FILE VISIBILITY

The system must expose:

- all files
- all folders
- full hierarchy

No hidden structure from the agent.

---

## AGENT AWARENESS

The agent must:

- know full directory instantly
- read files directly
- write files directly

No discovery phase.

---

## NO SCAN MODEL

The agent must not:

- perform manual file scans
- infer structure

Structure is pre-bound.

---

## LOCAL + CLOUD MODEL

Workspace must support:

- local file system access
- cloud synchronization

Both must reflect identical structure.

---

## CONTEXT SOURCE

Workspace becomes:

- primary context source
- not chat history
- not temporary memory

---

## DOCUMENT AUTHORITY

All documents inside workspace:

- are live references
- must be used before generation

Agent must consult them first.

---

## GLOBAL DOCTRINE ACCESS

Global documents must:

- be placed in known locations
- be accessed before execution

They are mandatory reference points.

---

## MULTI-AGENT CONSISTENCY

All agents must:

- read same workspace
- use same doctrine
- produce consistent outputs

---

## SYSTEM INTEGRATION

Workspace must integrate with:

- agent engine
- runtime
- memory system
- profile system

---

## SOFTWARE RULE

Workspace is a core system layer.

Not optional.

---

## FAILURE CONDITION

Agent does not know file structure and relies on scanning or guessing.

---

## SUCCESS CONDITION

Agent operates with full awareness of all files and uses them as live context.

---

## Change Log

- 2026-04-28 — v2.0 Workspace model defined and hardened to introduce Obsidian-like architecture with direct agent file awareness and no-scan execution model. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Workspace system introduction.
- 2026-04-28 — v1.0 Initial document created.

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