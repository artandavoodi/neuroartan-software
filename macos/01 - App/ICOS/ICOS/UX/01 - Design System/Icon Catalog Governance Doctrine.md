# Icon Catalog Governance Doctrine

## Purpose

This doctrine governs all icon usage across ICOS, the website platform, and related Neuroartan interface layers.

Icons are registered interface primitives. Every icon must be traceable, classified, theme-aware, and semantically matched to the function it represents.

## Canonical Source

The canonical SVG icon catalog lives in the website layer:

/Users/artan/Documents/Neuroartan/website/docs/assets/icons

The software layer must not store local SVG icon files.

ICOS resolves icons from the website SVG catalog through the design-system icon registry and rendering layer.

## Software Binding

The ICOS software icon system is bound through:

/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/DesignSystem/Icons/ICOSIcon.swift

/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/DesignSystem/Icons/SVGImageView.swift

/Users/artan/Neuroartan-software/macos/01 - App/ICOS/ICOS/DesignSystem/Icons/SVGKitRenderer.swift

## Mandatory Rules

### 0. Token-Bound Icon Usage Rule

Icons are part of the global design-token system.

Every icon surface must inherit sizing, opacity, padding, frame, foreground style, hover state, active state, and container radius from the correct token owner.

Feature files must not define local icon sizing or visual behavior when a token owner exists.

Common icon token owners include:

- `ICOSSidebarTokens`
- `ICOSControlTokens`
- `ICOSDeveloperComposerTokens`
- `ICOSDeveloperPanelTokens`
- `ICOSRuntimeShellTokens`
- `ICOSRuntimeDeveloperTokens`
- feature-specific token enums

### 1. No Hardcoding

Hardcoded icons are prohibited.

Agents must not use Image(systemName:) as a final implementation path.

Agents must not create local icon substitutes, fake icons, fallback visual symbols, or SF Symbol replacements.

### 2. Exact Match Rule

Every function, button, route, clickable, panel, state, connector, tool, tab, runtime surface, and feature must use an icon whose name directly matches its function.

Close-match selection is prohibited.

Examples:

configuration -> configuration.svg
developer -> developer.svg
response -> response.svg
voice -> voice.svg
workspace -> workspace.svg
fork -> fork.svg

A function named fork must use fork.svg, not workspace.svg, branch.svg, or another nearby concept.

### 3. Catalog-First Creation Rule

If an exact icon does not exist, the agent must first create an empty SVG file in the correct category inside the website icon catalog.

The file must use this minimal structure:

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"></svg>

The icon may remain visually empty until a vector is designed.

### 4. Classification Rule

No icon may live inside a folder named unclassified.

Every icon must be classified by functional ownership.

Core icons belong only to universal primitives shared across product layers.

Layer-specific icons must live in their owning layer, such as:

layers/website
layers/icos
layers/developer
layers/jobs
layers/office
layers/software
registry
system

### 5. Duplicate Rule

Duplicate SVG filename stems are prohibited.

There must never be two different files with the same final SVG name.

If two icons have related meaning but different ownership, the filename must include exact functional ownership.

Examples:

platform-menu-settings.svg
developer-settings.svg
navigation-drawer-settings.svg

### 6. Theme-Aware Rendering Rule

All interface SVG icons must remain theme-aware.

Software rendering must preserve template rendering through SVGImageView.

Icons must not be rendered as fixed-color assets unless the icon is a true brand, social, or payment asset requiring fixed color.

Icon foreground color must route through semantic system colors such as `ICOSColors`, `ICOSSidebarColors`, or other governed semantic owners.

Direct local color styling is prohibited unless the file is a token owner or platform bridge.

### 7. Registration Rule

All existing SVG icons in the canonical catalog must be registered through the ICOS icon system.

ICOSIcon maintains semantic enum paths for named software usage and dynamically registers the full website SVG catalog through catalog path introspection.

Agents must only link icons that exist in the catalog and resolve through the registered icon system.

### 8. Software Local SVG Rule

The ICOS software repository must contain zero local SVG icon files.

All SVG source assets must remain in the website icon catalog.

### 9. Agent Enforcement Rule

Before adding, changing, or linking any icon, agents must:

1. Scan the catalog.
2. Verify that the exact icon exists.
3. Confirm that the icon is classified.
4. Confirm that no duplicate filename stem exists.
5. Link through the canonical registered icon path.
6. Run verification after the change.
7. Verify that icon size, opacity, padding, and foreground styling are token-owned.
8. Verify that styled icon actions use governed primitives such as `ICOSButton` or a canonical component owner.

## Required Verification Commands

### Website duplicate check

cd "/Users/artan/Documents/Neuroartan/website" && python3 - <<'PY'
from pathlib import Path
from collections import defaultdict
root = Path("docs/assets/icons")
by = defaultdict(list)
for p in sorted(root.rglob("*.svg")):
    by[p.stem].append(str(p.relative_to(root)))
dups = {k:v for k,v in by.items() if len(v) > 1}
print("duplicates:", len(dups))
for k,v in dups.items():
    print(k)
    for x in v:
        print("  " + x)
PY

### Unclassified check

cd "/Users/artan/Documents/Neuroartan/website" && find docs/assets/icons -path "*unclassified*" -print

### Missing live website references

cd "/Users/artan/Documents/Neuroartan/website" && rg -n --no-messages 'assets/icons/[^"'"'"') ]+\.svg' docs/assets/fragments docs/assets/css docs/assets/js docs/collections docs/pages docs/index.html | python3 -c 'import sys,re; from pathlib import Path; root=Path("docs/assets/icons"); m=[]; [m.append((raw,line.strip())) for line in sys.stdin for raw in re.findall(r"assets/icons/([^\"'\'' )]+\.svg)", line) if not (root/raw).exists()]; print("missing:",len(m)); [print(raw,"=>",line) for raw,line in m]'

### Software local SVG check

find "/Users/artan/Neuroartan-software/macos/01 - App/ICOS" -type f -name "*.svg" | wc -l

### ICOS build check

cd "/Users/artan/Neuroartan-software/macos/01 - App/ICOS" && xcodebuild -scheme ICOS -configuration Debug build

### Tokenization scan

cd "/Users/artan/Neuroartan-software/macos/01 - App/ICOS" && rg -n --no-messages 'SVGImageView\(icon:|\.frame\(width: [0-9]|\.opacity\([0-9]\.|\.foregroundStyle\(Color\.|Image\(systemName:' ICOS | rg -v 'Preview|#Preview|MigrationArchives|Runtime/Source|ThirdParty|Documentation|Generated|SVGKitRenderer.swift|Developer/Diagnostics|ICOSIcon.swift|SVGImageView.swift'

## Completion Standard

An icon-related task is complete only when all of the following are true:

- Website duplicate icon stems: 0
- Unclassified icon files, folders, and references: 0
- Missing live website icon references: 0
- Software-local SVG files: 0
- Missing ICOS semantic registry paths: 0
- ICOS build succeeds
- Icon sizing, opacity, foreground styling, and interaction surfaces are token-owned
- Remaining icon scan hits are classified as accepted native/system, preview-only, or design-system-owner cases

## Status

Active and enforced across ICOS and the website platform.

This doctrine is now bound to the global ICOS design-token doctrine. Icon usage must remain catalog-first, exact-match, theme-aware, and token-owned.
