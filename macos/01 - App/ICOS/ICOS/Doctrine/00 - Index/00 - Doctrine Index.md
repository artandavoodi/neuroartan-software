---
type: "Index"
subtype: "Doctrine Index"

title: "ICOS Doctrine Index"
document_id: "INF-SOFT-ICOS-IDX-2026-0001"

classification: "Internal"
authority_level: "Executive"
department: "04 - Infrastructure"
office: "06 - Platform Infrastructure / Software Layer / ICOS Doctrine"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Governance Synchronization Authority (GSA)"
  - "All ICOS Agents"
  - "Software Applications Development Agent (SADA)"

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
  - "ICOS Doctrine Registry"
  - "Doctrine Discovery"
  - "Agent Runtime Awareness"

index_targets:
  - "Software Doctrine Index"

vault_path: "macos/01 - App/ICOS/ICOS/Doctrine/00 - Index/00 - Doctrine Index.md"

related:
  - "macos/01 - App/ICOS/ICOS/Doctrine/00 - Index/01 - Doctrine Loading Order.md"

tags:
  - "icos"
  - "doctrine"
  - "index"
---

# ICOS Doctrine Index

## Purpose

Central index of all ICOS doctrines. Enables deterministic discovery and execution alignment for agents.

---

## Doctrine Registry

```dataview
TABLE WITHOUT ID
  file.link AS "Doctrine",
  file.folder AS "Folder"
FROM "macos/01 - App/ICOS/ICOS/Doctrine"
WHERE contains(file.name, ".md") AND !contains(file.path, "00 - Index")
SORT file.name ASC
```

---

## Change Log

- 2026-04-30 — Initial canonical doctrine index created and bound to global metadata standard.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Approved
GSA APPROVAL: true
DOCUMENT STATUS: Active — Index
VISIBILITY: Internal
PUBLISH TO WEBSITE: No
VERSION: 1.0

---

END OF DOCUMENT