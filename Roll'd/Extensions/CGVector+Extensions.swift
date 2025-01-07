import SpriteKit

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
}
