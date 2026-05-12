---
type: Model
subtype: Agent Native File Awareness

title: ICOS Agent Native File Awareness Model
document_id: SW-ICOS-MDL-2026-0020

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
  - "Agent Native File Awareness"
  - "Zero-Scan Context Model"
  - "Directory Graph Awareness"
  - "Live Document Referencing"
  - "Global Doctrine Binding"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/05 - Agent Native File Awareness Model/01 - Agent Native File Awareness Model.md"

related:
  - "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/01 - Workspace Model/01 - Workspace Model.md"
  - "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/02 - Directory Binding System/01 - Directory Binding System.md"
  - "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/03 - File Interaction Engine/01 - File Interaction Engine.md"
  - "software/macos/08 - Software Direction/01 - Directives/12 - Agent Build Engine Directives/07 - Agent Context Intake & Product Awareness Standard.md"

 tags:
  - "icos"
  - "agent"
  - "awareness"
  - "workspace"
  - "software-direction"
---

## PURPOSE

Define how the ICOS agent possesses immediate, native awareness of all files and structure within a bound workspace without scanning.

---

## CORE POSITION

Awareness is native.

Discovery is eliminated.

---

## AWARENESS MODEL

The agent maintains an in-memory directory graph representing:

- full folder hierarchy
- all file paths
- file metadata
- document relationships

Graph is synchronized with the workspace state.

---

## ZERO-SCAN RULE

The agent must not:

- scan directories
- search for files
- infer paths

All paths are resolved via the bound directory graph.

---

## DIRECTORY GRAPH

The system must maintain a live graph:

- nodes: folders, files
- edges: hierarchy, references
- attributes: path, type, timestamps, permissions

Graph updates on every file event.

---

## LIVE DOCUMENT REFERENCING

Before any generation, the agent must:

- resolve relevant files via graph
- read canonical sources (global doctrines first)
- bind outputs to those sources

No generation without document grounding.

---

## GLOBAL DOCTRINE PRIORITY

The agent must always read, in order:

1. Product Identity
2. Core Directives
3. System/Workspace Architecture
4. Target Local Documents

Higher-order doctrine overrides local content.

---

## PATH RESOLUTION

All file operations must use:

- absolute paths from graph
- validated existence

No constructed or guessed paths.

---

## EVENT SYNCHRONIZATION

On file events:

- create/update/delete detected
- graph updated atomically
- agent context refreshed

No stale awareness.

---

## CONTEXT CACHE

The agent may cache:

- frequently accessed documents
- parsed structures

Cache must invalidate on change.

---

## PERMISSION AWARENESS

The agent must respect:

- file-level permissions
- project scope
- protected doctrine files

Access checks precede read/write.

---

## MULTI-PROJECT ISOLATION

For multiple workspaces:

- maintain separate graphs
- prevent cross-project leakage

---

## FAILURE HANDLING

If graph inconsistency detected:

- halt execution
- rebuild graph from authoritative source
- log incident

---

## NO OVERLAY RULE

Awareness must reflect real state.

No shadow structures.

---

## SYSTEM INTEGRATION

Integrates with:

- Workspace Model
- Directory Binding System
- File Interaction Engine
- Runtime Governance Model

---

## FAILURE CONDITION

Agent relies on search/scan or operates on outdated structure.

---

## SUCCESS CONDITION

Agent operates with immediate, accurate awareness of all files and uses them as live context for all actions.

---

## Change Log

- 2026-04-28 — v2.0 Native file awareness model defined to eliminate scanning and enforce graph-based, live context execution. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Workspace architecture completion.
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