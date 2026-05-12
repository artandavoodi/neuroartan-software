import SwiftUI
import Combine

/// ICOS Root UI Coordinator
/// Central composition layer for system-wide UI orchestration
@MainActor
final class UIRootCoordinator: ObservableObject {

    @Published var router: AppRouter
    @Published var services: SystemServices

    convenience init() {
        let services = SystemServices()
        self.init(router: services.router, services: services)
    }

    init(
        router: AppRouter,
        services: SystemServices
    ) {
        self.router = router
        self.services = services
    }

    // MARK: - Root View
    func rootView() -> some View {
        RouterView(router: services.router, appState: services.appState)
            .environmentObject(services)
            .environmentObject(services.themeEngine)
            .environmentObject(services.behaviorEngine)
    }
}
