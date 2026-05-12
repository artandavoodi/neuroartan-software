---
type: "UX Doctrine"
subtype: "Fragments Registry"

title: "ICOS UX Fragments Registry"

document_id: "UX-ICOS-CORE-2026-0206"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "06 - Fragments"

owner: "Founder / CEO (ARTAN)"

stakeholders:
  - "UX System"
  - "Layout Engine Core"
  - "Components Registry"
  - "Screens Index"
  - "Navigation Core"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "Reusable UI Fragments"
  - "Composition Units"
  - "Structural UI Building Blocks"
  - "Cross-Screen Reusability"

---

# ICOS UX Fragments Registry

## Purpose
Defines reusable UI fragments used to compose screens and components across ICOS UX.

## Core Principle
Fragments are atomic structural UI units. They must not contain business logic or navigation logic.

## Fragment Rules

### 1. Atomicity Rule
- Each fragment represents a single UI purpose
- No multi-purpose fragments allowed

### 2. Reusability Rule
- Fragments must be reusable across all screens
- No screen-specific fragments allowed

### 3. Composition Rule
- Fragments compose into components and screens
- Must follow Layout Engine rules

### 4. Stateless Rule
- Fragments must not hold persistent state logic

## Fragment Types
- Header Fragments
- Content Fragments
- Footer Fragments
- Modal Fragments
- Utility Fragments

## System Binding
This registry binds to:
- Components Registry
- Screens Index
- Layout Engine Core
- Navigation Core

## Constraints
- No fragment may define navigation
- No fragment may override layout system
- No fragment may contain embedded logic beyond presentation

## Status
Active and enforced across UX architecture layer

---
