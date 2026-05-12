---
type: "UX Doctrine"
subtype: "Design System Core"

title: "ICOS UX Design System Core"

document_id: "UX-ICOS-CORE-2026-0202"

classification: "Internal"
authority_level: "Constitutional"

department: "UX"
office: "01 - Design System"

owner: "Founder / CEO (ARTAN)"

stakeholders:
  - "UX System"
  - "Layout Engine"
  - "Navigation System"
  - "Component System"
  - "Interaction Models"

status: "Active"
lifecycle: "Canonical"

created_date: "2026-05-01"
last_updated: "2026-05-01"

scope:
  - "Visual Language"
  - "Design Tokens"
  - "UI Consistency Rules"
  - "Cross-System Visual Governance"
  - "Icon Catalog Governance"
  - "Global Tokenization Doctrine"
  - "Runtime Surface Token Governance"
  - "Preview Frame Token Governance"

---

# ICOS UX Design System Core

## Purpose
Defines the unified visual language and design constraints across all ICOS user interfaces.

## Core Principle
All visual elements must derive from system tokens and must not define independent styling logic.

The design system is a constitutional owner of visual behavior across ICOS. Feature views, runtime shells, panels, composers, settings surfaces, previews, and layout primitives must not define local visual rules when a token owner exists.

## Design Structure

### 1. Visual Language Rules
- Consistency over variation
- Minimal surface noise
- Functional clarity over decoration

### 2. Token Dependency Rule
- All UI styling must reference Design Tokens
- No hardcoded styling permitted
- Runtime visual constants must be owned by named token groups
- Feature-specific visual values must be promoted into local or global token owners
- Preview frame dimensions must be tokenized when they represent reusable surfaces
- Design-system primitives may define tokens only when they are the canonical owner of the pattern

### 3. Hierarchy Model
- Visual hierarchy defines user attention flow
- Primary > Secondary > Tertiary structure enforced

### 4. Consistency Rule
- Same component must render identically across all screens
- No local overrides allowed

## System Binding
This system binds to:
- Layout Engine Core
- Component Registry
- Interaction Models
- Icon Catalog Registry
- Website SVG Icon Catalog
- ICOSIcon Semantic Registry
- SVGImageView Rendering Layer

## Global Tokenization Doctrine
ICOS now operates under a token-first visual architecture.

The macOS app completed a major global tokenization pass across the primary SwiftUI runtime surfaces. The current verified state is:

```text
Build status: BUILD SUCCEEDED
Tokenization status: 99.95%+
Enforcement model: root-tokenization only
Fix type: no overlay, no workaround, no local visual hacks
```

### 1. Token Ownership Rule
Every visible surface must inherit visual values from named token owners.

Required ownership categories include:
- `ICOSColors`
- `ICOSMaterials`
- `ICOSTypography`
- `ICOSSpacing`
- `ICOSRadius`
- `ICOSControlTokens`
- `ICOSControlStyleTokens`
- `ICOSSidebarTokens`
- `ICOSRuntimeShellTokens`
- `ICOSDeveloperPanelTokens`
- `ICOSDeveloperComposerTokens`
- `ICOSMessageTokens`
- `ICOSOverlayTokens`
- feature-specific token enums

### 2. Token-Bound Surfaces
The following ICOS surfaces are governed by the token system:
- global materials and color surfaces
- sidebar and rail systems
- runtime shells and runtime canvases
- developer console surfaces
- composer and input systems
- message bubbles and action rows
- settings panels
- file manager surfaces
- browser use surfaces
- project manager surfaces
- intelligence module surfaces
- overlay manager surfaces
- boot animation constants
- preview frame dimensions
- layout primitives
- panel and control primitives
- brand lockup surfaces
- window titlebar accessory surfaces

### 3. Runtime Surface Rule
Runtime shells, canvases, sidebars, inspectors, composers, overlays, previews, and panels must never introduce raw layout or styling values directly.

A visual value introduced in a runtime surface must either reference an existing token or establish a clearly named token owner.

### 4. Control Primitive Rule
Styled action surfaces must use governed primitives.

Required control ownership:
- buttons use `ICOSButton` or governed role primitives
- text inputs use `ICOSTextInput` where practical
- toggles use governed toggle rows where practical
- native `Picker`, `Slider`, and `ColorPicker` may remain when they provide platform behavior
- native `Menu` and `contextMenu` buttons may remain when they are platform command items

### 5. Preview Token Rule
Preview frames are part of the design system.

Reusable previews must use named preview tokens instead of unmanaged frame literals.

### 6. Accepted Native Exceptions
The following remaining scan hits are acceptable when used intentionally:
- native `Menu` and `contextMenu` command buttons
- native `ColorPicker`
- native `Picker`
- native `Slider`
- AppKit bridge code such as `NSColor.clear`, `NSColor.labelColor`, and titlebar/window chrome interop
- `Color.clear` for intentional transparent structure
- `spacing: 0` for intentional structural collapse
- token seed constructors inside token-owner files
- reusable design-system primitives defining the system itself

### 7. Verification Protocol
A tokenization change is complete only when:
1. the file is directly edited
2. token dependencies are added to the correct owner
3. `xcodebuild -scheme ICOS -configuration Debug build` succeeds
4. a scan confirms remaining hits are accepted native/system or design-system-owner cases

### 8. Forbidden Patterns
- local hardcoded font sizes in feature views
- local hardcoded frame dimensions in production UI
- local hardcoded opacity values in production UI
- local hardcoded corner radius values in production UI
- raw `Button` for styled action surfaces
- raw `TextField` or `SecureField` where a governed input primitive should be used
- decorative workaround layers
- overlay fixes that hide root-token problems
- page or feature-specific styling that fights global tokens

## Icon Catalog Governance Doctrine
All icons used anywhere in ICOS, the website platform, or related Neuroartan interface layers must derive from the canonical SVG icon catalog located in the website icon layer.

### 1. Canonical Icon Source
- The website SVG icon catalog is the sole source of truth for all interface icons.
- Software must not store local SVG icon files.
- ICOS must resolve icons from the website catalog through the registered icon system.
- All catalog paths must remain classified by functional domain, system layer, or product layer.

### 2. Registration Rule
- Every existing SVG icon in the catalog must be registered through the ICOS icon registry layer.
- ICOSIcon provides semantic enum mappings for named software usage.
- The full catalog is dynamically registered through catalog path introspection.
- Agents must only link icons that already exist in the catalog and resolve through the registry.

### 3. No Hardcoding Rule
- Hardcoded icons are prohibited.
- SF Symbols are prohibited as final implementation icons.
- Local placeholder icons are prohibited.
- Closest-match icon selection is prohibited.
- Icons must never be guessed from visual similarity.

### 4. Exact Function Match Rule
- Every function, route, button, clickable, panel, state, connector, and tool surface must use an icon whose name semantically matches the function it represents.
- If an exact icon does not exist, create an empty SVG file in the correct catalog category first.
- After creation, register or resolve the icon through the canonical icon registry before linking it in UI.
- Reusing a nearby icon is not permitted unless the icon is a truly shared universal primitive.

### 5. Classification Rule
- No icon may live inside a folder named `unclassified`.
- No duplicate SVG filename stems may exist in the catalog.
- Core icons are reserved for universal primitives shared across layers.
- Product-layer icons must live in their owning layer, such as website, ICOS, developer, jobs, office, software, or registry.
- Category folders must communicate functional ownership clearly.

### 6. Agent Enforcement Rule
- Agents must scan the catalog before introducing or linking an icon.
- Agents must verify that the target icon exists before referencing it.
- Agents must not create local software SVG files.
- Agents must not bypass SVGImageView, ICOSIcon, IconRegistry, or the registered catalog path system.
- Agents must run icon-governance verification after icon changes.

### 7. Verification Requirements
Before any icon-related change is complete, the following must be true:
- zero missing live website icon references
- zero unclassified icon paths
- zero duplicate icon filename stems
- zero software-local SVG files
- zero missing ICOS registry paths
- successful ICOS build

## Status
Active and enforced across UX architecture.

The global design-token doctrine is now canonical for ICOS visual implementation. All future UI work must be token-first, root-owned, build-verified, and scan-classified.