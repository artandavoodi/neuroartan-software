# ICOS Developer Console Architecture

## Purpose

The ICOS Developer Console is structured as a production-grade modular shell system.

The architecture follows the same orchestration philosophy used across the Neuroartan website platform:

```text
Fragments → Section Composers → Shell Importers → Runtime Orchestrator → App Mount
```

The goal is:

- clean ownership
- predictable rendering
- isolated responsibility
- scalable shell composition
- production-grade maintainability
- agent-readable architecture
- zero workaround layering
- zero duplicated ownership
- tokenized visual consistency

---

## Shell Architecture

### Root Runtime

```text
NavigationShell
    ↓
DeveloperConsoleShell
    ↓
DeveloperConsoleCenterCanvas
```

The shell layer is responsible only for:

- layout orchestration
- shell positioning
- panel visibility
- mounting subsystem fragments
- runtime routing

The shell layer must never own:

- local business logic
- duplicated styling
- embedded patch systems
- hardcoded layout values
- direct orchestration side effects

---

## Subsystems

### Composer System

```text
Shell/Composer/
```

#### Files

```text
DeveloperComposerShell.swift
DeveloperComposerToolbar.swift
DeveloperComposerInput.swift
```

#### Responsibility

The composer system owns:

- floating interaction shell
- action rail
- message input
- send actions
- voice interaction entry
- contextual interaction controls

The composer system must remain visually isolated from:

- shell orchestration
- runtime panels
- sidebar ownership
- terminal ownership

---

### Sidebar System

```text
Shell/Sidebar/
```

#### Responsibility

The sidebar system owns:

- workspace navigation
- search
- recent files
- mounted workspace state
- sidebar footer
- sidebar hierarchy
- collapsible navigation sections

The sidebar must remain structurally independent from:

- center canvas
- runtime inspector
- message composition

---

### Inspector System

```text
Shell/Inspector/
```

#### Responsibility

The inspector system owns:

- runtime state
- patch review
- terminal output
- runtime metrics
- orchestration visibility
- system diagnostics
- collapsible inspector behavior

Inspector ownership must remain isolated from:

- sidebar ownership
- composer ownership
- shell positioning logic

---

### Layout System

```text
Shell/Layout/
```

#### Responsibility

The layout system owns:

- center canvas orchestration
- shell spacing
- panel composition
- shell mounting
- responsive layout distribution
- shell rendering flow

The layout layer must never contain:

- runtime logic
- terminal logic
- patch logic
- interaction business logic

---

## Tokenization Rules

All production UI must use:

- ICOSTypography
- ICOSMaterials
- ICOSSidebarTokens
- ICOSShellTokens
- ICOSSpacing
- ICOSColors
- ICOSSidebarColors

Forbidden:

```text
.system fonts
hardcoded paddings
hardcoded colors
hardcoded corner radius
inline visual overrides
legacy Divider()-driven layout
```

---

## Structural Rules

### Mandatory Rules

- one owner per responsibility
- no duplicated shell ownership
- no workaround overlays
- no visual patch layering
- no temporary composition systems
- no giant mixed-owner files
- no embedded orchestration logic inside fragments
- no business logic inside visual layout fragments

---

## Section Formatting Standard

All Swift files must follow consistent structural formatting:

```swift
// MARK: - Section Name
```

Large decorative header comments are forbidden.

Sections must remain:

- minimal
- readable
- structurally predictable
- production-clean

---

## Production Direction

Target visual direction:

- premium dark shell
- Xcode-grade structural clarity
- ChatGPT/Codex-grade interaction flow
- floating composer architecture
- consistent spacing rhythm
- tokenized layout system
- modular fragment ownership
- clean inspector orchestration
- scalable subsystem composition

---

## Current Migration State

Current migration:

```text
Legacy mixed-owner shell
    ↓
Fragmented production architecture
```

Migration priorities:

1. decompose DeveloperConsoleView.swift
2. isolate subsystem ownership
3. remove legacy hardcoded UI
4. normalize token usage
5. establish shell orchestrator flow
6. stabilize runtime composition
7. finalize reference-grade shell visuals

---

## Architectural Principle

The ICOS shell is not a single screen.

It is a mounted runtime architecture.
