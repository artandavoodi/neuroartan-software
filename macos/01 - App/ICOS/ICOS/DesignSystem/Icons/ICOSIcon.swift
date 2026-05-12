import Foundation

// MARK: - ICOS Icon Semantic Model
// Canonical semantic registry plus full website SVG catalog registration.
// Root is resolved by SVGKitRenderer:
// /Users/artan/Documents/Neuroartan/website/docs/assets/icons

enum ICOSIcon: String, CaseIterable, Hashable {

    // MARK: - Active App Semantics / Compatibility Aliases
    case home
    case menu
    case settings
    case search
    case platform
    case updates
    case about
    case chat
    case console
    case knowledge
    case careers
    case listen
    case response
    case talk
    case loading
    case success
    case error
    case appearance
    case configuration
    case personalization
    case environment
    case worktree
    case browserUse
    case chatManagement
    case projectManagement
    case fileManager
    case workspaceRecents
    case workspaceShared
    case workspaceArchive
    case inspector
    case back
    case folder
    case file
    case trash
    case rename
    case branch
    case cloud
    case key
    case add
    case voice
    case mic
    case audio
    case send
    case stop
    case close
    case titlebarSidebarToggle
    case titlebarInspectorToggle

    // MARK: - Core Navigation
    case arrowDown
    case arrowLeft
    case arrowRight
    case arrowUp
    case navigationBack
    case navigationCareers
    case chevronDown
    case chevronLeft
    case chevronRight
    case chevronUp
    case columns
    case command
    case compass
    case country
    case dashboard
    case discover
    case down
    case drawerClose
    case drawerOpen
    case explore
    case feed
    case globe
    case grid
    case language
    case left
    case library
    case list
    case location
    case map
    case menuLeft
    case menuRight
    case more
    case panelLeft
    case panelLeftActivated
    case panelLeftDeactivated
    case panelRight
    case panelRightActivated
    case panelRightDeactivated
    case panelBottom
    case panelBottomActivated
    case panelBottomDeactivated
    case right
    case route
    case sidebarActive
    case sidebarLeft
    case sidebarRight

    // MARK: - Core Productivity
    case reminder
    case schedule
    case collaborate
    case comment
    case highlight
    case note
    case notes
    case checklist
    case progress
    case tasks
    case focus
    case workspace

    // MARK: - Core System
    case theme
    case sync
    case synced
    case unsynced
    case timer
    case analytics
    case autoMode
    case automation
    case bellOff
    case bell
    case bug
    case calendar
    case chartBar
    case chartLine
    case chartPie
    case clock
    case colorMode
    case customize
    case darkMode
    case lightMode
    case log
    case notification
    case pending
    case status
    case sliders
    case stage
    case support

    // MARK: - Developer Layer
    case ask
    case review
    case session
    case agent
    case model
    case terminal
    case copy
    case fork
    case expand
    case collapse
    case deployment
    case docs
    case integration
    case observability
    case repository
    case testing

    // MARK: - ICOS Layer
    case growth
    case audience
    case post
    case thread
    case visibility

    // MARK: - Investor Layer
    case capTable
    case deck
    case financials
    case investor
    case report

    // MARK: - Jobs Layer
    case application
    case jobsCareers
    case hiring
    case role
    case workflow

    // MARK: - Office Layer
    case approvals
    case dashboards
    case hr
    case memo
    case operations
    case records

    // MARK: - Software Layer
    case api
    case app
    case documentation
    case release
    case sdk

    // MARK: - Website Layer
    case favicon
    case recoverAccount
    case resetPassword
    case apple
    case googleSignin
    case google
    case signinEmail
    case signinPhone
    case partner
    case applepay
    case bitcoin
    case bitcoincash
    case googlepay
    case mastercard
    case visa
    case thought
    case article
    case media
    case publication
    case research
    case software
    case update
    case footerAbout
    case footerPlatform
    case footerUpdates
    case continuityThread
    case profileModel
    case recentInteraction
    case voiceTraining
    case recent
    case event
    case hoverToSocialMediaAndMusic
    case music
    case consent
    case preferences
    case capture
    case continuity
    case patterning
    case reflection
    case signals
    case structure
    case appleMusic
    case applePodcasts
    case appleTV
    case facebook
    case soundcloud
    case spotify
    case tiktok
    case whatsapp
    case youtubeMusic
    case contact
    case service
    case book
    case project
    case security
    case trust

    // MARK: - Registry
    case registryIndex
    case deprecated
    case migration

    // MARK: - System Brand / Social / States / Themes
    case markOutline
    case markSolid
    case monogram
    case symbol
    case wordmark
    case discord
    case email
    case github
    case instagram
    case linkedin
    case x
    case youtube
    case empty
    case maintenance
    case noResults
    case offline
    case online
    case warning
    case autoTheme
    case colorTheme
    case darkTheme
    case lightTheme

    // MARK: - SVG Path Mapping
    var path: String {
        switch self {

        // Active App Semantics / Compatibility Aliases
        case .home: return "core/navigation/primary/home.svg"
        case .menu: return "core/navigation/menu/menu.svg"
        case .settings: return "core/system/settings/settings.svg"
        case .search: return "core/actions/search/search.svg"
        case .platform: return "layers/website/navigation/menu/platform.svg"
        case .updates: return "layers/website/navigation/menu/updates.svg"
        case .about: return "core/navigation/institutional/about.svg"
        case .chat: return "layers/icos/communication/chat/chat.svg"
        case .console: return "layers/icos/runtime/console.svg"
        case .knowledge: return "core/cognition/knowledge/knowledge.svg"
        case .careers: return "core/navigation/institutional/careers.svg"
        case .listen: return "layers/icos/interaction/listen.svg"
        case .response: return "core/interface/response/response.svg"
        case .talk: return "layers/icos/interaction/talk.svg"
        case .loading: return "system/states/loading.svg"
        case .success: return "system/states/success.svg"
        case .error: return "system/states/error.svg"
        case .appearance: return "layers/icos/features/appearance.svg"
        case .configuration: return "layers/icos/features/configuration.svg"
        case .personalization: return "layers/icos/features/personalization.svg"
        case .environment: return "layers/icos/runtime/environment.svg"
        case .worktree: return "layers/icos/runtime/worktree.svg"
        case .browserUse: return "layers/icos/features/browser-use.svg"
        case .chatManagement: return "layers/icos/features/chat-management.svg"
        case .projectManagement: return "layers/icos/features/project-management.svg"
        case .fileManager: return "layers/icos/features/file-manager.svg"
        case .workspaceRecents: return "layers/icos/runtime/workspace-recents.svg"
        case .workspaceShared: return "layers/icos/runtime/workspace-shared.svg"
        case .workspaceArchive: return "layers/icos/runtime/workspace-archive.svg"
        case .inspector: return "layers/icos/interface/inspector.svg"
        case .back: return "core/navigation/direction/back.svg"
        case .folder: return "core/files/folder/folder.svg"
        case .file: return "core/files/document/file.svg"
        case .trash: return "core/actions/destructive/trash.svg"
        case .rename: return "core/actions/editing/rename.svg"
        case .branch: return "core/development/version-control/branch.svg"
        case .cloud: return "core/files/cloud/cloud.svg"
        case .key: return "core/identity/security/key.svg"
        case .add: return "core/actions/create/add.svg"
        case .voice: return "core/media/audio/mic.svg"
        case .mic: return "core/media/audio/mic.svg"
        case .audio: return "core/media/audio/audio.svg"
        case .send: return "core/actions/send/send.svg"
        case .stop: return "core/media/transport/stop.svg"
        case .close: return "core/actions/close/close.svg"
        case .titlebarSidebarToggle: return "layers/icos/interface/titlebar-sidebar-toggle.svg"
        case .titlebarInspectorToggle: return "layers/icos/interface/titlebar-inspector-toggle.svg"

        // Core Navigation
        case .arrowDown: return "core/navigation/direction/arrow-down.svg"
        case .arrowLeft: return "core/navigation/direction/arrow-left.svg"
        case .arrowRight: return "core/navigation/direction/arrow-right.svg"
        case .arrowUp: return "core/navigation/direction/arrow-up.svg"
        case .navigationBack: return "core/navigation/direction/back.svg"
        case .navigationCareers: return "core/navigation/institutional/navigation-careers.svg"
        case .chevronDown: return "core/navigation/chevron/chevron-down.svg"
        case .chevronLeft: return "core/navigation/chevron/chevron-left.svg"
        case .chevronRight: return "core/navigation/chevron/chevron-right.svg"
        case .chevronUp: return "core/navigation/chevron/chevron-up.svg"
        case .columns: return "core/navigation/layout/columns.svg"
        case .command: return "core/navigation/command/command.svg"
        case .compass: return "core/navigation/discovery/compass.svg"
        case .country: return "core/navigation/location/country.svg"
        case .dashboard: return "core/navigation/dashboard/dashboard.svg"
        case .discover: return "core/navigation/discovery/discover.svg"
        case .down: return "core/navigation/direction/down.svg"
        case .drawerClose: return "core/actions/close/drawer-close.svg"
        case .drawerOpen: return "core/navigation/drawer/drawer-open.svg"
        case .explore: return "core/navigation/discovery/explore.svg"
        case .feed: return "core/navigation/feed/feed.svg"
        case .globe: return "core/navigation/global/globe.svg"
        case .grid: return "core/navigation/layout/grid.svg"
        case .language: return "core/navigation/language/language.svg"
        case .left: return "core/navigation/direction/left.svg"
        case .library: return "core/navigation/library/library.svg"
        case .list: return "core/navigation/layout/list.svg"
        case .location: return "core/navigation/location/location.svg"
        case .map: return "core/navigation/location/map.svg"
        case .menuLeft: return "core/navigation/menu/menu-left.svg"
        case .menuRight: return "core/navigation/menu/menu-right.svg"
        case .more: return "core/actions/more/more.svg"
        case .panelLeft: return "core/navigation/panel/panel-left.svg"
        case .panelLeftActivated: return "core/navigation/panel/panel-left-activated.svg"
        case .panelLeftDeactivated: return "core/navigation/panel/panel-left-deactivated.svg"
        case .panelRight: return "core/navigation/panel/panel-right.svg"
        case .panelRightActivated: return "core/navigation/panel/panel-right-activated.svg"
        case .panelRightDeactivated: return "core/navigation/panel/panel-right-deactivated.svg"
        case .panelBottom: return "core/navigation/panel/panel-bottom.svg"
        case .panelBottomActivated: return "core/navigation/panel/panel-bottom-activated.svg"
        case .panelBottomDeactivated: return "core/navigation/panel/panel-bottom-deactivated.svg"
        case .right: return "core/navigation/direction/right.svg"
        case .route: return "core/navigation/route/route.svg"
        case .sidebarActive: return "core/navigation/sidebar/sidebar-active.svg"
        case .sidebarLeft: return "core/navigation/sidebar/sidebar-left.svg"
        case .sidebarRight: return "core/navigation/sidebar/sidebar-right.svg"

        // Core Productivity
        case .reminder: return "core/productivity/calendar/reminder.svg"
        case .schedule: return "core/productivity/calendar/schedule.svg"
        case .collaborate: return "core/productivity/collaboration/collaborate.svg"
        case .comment: return "layers/icos/features/chat-management.svg"
        case .highlight: return "core/actions/editing/highlight.svg"
        case .note: return "core/files/notes/note.svg"
        case .notes: return "core/productivity/notes/notes.svg"
        case .checklist: return "core/productivity/tasks/checklist.svg"
        case .progress: return "core/productivity/tasks/progress.svg"
        case .tasks: return "core/productivity/tasks/tasks.svg"
        case .focus: return "core/productivity/workspace/focus.svg"
        case .workspace: return "core/productivity/workspace/workspace.svg"

        // Core System
        case .theme: return "core/system/settings/theme.svg"
        case .sync: return "core/system/sync/sync.svg"
        case .synced: return "core/system/status/synced.svg"
        case .unsynced: return "core/system/status/unsynced.svg"
        case .timer: return "core/system/time/timer.svg"
        case .analytics: return "core/system/analytics/analytics.svg"
        case .autoMode: return "core/system/mode/auto-mode.svg"
        case .automation: return "core/system/automation/automation.svg"
        case .bellOff: return "core/system/notifications/bell-off.svg"
        case .bell: return "core/system/notifications/bell.svg"
        case .bug: return "core/system/debug/bug.svg"
        case .calendar: return "core/productivity/calendar/calendar.svg"
        case .chartBar: return "core/system/analytics/chart-bar.svg"
        case .chartLine: return "core/system/analytics/chart-line.svg"
        case .chartPie: return "core/system/analytics/chart-pie.svg"
        case .clock: return "core/system/time/clock.svg"
        case .colorMode: return "core/system/theme/color-mode.svg"
        case .customize: return "layers/icos/features/personalization.svg"
        case .darkMode: return "core/system/theme/dark-mode.svg"
        case .lightMode: return "core/system/theme/light-mode.svg"
        case .log: return "core/system/logs/log.svg"
        case .notification: return "core/system/notifications/notification.svg"
        case .pending: return "core/system/status/pending.svg"
        case .status: return "core/system/status/status.svg"
        case .sliders: return "core/system/settings/sliders.svg"
        case .stage: return "core/system/stage/stage.svg"
        case .support: return "core/system/support/support.svg"

        // Developer Layer
        case .ask: return "layers/developer/interaction/ask.svg"
        case .review: return "layers/developer/review/review.svg"
        case .session: return "layers/developer/session/session.svg"
        case .agent: return "layers/developer/agent/agent.svg"
        case .model: return "core/cognition/model/model.svg"
        case .terminal: return "layers/developer/terminal/terminal.svg"
        case .copy: return "core/actions/copy/copy.svg"
        case .fork: return "core/development/version-control/fork.svg"
        case .expand: return "core/actions/expand-collapse/expand.svg"
        case .collapse: return "core/actions/expand-collapse/collapse.svg"
        case .deployment: return "layers/developer/deployment/deployment.svg"
        case .docs: return "layers/developer/docs/docs.svg"
        case .integration: return "layers/developer/integration/integration.svg"
        case .observability: return "layers/developer/observability/observability.svg"
        case .repository: return "layers/developer/repository/repository.svg"
        case .testing: return "layers/developer/testing/testing.svg"

        // ICOS Layer
        case .growth: return "layers/icos/continuity/growth.svg"
        case .audience: return "layers/icos/publishing/audience.svg"
        case .post: return "layers/icos/publishing/post.svg"
        case .thread: return "layers/icos/publishing/thread.svg"
        case .visibility: return "layers/icos/publishing/visibility.svg"

        // Investor Layer
        case .capTable: return "layers/investor/cap-table/cap-table.svg"
        case .deck: return "layers/investor/decks/deck.svg"
        case .financials: return "layers/investor/financials/financials.svg"
        case .investor: return "layers/investor/fundraising/investor.svg"
        case .report: return "layers/investor/reports/report.svg"

        // Jobs Layer
        case .application: return "layers/jobs/applications/application.svg"
        case .jobsCareers: return "layers/jobs/careers/jobs-careers.svg"
        case .hiring: return "layers/jobs/hiring/hiring.svg"
        case .role: return "layers/jobs/roles/role.svg"
        case .workflow: return "layers/jobs/workflow/workflow.svg"

        // Office Layer
        case .approvals: return "layers/office/approvals/approvals.svg"
        case .dashboards: return "layers/office/dashboards/dashboards.svg"
        case .hr: return "layers/office/hr/hr.svg"
        case .memo: return "layers/office/memo/memo.svg"
        case .operations: return "layers/office/operations/operations.svg"
        case .records: return "layers/office/records/records.svg"

        // Software Layer
        case .api: return "layers/software/api/api.svg"
        case .app: return "layers/software/app/app.svg"
        case .documentation: return "layers/software/documentation/documentation.svg"
        case .release: return "layers/software/releases/release.svg"
        case .sdk: return "layers/software/sdk/sdk.svg"

        // Website Layer
        case .favicon: return "layers/website/app/favicon/favicon.svg"
        case .recoverAccount: return "layers/website/auth/recovery/recover-account.svg"
        case .resetPassword: return "layers/website/auth/recovery/reset-password.svg"
        case .apple: return "layers/website/auth/signin/apple.svg"
        case .googleSignin: return "layers/website/auth/signin/google-signin.svg"
        case .google: return "layers/website/auth/signin/google.svg"
        case .signinEmail: return "layers/website/auth/signin/signin-email.svg"
        case .signinPhone: return "layers/website/auth/signin/signin-phone.svg"
        case .partner: return "layers/website/brand/partners/partner.svg"
        case .applepay: return "layers/website/brand/payment/applepay.svg"
        case .bitcoin: return "layers/website/brand/payment/bitcoin.svg"
        case .bitcoincash: return "layers/website/brand/payment/bitcoincash.svg"
        case .googlepay: return "layers/website/brand/payment/googlepay.svg"
        case .mastercard: return "layers/website/brand/payment/mastercard.svg"
        case .visa: return "layers/website/brand/payment/visa.svg"
        case .thought: return "layers/icos/intelligence/intelligence.svg"
        case .article: return "layers/website/content/articles/article.svg"
        case .media: return "layers/website/content/media/media.svg"
        case .publication: return "layers/website/content/publications/publication.svg"
        case .research: return "layers/website/content/research/research.svg"
        case .software: return "layers/website/content/software/software.svg"
        case .update: return "layers/website/content/updates/update.svg"
        case .footerAbout: return "layers/website/home/footer/footer-about.svg"
        case .footerPlatform: return "layers/website/home/footer/footer-platform.svg"
        case .footerUpdates: return "layers/website/home/footer/footer-updates.svg"
        case .continuityThread: return "layers/website/home/panels/continuity-thread.svg"
        case .profileModel: return "layers/website/home/panels/profile-model.svg"
        case .recentInteraction: return "layers/website/home/panels/recent-interaction.svg"
        case .voiceTraining: return "layers/website/home/panels/voice-training.svg"
        case .recent: return "layers/website/home/panels/recent.svg"
        case .event: return "layers/website/legacy/event.svg"
        case .hoverToSocialMediaAndMusic: return "layers/website/legacy/hover-to-social-media-and-music.svg"
        case .music: return "layers/website/legacy/music.svg"
        case .consent: return "layers/website/overlays/consent/consent.svg"
        case .preferences: return "layers/website/overlays/cookie/preferences.svg"
        case .capture: return "core/cognition/capture/capture.svg"
        case .continuity: return "core/cognition/continuity/continuity.svg"
        case .patterning: return "core/cognition/patterning/patterning.svg"
        case .reflection: return "core/cognition/reflection/reflection.svg"
        case .signals: return "core/cognition/signals/signals.svg"
        case .structure: return "core/cognition/structure/structure.svg"
        case .appleMusic: return "layers/website/social/platforms/apple-music.svg"
        case .applePodcasts: return "layers/website/social/platforms/applepodcasts.svg"
        case .appleTV: return "layers/website/social/platforms/appletv.svg"
        case .facebook: return "layers/website/social/platforms/facebook.svg"
        case .soundcloud: return "layers/website/social/platforms/soundcloud.svg"
        case .spotify: return "layers/website/social/platforms/spotify.svg"
        case .tiktok: return "layers/website/social/platforms/tiktok.svg"
        case .whatsapp: return "layers/website/social/platforms/whatsapp.svg"
        case .youtubeMusic: return "layers/website/social/platforms/youtube-music.svg"
        case .contact: return "layers/website/support/contact/contact.svg"
        case .service: return "layers/website/support/service/service.svg"
        case .book: return "core/cognition/knowledge/book.svg"
        case .project: return "layers/icos/features/project-management.svg"
        case .security: return "core/identity/security/security.svg"
        case .trust: return "layers/website/trust/trust.svg"

        // Registry
        case .registryIndex: return "layers/icos/runtime/registry-index.svg"
        case .deprecated: return "registry/deprecated/deprecated.svg"
        case .migration: return "registry/migration/migration.svg"

        // System Brand / Social / States / Themes
        case .markOutline: return "system/brand/mark-outline.svg"
        case .markSolid: return "system/brand/mark-solid.svg"
        case .monogram: return "system/brand/monogram.svg"
        case .symbol: return "system/brand/symbol.svg"
        case .wordmark: return "system/brand/wordmark.svg"
        case .discord: return "system/social/discord.svg"
        case .email: return "system/social/email.svg"
        case .github: return "system/social/github.svg"
        case .instagram: return "system/social/instagram.svg"
        case .linkedin: return "system/social/linkedin.svg"
        case .x: return "system/social/x.svg"
        case .youtube: return "system/social/youtube.svg"
        case .empty: return "system/states/empty.svg"
        case .maintenance: return "system/states/maintenance.svg"
        case .noResults: return "system/states/no-results.svg"
        case .offline: return "system/states/offline.svg"
        case .online: return "system/states/online.svg"
        case .warning: return "system/states/warning.svg"
        case .autoTheme: return "layers/icos/features/auto-theme.svg"
        case .colorTheme: return "layers/icos/features/color-theme.svg"
        case .darkTheme: return "layers/icos/features/dark-theme.svg"
        case .lightTheme: return "layers/icos/features/light-theme.svg"
        }
    }

    // MARK: - Bundle Resource Mapping
    var resourceName: String {
        let components = path
            .replacingOccurrences(of: ".svg", with: "")
            .split(separator: "/")

        return components.last.map(String.init) ?? rawValue
    }

    // MARK: - Registry Introspection
    static var semanticPaths: [String] {
        allCases.map(\.path).sorted()
    }

    static var catalogRootURL: URL {
        URL(fileURLWithPath: "/Users/artan/Documents/Neuroartan/website/docs/assets/icons")
    }

    static var catalogPaths: [String] {
        guard let enumerator = FileManager.default.enumerator(
            at: catalogRootURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return enumerator
            .compactMap { $0 as? URL }
            .filter { $0.pathExtension == "svg" }
            .map { $0.path.replacingOccurrences(of: catalogRootURL.path + "/", with: "") }
            .sorted()
    }

    static var registeredPaths: [String] {
        Array(Set(semanticPaths + catalogPaths)).sorted()
    }

    static var registeredPathSet: Set<String> {
        Set(registeredPaths)
    }

    static func isRegisteredCatalogPath(_ path: String) -> Bool {
        registeredPathSet.contains(path)
    }
}
