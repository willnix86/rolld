enum Screens: Hashable {
    case home
    case playerSelection
    case dareSelection(
        playerName: String
    )
    case diceRollView(
        playerName: String,
        dares: [String]
    )
    case dareResult(
        playerName: String,
        dare: String
    )
}
