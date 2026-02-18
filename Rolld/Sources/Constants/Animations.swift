import SwiftUI

enum Animations {

    /// Bouncy entrance animation — spring(0.5, 0.6)
    static let bouncy = Animation.spring(duration: 0.5, bounce: 0.3)

    /// Snappy press feedback — spring(0.35, 0.75)
    static let snappy = Animation.spring(duration: 0.35, bounce: 0.15)

    /// Gentle subtle shift — spring(0.6, 0.8)
    static let gentle = Animation.spring(duration: 0.6, bounce: 0.1)

    /// Standard transition animation
    static let standard = Animation.spring(duration: 0.4, bounce: 0.2)

    /// Wheel spin — timing curve with natural deceleration over 5s
    static let wheelSpin = Animation.timingCurve(0.0, 0.7, 0.2, 1.0, duration: 5.0)

    /// Staggered entrance with per-index delay
    static func stagger(index: Int) -> Animation {
        Animation.spring(duration: 0.5, bounce: 0.3)
            .delay(Double(index) * 0.1)
    }
}
