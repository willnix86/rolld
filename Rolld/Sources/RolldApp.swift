import SwiftUI
import SwiftData

@main
struct RolldApp: App {
    @State private var coordinator = NavigationCoordinator(initialScreen: .home)

    //    var sharedModelContainer: ModelContainer = {
    //        let schema = Schema([
    //            Item.self,
    //        ])
    //        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    //
    //        do {
    //            return try ModelContainer(for: schema, configurations: [modelConfiguration])
    //        } catch {
    //            fatalError("Could not create ModelContainer: \(error)")
    //        }
    //    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.paths) {
                coordinator.navigate(to: .home)
                    .navigationDestination(for: Screens.self) { screen in
                        coordinator.navigate(to: screen)
                    }
            }
            .environment(coordinator)
        }
        //        .modelContainer(sharedModelContainer)
    }
}
