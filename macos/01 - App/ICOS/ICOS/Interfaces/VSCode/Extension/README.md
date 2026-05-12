# ICOS Editor Bridge

This VS Code extension publishes the active local file and workspace root into the ICOS editor bridge inbox:

`~/Library/Application Support/ICOS/editor_bridge/active-editor-state.json`

The native ICOS app reads this file through `ExternalEditorBridge` and can sync the active VS Code file into the developer workspace.

## Local Install

From this directory:

```sh
code --install-extension .
```

Then run `ICOS: Publish Active File` from the VS Code command palette, or switch/save files to publish automatically.

# ICOS Editor Bridge

The ICOS Editor Bridge is the VS Code extension layer that publishes the active local editor state into the native ICOS macOS runtime.

It writes the active file and workspace root to:

```text
~/Library/Application Support/ICOS/editor_bridge/active-editor-state.json
```

The native ICOS app reads this file through `ExternalEditorBridge` and can synchronize the active VS Code file into the Developer Workspace.

---

## Purpose

This extension exists to connect local development context to ICOS without turning VS Code into the governing runtime.

VS Code remains an editor.

ICOS remains the sovereign cognitive operating system and orchestration layer.

---

## Local Install

From this directory:

```sh
code --install-extension .
```

Then run:

```text
ICOS: Publish Active File
```

from the VS Code command palette, or switch/save files to publish automatically.

---

## Runtime Boundary

The bridge may publish:

- active workspace root
- active file path
- editor state metadata
- local development context

The bridge must not own:

- ICOS runtime state
- ICOS design tokens
- ICOS doctrine enforcement
- ICOS memory continuity
- ICOS governance logic
- ICOS provider arbitration

---

## Design-System Boundary

The VS Code extension is an interface bridge only.

It must not introduce ICOS visual doctrine, token ownership, runtime shell styling, or SwiftUI component styling.

Global ICOS visual doctrine is owned by:

```text
ICOS/UX/01 - Design System/Design Tokens.md
```

and enforced through the native macOS app design system.

---

## Tokenization Milestone Reference

The native ICOS macOS app has completed a major global tokenization pass across primary SwiftUI runtime surfaces.

Current verified state:

```text
Build status: BUILD SUCCEEDED
Tokenization status: 99.95%+
Enforcement model: root-tokenization only
Fix type: no overlay, no workaround, no local visual hacks
```

This bridge must preserve that boundary by avoiding local UI rules that imply ownership over ICOS-native visual surfaces.

---

## Development Rule

When extending this extension:

1. keep editor bridge logic minimal
2. preserve local-only context publication
3. do not duplicate ICOS runtime state
4. do not duplicate ICOS token doctrine
5. do not create overlay workflows
6. verify native ICOS build after bridge-impacting changes

---

## Verification

Native ICOS build check:

```sh
cd "/Users/artan/Neuroartan-software/macos/01 - App/ICOS" && xcodebuild -scheme ICOS -configuration Debug build
```

Editor bridge publication path check:

```sh
cat "$HOME/Library/Application Support/ICOS/editor_bridge/active-editor-state.json"
```