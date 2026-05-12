---
type: Change Log
subtype: Structural Changes
title: ICOS Structural Changes
status: Active
visibility: Internal
---

# ICOS Structural Changes

## 2026-05-09 — Source Absorption and Intelligence Surface Integration

- Added a native ICOS source absorption ledger at `macos/01 - App/ICOS/ICOS/System/Migration/SourceAbsorptionLedger.md`.
- Added native ICOS boot resources, boot gate, launch sound ownership, DM Sans font registration, shared panel/control primitives, and custom theme seed infrastructure.
- Added an Intelligence navigation category for absorbed runtime surfaces: sessions, providers, connections, terminal, knowledge, kanban, automation, usage, mail, messaging, skills, diagnostics, voice, and desktop runtime.
- Migrated source visual screenshots into `ICOS/Resources/Assets/Intelligence` with ICOS-native names and wired them into the Intelligence module cards/details.
- Added native ICOS script owners under `ICOS/System/Scripts` for build, test, launch, and app-icon generation.
- Removed stale generated audit/quarantine debris from active ICOS ownership and removed donor build caches from the temporary source folder.

Verification:

- `xcodebuild -scheme ICOS -configuration Debug build ENABLE_APP_INTENTS_METADATA_GENERATION=NO`
- Active ICOS source-name scan for temporary source identity terms returned no active matches outside the migration ledger.

## 2026-05-07 — Runtime Model Selection Stabilization

- Added LM Studio/OpenAI-compatible model discovery state to the ICOS runtime settings owner.
- Added active provider/model/endpoint telemetry to the runtime settings state so chat and inspector surfaces report the mounted runtime.
- Added new-chat lifecycle through `SessionStore` and `ICOSAppState` instead of a second chat controller.
- Preserved the single execution route through `ICOSExecutionController -> ExecutionRouter -> ProviderRouter`.

Verification:

- `xcodebuild -project "macos/01 - App/ICOS/ICOS.xcodeproj" -scheme ICOS -configuration Debug -destination 'platform=macOS' build`
- `codesign --verify --deep --strict --verbose=4 ".../ICOS.app"`
- Debug app launch confirmed by running `ICOS` process.

## 2026-05-09 — Temporary Source Folder Drain

- Drained `/Users/artan/Neuroartan-software/hermes-desktop-os1-main` to zero files.
- Moved remaining sanitized source records into `macos/01 - App/ICOS/MigrationArchives/AbsorbedSource` outside the compiled ICOS source tree so they cannot create duplicate runtime ownership or duplicate app resources.
- Preserved the active native ICOS owners inside `macos/01 - App/ICOS/ICOS` and kept the app target build-clean.

Verification:

- Temporary source folder file count: `0`.
- `xcodebuild -scheme ICOS -configuration Debug build ENABLE_APP_INTENTS_METADATA_GENERATION=NO`
