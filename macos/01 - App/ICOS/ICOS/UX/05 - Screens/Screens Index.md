---
type: "UX Doctrine"
subtype: "Screens Index"

title: "ICOS UX Screens Index"

document_id: "UX-ICOS-CORE-2026-0205"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "05 - Screens"

owner: "Founder / CEO (ARTAN)"

stakeholders:
  - "UX System"
  - "Navigation Core"
  - "Layout Engine Core"
  - "Components Registry"
  - "Interaction Models"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "Screen Registry"
  - "UI Surface Definition"
  - "Application View Mapping"
  - "User Entry Points"

---

# ICOS UX Screens Index

## Purpose
Defines all UI screens in ICOS and establishes their structural and navigational mapping.

## Core Principle
Every screen must be registered, deterministic, and governed by the Navigation System.

## Screen Model

### 1. Screen Registry Rule
- Every screen must be declared in this index
- No unregistered screens allowed

### 2. Entry Point Rule
- All user entry points must map to a defined screen
- No hidden or implicit entry points

### 3. State Rule
- Screens must maintain deterministic state behavior
- No conflicting screen states allowed

### 4. Composition Rule
- Screens are composed of fragments and components only
- No direct logic embedded in screen layer

## Screen Categories
- Primary Screens
- Secondary Screens
- Modal Screens
- System Screens

## System Binding
This system binds to:
- Navigation Core
- Layout Engine Core
- Components Registry
- Interaction Models

## Constraints
- No screen bypass permitted
- No dynamic screen creation without registry update

## Status
Active and enforced across UX architecture layer

---
