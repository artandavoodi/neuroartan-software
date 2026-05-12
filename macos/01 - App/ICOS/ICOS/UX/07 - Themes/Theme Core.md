---
type: "UX Doctrine"
subtype: "Theme Core"

title: "ICOS UX Theme Core"

document_id: "UX-ICOS-CORE-2026-0207"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "07 - Themes"

owner: "Founder / CEO (ARTAN)"

stakeholders:
  - "UX System"
  - "Design System Core"
  - "Layout Engine Core"
  - "Components Registry"
  - "Navigation Core"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "Visual Theme Governance"
  - "Color System Control"
  - "Mode Management"
  - "Cross-Screen Visual Consistency"

---

# ICOS UX Theme Core

## Purpose
Defines global visual theme behavior across all ICOS UX surfaces.

## Core Principle
Themes define system-wide visual states. No component may override theme rules.

## Theme Model

### 1. Global Theme Rule
- One active theme governs entire UX system
- No mixed theme states allowed

### 2. Color System Rule
- Colors must derive from Design Tokens
- No hardcoded colors permitted

### 3. Mode System Rule
- Supports Light / Dark / System modes
- Mode switching must be deterministic

### 4. Consistency Rule
- All screens must reflect active theme instantly

## Theme Categories
- Light Theme
- Dark Theme
- System Adaptive Theme

## System Binding
This system binds to:
- Design System Core
- Layout Engine Core
- Components Registry
- Screens Index

## Constraints
- No component-level theme overrides
- No local color definitions
- No per-screen theme divergence

## Status
Active and enforced across UX architecture layer