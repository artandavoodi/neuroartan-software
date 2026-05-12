---
type: "UX Doctrine"
subtype: "Fragment System Core"

title: "ICOS UX Fragment System Core"

document_id: "UX-ICOS-CORE-2026-0206"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "06 - Fragments"

owner: "Founder / CEO (ARTAN)"

stakeholders:
  - "UX System"
  - "Components Registry"
  - "Screens Index"
  - "Layout Engine Core"
  - "Interaction Models"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "UI Fragment Architecture"
  - "Reusable UI Units"
  - "Structural Composition Rules"
  - "Cross-Screen Reusability"

---

# ICOS UX Fragment System Core

## Purpose
Defines atomic UI fragments used to compose screens and components across ICOS UX.

---

## Core Principle
Fragments are stateless, reusable UI primitives. They cannot define behavior, layout authority, or navigation logic.

---

## Fragment Rules

### 1. Atomicity Rule
Each fragment represents a single UI responsibility.
No multi-purpose fragments allowed.

### 2. Reusability Rule
Fragments must be reusable across all screens and components.
No screen-specific fragment definitions allowed.

### 3. Stateless Rule
Fragments cannot maintain internal application state or logic.

### 4. Composition Rule
Fragments can only be composed by Components and Screens.

---

## Fragment Types
- Header Fragments
- Content Fragments
- Footer Fragments
- Modal Fragments
- Utility Fragments

---

## System Binding
This module binds to:
- Components Registry
- Screens Index
- Layout Engine Core
- Interaction Model Core

---

## Constraints
- No fragment may override layout rules
- No fragment may define navigation behavior
- No fragment may bypass rendering pipeline

---

## Status
Active and enforced within UX architecture layer