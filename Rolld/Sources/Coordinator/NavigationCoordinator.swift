import SwiftUI

@Observable
final class NavigationCoordinator {
    var paths = NavigationPath()
    private var screenStack: [Screens] = [] // Keeps track of the screen stack

    init(initialScreen: Screens) {
        setRootScreen(initialScreen)
    }

    @ViewBuilder
    func navigate(to screen: Screens) -> some View {
        switch screen {
        case .home:
            HomePage()
        case .playerSelection:
            RouletteWheelView()
        case .dare:
            DareView()
        case .forfeitSelection:
            ForfeitSelectionView()
        case .dice(let forfeits):
            DiceView(forfeits: forfeits)
        }
    }

    func setRootScreen(_ screen: Screens) {
        screenStack = [screen]
        paths = NavigationPath()
        // Root view is rendered by NavigationStack's view builder — NOT the path.
        // Appending it to paths would push a duplicate on top.
    }

    func push(_ screen: Screens) {
        screenStack.append(screen)
        paths.append(screen)
    }

    func pop() {
        // Keep at least the root screen in screenStack
        if screenStack.count > 1 {
            screenStack.removeLast()
            paths.removeLast()
        }
    }

    func popTo(_ screen: Screens) {
        guard let index = screenStack.firstIndex(of: screen) else {
            print("ENDIDEBUG: Screen not found in stack.")
            return
        }

        let itemsToRemove = screenStack.count - index - 1
        guard itemsToRemove > 0 else { return }

        screenStack.removeLast(itemsToRemove)

        // Rebuild paths from non-root items only (root is the NavigationStack's view builder)
        paths = NavigationPath()
        for screen in screenStack.dropFirst() {
            paths.append(screen)
        }
    }

    func popToRoot() {
        guard let rootScreen = screenStack.first else { return }
        screenStack = [rootScreen]
        paths = NavigationPath()
    }
}
