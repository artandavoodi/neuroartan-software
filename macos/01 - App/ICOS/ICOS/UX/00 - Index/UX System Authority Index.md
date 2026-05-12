# UX System Authority Index

## Role
Single source of truth for UX ownership, boundaries, and system separation rules.

## System Ownership Rules

- UI Structure: /UX/
- Runtime UX Logic: /Doctrine/23 - Runtime UX/
- No duplication of UX logic across layers
- No overlapping ownership between UI and runtime behavior

## Separation Principle

- UX defines structure (layout, components, navigation)
- Runtime UX defines behavior (conversation flow, interaction logic)

## Conflict Rule

If duplication exists:
- Runtime UX overrides behavior definition
- UX system defines visual + structural layer only

## Status
Active UX governance layer established
