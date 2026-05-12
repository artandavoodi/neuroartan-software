# Source Absorption Ledger

Source root alias: `SOURCE_ROOT`
Target root alias: `ICOS_ROOT`
App root alias: `APP_ROOT`

This ledger records verified absorption from the temporary source architecture into native ICOS ownership. Source product identity names are intentionally not used in target symbols, folders, comments, or labels.

## Phase 1 Inventory

| Area | Source inventory | ICOS target owner | Status |
| --- | ---: | --- | --- |
| App entry / shell | 4 Swift files | `ICOS/SwiftUI/App`, `ICOS/System/Shell`, `ICOS/SwiftUI/Shell` | In progress |
| Window management | shell/app delegate code | `ICOS/SwiftUI/Window`, `ICOS/System/Shell` | Pending |
| Desktop/root views | 3 root/desktop Swift files | `ICOS/SwiftUI/Shell`, `ICOS/DeveloperConsole`, `ICOS/SwiftUI/Features/Intelligence` | In progress |
| Shared UI components | shared split/dropdown/UI files | `ICOS/DesignSystem/Components`, `ICOS/SwiftUI/Components`, `ICOS/SwiftUI/Layout` | In progress |
| Design system / tokens | 4 theme Swift files | `ICOS/DesignSystem/Tokens`, `ICOS/DesignSystem/Components`, `ICOS/DesignSystem/Controls` | In progress |
| Typography | 4 bundled DM Sans fonts | `ICOS/Resources/Fonts`, `ICOS/DesignSystem/Tokens` | Migrated |
| Colors/materials | warm palette, custom palette, and glass materials | `ICOS/DesignSystem/Tokens/ICOSMaterials.swift`, `ICOS/System/Theme/ThemeState.swift` | In progress |
| Motion / animation | motion constants and native SwiftUI boot animation | `ICOS/DesignSystem/Tokens`, `ICOS/SwiftUI/Boot` | Migrated |
| Sounds | launch sound asset | `ICOS/Resources/Sounds`, `ICOS/DesignSystem/Tokens` | Migrated |
| Terminal engine | terminal models/services/views and SwiftTerm vendor | `ICOS/System/Runtime/TerminalRuntime`, `ICOS/Runtime/Terminal` | Pending |
| Chat/session engine | session models/services/views | `ICOS/System/Runtime/SessionRuntime`, `ICOS/DeveloperConsole` | Pending |
| Agent execution engine | remote execution and installer services | `ICOS/System/Runtime/AgentRuntime` | Pending |
| Provider layer | provider catalog, credentials, validation, OAuth | `ICOS/System/Runtime/ProviderRuntime`, `ICOS/Providers` | Pending |
| File/workspace tools | file editor, workspace file models | `ICOS/System/Runtime/WorkspaceRuntime`, `ICOS/DeveloperConsole` | Pending |
| Knowledge base | models/service/view | `ICOS/System/Runtime/KnowledgeRuntime`, `ICOS/KnowledgeBase` | Pending |
| Kanban/project systems | kanban models/service/view | `ICOS/System/Runtime/OperationsRuntime` | Pending |
| Cron/jobs/automation | cron models/service/view | `ICOS/System/Runtime/AutomationRuntime` | Pending |
| OAuth/integrations | provider and external service OAuth | `ICOS/System/Integrations`, `ICOS/Providers` | Pending |
| Usage/analytics | usage models/service/view | `ICOS/System/Runtime/OperationsRuntime` | Pending |
| Python scripts | 1 icon script | `ICOS/System/Scripts/Python` | Migrated |
| Shell scripts | 3 build/test/release scripts | `ICOS/System/Scripts/Shell` | In progress |
| Tests | 22 Swift tests | `ICOSTests` | Pending |

## Verified File Migrations

| Source file path | Target ICOS file path | Migration status | Functions migrated | UI migrated | Animations migrated | Assets migrated | Build verified | Source-name removed | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `SOURCE_ROOT/Sources/App/Theme/FontRegistry.swift` | `ICOS_ROOT/DesignSystem/Tokens/ICOSFontRegistry.swift` | Migrated | Bundled font registration | n/a | n/a | DM Sans fonts | Yes | Yes | Converted to native ICOS naming and `Bundle.main` lookup. |
| `SOURCE_ROOT/Sources/App/Resources/Fonts/DMSans-ExtraLight.ttf` | `ICOS_ROOT/Resources/Fonts/DMSans-ExtraLight.ttf` | Migrated | n/a | n/a | n/a | Font copied | Yes | Yes | Runtime font registration owner is `ICOSFontRegistry`. |
| `SOURCE_ROOT/Sources/App/Resources/Fonts/DMSans-Light.ttf` | `ICOS_ROOT/Resources/Fonts/DMSans-Light.ttf` | Migrated | n/a | n/a | n/a | Font copied | Yes | Yes | Runtime font registration owner is `ICOSFontRegistry`. |
| `SOURCE_ROOT/Sources/App/Resources/Fonts/DMSans-Regular.ttf` | `ICOS_ROOT/Resources/Fonts/DMSans-Regular.ttf` | Migrated | n/a | n/a | n/a | Font copied | Yes | Yes | Runtime font registration owner is `ICOSFontRegistry`. |
| `SOURCE_ROOT/Sources/App/Resources/Fonts/DMSans-Medium.ttf` | `ICOS_ROOT/Resources/Fonts/DMSans-Medium.ttf` | Migrated | n/a | n/a | n/a | Font copied | Yes | Yes | Runtime font registration owner is `ICOSFontRegistry`. |
| `SOURCE_ROOT/Sources/App/Resources/Boot/init_sound.mp3` | `ICOS_ROOT/Resources/Sounds/IntelligenceRuntimeLaunch.mp3` | Migrated | n/a | n/a | n/a | Sound copied | Yes | Yes | Tokenized through `ICOSSoundTokens`. |
| `SOURCE_ROOT/Sources/App/Theme/Theme.swift` | `ICOS_ROOT/DesignSystem/Tokens/ICOSMotion.swift` | Partially migrated | Motion constants | n/a | Motion timing | n/a | Yes | Yes | Material palette values are integrated in `ICOSMaterials.swift`. |
| `SOURCE_ROOT/Sources/App/Models/ProviderCatalog.swift` and provider service family | `ICOS_ROOT/System/Runtime/ProviderRuntime/ConnectorRuntimeModels.swift` | Foundation migrated | Connector configuration model | Settings category | n/a | n/a | Yes | Yes | Native connector kinds now cover GitHub, Email, Google, local filesystem, VS Code, terminal, LM Studio, OpenRouter, Hugging Face, and future registry. |
| `SOURCE_ROOT/Sources/App/Services/Providers/*` and integration stores | `ICOS_ROOT/System/Runtime/ProviderRuntime/ConnectorRegistryService.swift` | Foundation migrated | Persistent connector registry, test actions, status/log tracking | Settings category | n/a | n/a | Yes | Yes | Credentials are stored through `SecureCredentialStore`; provider-specific OAuth exchange is not complete yet. |
| `SOURCE_ROOT/Sources/App/Services/Storage/AppPaths.swift` credential-adjacent behavior | `ICOS_ROOT/System/Services/SecureCredentialStore.swift` | Migrated | Keychain save/load/delete | n/a | n/a | n/a | Yes | Yes | Native ICOS secure credential owner for connector secrets. |
| Source agent/session/provider concepts | `ICOS_ROOT/System/Runtime/AgentRuntime/AgentRuntimeModels.swift` | Foundation migrated | Agent profiles, task states, tool permissions, repository awareness map | Developer Console controls | n/a | n/a | Yes | Yes | Enables native task queue and repository map state; live LLM execution loop remains pending. |
| Source session/agent orchestration concepts | `ICOS_ROOT/System/Runtime/AgentRuntime/AgentRuntimeService.swift` | Foundation migrated | Default agents, task queue, Neuroartan root indexing, repository metrics | Developer Console controls | n/a | n/a | Yes | Yes | Repository-aware self-development task can be queued; autonomous patch/build loop remains pending. |
| `SOURCE_ROOT/Sources/App/Views/Boot/*` and `SOURCE_ROOT/Sources/App/Resources/Boot/*` | `ICOS_ROOT/SwiftUI/Boot/ICOSBootGate.swift`, `ICOS_ROOT/SwiftUI/Boot/ICOSBootAnimationView.swift`, `ICOS_ROOT/Resources/Sounds/IntelligenceRuntimeLaunch.mp3` | Migrated | Preview-safe boot gate and native SwiftUI boot completion flow | Native theme-aware SwiftUI boot screen | Native SwiftUI boot motion | Legacy WebKit boot resources removed; launch sound retained under Sounds | Yes | Yes | WebKit boot view, custom URL scheme handler, and legacy Boot HTML/CSS/JS resources removed from active runtime and disk. |
| `SOURCE_ROOT/Sources/App/Views/Shared/UI.swift` and shared control concepts | `ICOS_ROOT/DesignSystem/Components/ICOSPanel.swift`, `ICOS_ROOT/DesignSystem/Controls/ICOSControlStyles.swift`, `ICOS_ROOT/DesignSystem/Controls/ICOSTextInput.swift` | Migrated | Panel, inset surface, loading, validation, button, icon button, glass, and text input primitives | Native shared components | Press/hover motion | n/a | Yes | Yes | Rewritten as tokenized ICOS components without source namespaces. |
| `SOURCE_ROOT/Sources/App/Theme/Tokens.swift` and theme concepts | `ICOS_ROOT/DesignSystem/Tokens/ICOSThemeColorSeed.swift`, `ICOS_ROOT/DesignSystem/Tokens/ICOSMaterials.swift`, `ICOS_ROOT/System/Theme/ThemeState.swift`, `ICOS_ROOT/SwiftUI/Settings/Panels/AppearanceSettingsPanel.swift` | In progress | Custom hex seed parsing, palette generation, runtime material application | Appearance settings color preview | Theme transitions | n/a | Yes | Yes | Adds custom theme seed path and keeps `ThemeState` as runtime theme owner. |
| `SOURCE_ROOT/assets/files.png` | `ICOS_ROOT/Resources/Assets/Intelligence/workspace-files.png` | Migrated | n/a | Intelligence module preview | n/a | Screenshot copied | Yes | Yes | Renamed to ICOS-native workspace asset. |
| `SOURCE_ROOT/assets/kanban.png` | `ICOS_ROOT/Resources/Assets/Intelligence/operations-board.png` | Migrated | n/a | Intelligence module preview | n/a | Screenshot copied | Yes | Yes | Renamed to ICOS-native operations asset. |
| `SOURCE_ROOT/assets/sessions.png` | `ICOS_ROOT/Resources/Assets/Intelligence/session-runtime.png` | Migrated | n/a | Intelligence module preview | n/a | Screenshot copied | Yes | Yes | Renamed to ICOS-native session asset. |
| `SOURCE_ROOT/assets/terminal.png` | `ICOS_ROOT/Resources/Assets/Intelligence/terminal-runtime.png` | Migrated | n/a | Intelligence module preview | n/a | Screenshot copied | Yes | Yes | Renamed to ICOS-native terminal asset. |
| `SOURCE_ROOT/assets/USAGE.png` | `ICOS_ROOT/Resources/Assets/Intelligence/usage-analytics.png` | Migrated | n/a | Intelligence module preview | n/a | Screenshot copied | Yes | Yes | Renamed to ICOS-native usage asset. |
| Source feature navigation and desktop module concepts | `ICOS_ROOT/SwiftUI/Features/Intelligence/IntelligenceModuleCatalog.swift`, `ICOS_ROOT/SwiftUI/Features/Intelligence/IntelligenceModuleView.swift`, `ICOS_ROOT/SwiftUI/Navigation/AppRouter.swift`, `ICOS_ROOT/SwiftUI/Shell/ShellState.swift` | Foundation migrated | Native route catalog for sessions, providers, connections, terminal, knowledge, kanban, automation, usage, mail, messaging, skills, diagnostics, voice, and desktop runtime | Visible Intelligence section in app shell | Tokenized card transitions | Intelligence screenshot assets | Yes | Yes | Donor capabilities are now grouped under a native ICOS Intelligence category for visible navigation. |
| `SOURCE_ROOT/scripts/build-app-icon.py` | `ICOS_ROOT/System/Scripts/Python/build_icos_app_icon.py` | Migrated | Icon generation pipeline | n/a | n/a | n/a | Yes | Yes | Rewritten as ICOS-native script requiring explicit source/output paths. |
| Source build/test/launch script patterns | `ICOS_ROOT/System/Scripts/Shell/build_icos_debug.sh`, `ICOS_ROOT/System/Scripts/Shell/run_icos_tests.sh`, `ICOS_ROOT/System/Scripts/Shell/launch_icos_debug.sh` | Foundation migrated | Xcode build, test, and launch entrypoints | n/a | n/a | n/a | Yes | Yes | Native scripts point at the ICOS Xcode project and no longer use donor SwiftPM app packaging. |

## Source Folder Drain

| Date | Action | Result |
| --- | --- | --- |
| 2026-05-09 | Removed generated donor build/cache artifacts and active ICOS generated audit/quarantine debris. | ICOS build remained successful; active ICOS source-name scan remained clean outside this ledger. |
| 2026-05-09 | Removed donor source copies of verified migrated boot resources, fonts, visual screenshots, boot Swift views, and the migrated icon-generation script. | Temporary source folder drained to 0 files after remaining artifacts were moved into `APP_ROOT/MigrationArchives/AbsorbedSource` as sanitized, non-compiling absorption records. Active runtime wiring still requires progressive native promotion from archive records into canonical ICOS owners. |
