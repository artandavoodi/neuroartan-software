# Design Tokens

## Purpose
Single source of truth for all visual primitives in ICOS UX.

## Color System
- Primary: undefined
- Background: system neutral
- Text: hierarchical contrast system

## Typography
- System font baseline
- H1 / H2 / Body / Caption scale

## Spacing
- 4px base grid
- consistent modular rhythm

## Radius
- minimal rounding system

## Elevation
- flat UI principle
- minimal shadow usage

## Rule
Tokens must never be overridden directly by components.

# Design Tokens

## Purpose
Single source of truth for all visual primitives in ICOS UX.

The token system exists to prevent local styling drift across the ICOS macOS application. Every visible surface must inherit its spacing, radius, typography, opacity, sizing, material, control, shell, runtime, panel, preview, and interaction values from named token owners.

## Current Status
- Status: active global standard
- Implementation state: substantially complete
- Latest verification: Xcode build succeeded after global tokenization pass
- Completion estimate: 99.95%+
- Enforcement model: root-tokenization only

## Tokenization Milestone
The ICOS macOS application has completed a global tokenization pass across the primary SwiftUI runtime surfaces.

The following areas are now token-bound:
- Global materials and color surfaces
- Sidebar and rail systems
- Runtime shells and runtime canvases
- Developer console surfaces
- Composer and input systems
- Message bubbles and action rows
- Settings panels
- File manager surfaces
- Browser use surfaces
- Project manager surfaces
- Intelligence module surfaces
- Overlay manager surfaces
- Boot animation constants
- Preview frame dimensions
- Layout primitives
- Panel and control primitives
- Brand lockup surfaces
- Window titlebar accessory surfaces

## Color System
- Primary: owned through `ICOSColors`
- Background: owned through `ICOSMaterials`
- Text: hierarchical contrast system through `ICOSColors.textPrimary`, `ICOSColors.textSecondary`, and related semantic values
- Destructive, warning, success, online, passive, and active states must use semantic tokens
- Raw color construction is allowed only inside token seed owners or platform bridge code

## Typography
- Typography must be routed through `ICOSTypography` or named component tokens
- Raw font sizes must not be declared directly inside feature views
- Feature-specific font values must be promoted into named token enums
- Preview typography must also use token values where visible

## Spacing
- Global spacing is owned by `ICOSSpacing`
- Component spacing must use shared spacing tokens or local named token owners
- Structural `spacing: 0` is allowed only for intentional zero-gap containers
- Local spacing literals are not allowed inside production surfaces

## Radius
- Global radius is owned by `ICOSRadius`
- Component radius must use global radius tokens, control tokens, sidebar tokens, panel tokens, or named component tokens
- Radius values must not be redefined inside views unless they are local private token constants

## Elevation
- ICOS follows a flat, minimal surface model
- Shadow usage must remain rare and tokenized
- Surface distinction should prefer materials, stroke, opacity, and hierarchy over decorative depth

## Control System
- Buttons must use `ICOSButton`, `ICOSButtonRole`, or governed button primitives
- Text inputs must use `ICOSTextInput` where practical
- Toggles must use governed toggle primitives where practical
- Sliders, pickers, and color pickers may remain native when they are system controls that provide platform behavior
- Native `Menu` and `contextMenu` command buttons may remain native when they are platform menu commands

## Runtime Surface Rule
Runtime shells, canvases, sidebars, inspectors, composers, overlays, previews, and panels must never introduce raw layout or styling values directly.

All runtime visual constants must be owned by named token groups such as:
- `ICOSRuntimeShellTokens`
- `ICOSRuntimeDeveloperTokens`
- `ICOSDeveloperPanelTokens`
- `ICOSDeveloperComposerTokens`
- `ICOSSidebarTokens`
- `ICOSControlTokens`
- `ICOSControlStyleTokens`
- `ICOSMessageTokens`
- `ICOSOverlayTokens`
- feature-specific token enums

## Preview Token Rule
Preview frames are part of the design system.

Preview dimensions must use named tokens when they represent reusable surfaces, runtime shells, panels, layout examples, or feature previews.

## Native Exception Rule
The following remaining scan hits are acceptable when used for their correct platform role:
- Native `Menu` and `contextMenu` command buttons
- Native `ColorPicker`
- Native `Picker`
- Native `Slider`
- AppKit bridge code such as `NSColor.clear`, `NSColor.labelColor`, and titlebar/window chrome interop
- `Color.clear` when used as intentional transparent structure
- `spacing: 0` when used as intentional structural collapse
- Token seed constructors inside token-owner files
- Reusable design-system primitives that intentionally define the system itself

## Enforcement Doctrine
Tokens must never be overridden directly by feature components.

If a visual value appears inside a feature file, the correction path is:
1. Identify the true owner.
2. Promote the value into the correct token owner.
3. Replace the local literal with the token reference.
4. Build immediately.
5. Run a targeted scan.
6. Classify remaining hits as unresolved or acceptable-native.

## Forbidden Patterns
- Local hardcoded font sizes in feature views
- Local hardcoded frame dimensions in production UI
- Local hardcoded opacity values in production UI
- Local hardcoded corner radius values in production UI
- Raw `Button` for styled action surfaces
- Raw `TextField` or `SecureField` where a governed input primitive should be used
- Decorative workaround layers
- Overlay fixes that hide root-token problems
- Page or feature-specific styling that fights global tokens

## Verification Protocol
A tokenization change is complete only when:
- The file is directly edited.
- Token dependencies are added to the correct owner.
- `xcodebuild -scheme ICOS -configuration Debug build` succeeds.
- The scan shows only accepted native/system or design-system-owner hits.

## Canonical Scan
Use this scan to detect remaining raw visual values:

```bash
cd "/Users/artan/Neuroartan-software/macos/01 - App/ICOS" && \
rg -n --no-messages \
'Color\.(black|white|red|green|blue|gray|clear)\.opacity|Color\(red:|NSColor\.|\.font\(\.system\(size: [0-9]|\.frame\(width: [0-9]|\.frame\(height: [0-9]|\.padding\([0-9]|\.padding\(\.[a-z]+, [0-9]|spacing: [0-9]|cornerRadius: [0-9]|lineWidth: [0-9]|\.opacity\([0-9]\.|\.shadow\(|TextField\(|SecureField\(|Picker\(|Toggle\(|Slider\(|Button\(|ColorPicker\(' \
ICOS | \
rg -v 'Preview|#Preview|MigrationArchives|Runtime/Source|ThirdParty|Documentation|Generated|SVGKitRenderer.swift|ICOSBootAnimationView.swift|ICOSMaterials.swift|ICOSColors.swift|Developer/Diagnostics|Menu|contextMenu|NSColor.clear|NSColor.labelColor|Color.clear|spacing: 0|\.frame\(maxWidth: \.infinity|\.frame\(maxHeight: \.infinity' | head -900
```

## Rule
Tokens must never be overridden directly by components.

All future ICOS visual work must be token-first, root-owned, build-verified, and scan-classified.