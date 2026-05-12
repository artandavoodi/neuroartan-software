---
type: Change Log
subtype: Behavioral Changes
title: ICOS Behavioral Changes
status: Active
visibility: Internal
---

# ICOS Behavioral Changes

## 2026-05-09 — Theme and Intelligence Navigation Behavior

- Appearance settings now expose a custom hex color input path for native theme seed generation.
- `ThemeState` applies the active palette, contrast, mode, and custom seed into the global ICOS material system so new surfaces resolve through the same token owner.
- Intelligence routes now open real native module surfaces instead of remaining invisible backend-only migration work.
- The empty Developer Console now presents a native ICOS welcome surface aligned with the absorbed runtime identity.

Verification:

- Xcode Debug build succeeded after theme, navigation, asset, and script integration.

## 2026-05-07 — Mounted Runtime Response Guard

- Cloud/LM Studio mode now routes through the selected OpenAI-compatible endpoint/model instead of silently falling back to an unconfigured cloud model object.
- Prompt construction no longer ends with a response label that encouraged visible `ICOS:`, `Assistant:`, or `call:` output prefixes.
- Execution output is passed through the doctrine validator and a final label/control-token cleanup before it reaches the chat session.
- Console and inspector surfaces expose the active provider/model so the user can verify which runtime is answering.

Verification:

- Swift build succeeded after behavior changes.
- App launch succeeded after signing.

## 2026-05-09 — Boot Gate Stability Fix

- Removed theme-runtime identity remounting from the app root so changing appearance/settings no longer recreates the root SwiftUI tree or restarts the boot animation.
- Removed the Appearance panel identity reset so custom hex and palette changes update in place instead of tearing down the settings surface.
- Boot animation remains scoped to app launch through `ICOSBootGate`.

Verification:

- `xcodebuild -scheme ICOS -configuration Debug build ENABLE_APP_INTENTS_METADATA_GENERATION=NO`
- Debug app launch confirmed after the fix.
