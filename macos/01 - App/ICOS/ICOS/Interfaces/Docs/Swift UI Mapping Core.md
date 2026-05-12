---
type: "UX Doctrine"
subtype: "Swift UI Bridge"

title: "ICOS UX Swift UI Mapping Core"

document_id: "UX-ICOS-CORE-2026-0211"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "11 - Swift UI Bridge"

owner: "Founder / CEO (ARTAN)"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "UX to SwiftUI Translation"
  - "Component Mapping Rules"
  - "Layout Engine Binding"
  - "Design System Integration"

---

## Purpose
Defines deterministic mapping between ICOS UX architecture and SwiftUI implementation layer.

---

## Core Principle
UX definitions are source-of-truth. SwiftUI is a rendering implementation layer only.

---

## Mapping Rules

### 1. One-Way Binding Rule
UX → SwiftUI only
No SwiftUI may redefine UX logic

### 2. Component Mapping Rule
Each UX component maps to a SwiftUI View
No duplicate view definitions allowed

### 3. Layout Mapping Rule
Layout Engine rules translate directly into SwiftUI stack/grid layouts

### 4. Token Mapping Rule
Design Tokens map to SwiftUI constants only
No hardcoded styling in Swift layer

---

## Architecture Bridge

UX Layer → SwiftUI Bridge → Swift Rendering Layer

- Design System → SwiftUI Theme
- Layout Engine → Stack/Grid Layouts
- Components → SwiftUI Views
- Fragments → SwiftUI Subviews

---

## Constraints
- No business logic in SwiftUI layer
- No deviation from UX definitions
- No independent styling system in Swift layer

---

## Status
Active and enforcing UX-to-code translation boundary