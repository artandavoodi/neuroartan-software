---
type: Architecture
subtype: Directory Binding System

title: ICOS Directory Binding System
document_id: SW-ICOS-ARC-2026-0017

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
  - "Directory Binding"
  - "Workspace Project Registration"
  - "Agent Structural Awareness"
  - "Path Authority Model"
  - "No-Scan Execution Model"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/02 - Directory Binding System/01 - Directory Binding System.md"

related:
  - "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/01 - Workspace Model/01 - Workspace Model.md"
  - "software/macos/08 - Software Direction/01 - Directives/12 - Agent Build Engine Directives/07 - Agent Context Intake & Product Awareness Standard.md"

 tags:
  - "icos"
  - "directory"
  - "binding"
  - "workspace"
  - "software-direction"
---

## PURPOSE

Define how directories are bound to ICOS workspace so the agent has immediate, authoritative awareness of all files and structure.

---

## CORE POSITION

Directories are registered, not discovered.

The agent must operate on known structure, not inferred structure.

---

## DIRECTORY BINDING DEFINITION

Directory binding is the process of attaching a filesystem root to an ICOS workspace project.

Binding must:

- register full path
- expose full hierarchy
- grant agent awareness

---

## PROJECT REGISTRATION

When a project is created:

- a root directory is assigned
- directory is registered in system
- all nested files become visible

Project = bound directory.

---

## STRUCTURAL AWARENESS

After binding, the agent must:

- know full directory tree
- know all file paths
- access any file directly

No scanning required.

---

## PATH AUTHORITY

The bound directory becomes:

- the single source of path truth
- authoritative for all file operations

No guessed or constructed paths.

---

## NO SCAN RULE

The agent must not:

- run directory scans
- search blindly
- infer structure

All structure is pre-known through binding.

---

## FILE ACCESS MODEL

Agent must:

- read files directly
- write files directly
- update files deterministically

All operations must reference bound paths.

---

## MULTI-DIRECTORY SUPPORT

System must support:

- multiple projects
- multiple bound directories
- isolation between projects

---

## DIRECTORY STATE MANAGEMENT

System must maintain:

- directory path
- structure snapshot
- update events

State must remain consistent.

---

## CHANGE DETECTION

System must detect:

- file creation
- file modification
- file deletion

Agent awareness must update automatically.

---

## LOCAL + CLOUD CONSISTENCY

Directory binding must work for:

- local filesystem
- cloud-synced filesystem

Structure must remain identical across both.

---

## GLOBAL DOCTRINE BINDING

Global documents must be:

- located in known paths
- always accessible
- always referenced before execution

---

## SYSTEM INTEGRATION

Directory binding must integrate with:

- workspace model
- agent engine
- runtime
- memory system

---

## SOFTWARE RULE

Directory binding is a core system capability.

No fallback to scan-based discovery.

---

## FAILURE CONDITION

Agent attempts to discover files instead of using bound directory.

---

## SUCCESS CONDITION

Agent operates with full, immediate awareness of all files via bound directories.

---

## Change Log

- 2026-04-28 — v2.0 Directory binding system defined and hardened to eliminate scanning and enforce direct structural awareness. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Workspace architecture expansion.
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