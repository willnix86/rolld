import SwiftUI

@main
struct RolldApp: App {
    @State private var appState = AppState()
    @State private var coordinator = NavigationCoordinator(initialScreen: .home)

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.paths) {
                coordinator.navigate(to: .home)
                    .navigationDestination(for: Screens.self) { screen in
                        coordinator.navigate(to: screen)
                    }
            }
            .environment(coordinator)
            .environment(appState)
            .preferredColorScheme(.dark)
        }
    }
}
