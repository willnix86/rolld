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
        paths.append(screen)
    }

    func push(_ screen: Screens) {
        screenStack.append(screen)
        paths.append(screen)
    }

    func pop() {
        if !screenStack.isEmpty {
            screenStack.removeLast()
            paths.removeLast()
        }
    }

    func popTo(_ screen: Screens) {
        guard let index = screenStack.firstIndex(of: screen) else {
            print("Screen not found in stack.")
            return
        }

        screenStack.removeLast(screenStack.count - index - 1)

        paths = NavigationPath()
        for screen in screenStack {
            paths.append(screen)
        }
    }

    func popToRoot() {
        guard let rootScreen = screenStack.first else { return }
        setRootScreen(rootScreen)
    }
}
