import CoreMotion
import GameKit
import SpriteKit

class DiceScene: SKScene {
    private var dice: SKSpriteNode!
    private let motionManager = CMMotionManager()
    private var isRolling = false
    private var rollingAction: SKAction?
    private var lastFaceChangeTime: TimeInterval = 0
    private var currentFaceIndex: Int = 1

#if DEBUG
    private var stopRollingWorkItem: DispatchWorkItem?
#endif

    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupDice()
        setupPhysics()
        startShakeDetection()

#if DEBUG
        // Add tap gesture recognizer in DEBUG mode
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(simulateShake))
        view.addGestureRecognizer(tapGesture)
#endif
    }

    private func setupDice() {
        dice = SKSpriteNode(imageNamed: "dice_result_orthographic_01")
        dice.size = CGSize(width: 100, height: 100)
        dice.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dice.physicsBody = SKPhysicsBody(rectangleOf: dice.size)
        dice.physicsBody?.affectedByGravity = false
        dice.physicsBody?.allowsRotation = true

        addChild(dice)
    }

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    private func startShakeDetection() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let acceleration = data?.acceleration else { return }
            let threshold: Double = 2.0
            let isShaking = abs(acceleration.x) > threshold || abs(acceleration.y) > threshold || abs(acceleration.z) > threshold

            switch (isShaking, self.isRolling) {
            case (true, false):
                self.isRolling = true
                self.continueRollingDice()
            case (true, true):
                self.continueRollingDice()
            case (false, true):
                self.stopRollingDice()
            default: break
            }
        }
    }

    private func applyImpulseToDice() {
        // Adjust this value for speed (higher = faster)
        let impulseMagnitude: CGFloat = 1000

        var dx = CGFloat.random(in: -impulseMagnitude...impulseMagnitude)
        var dy = CGFloat.random(in: -impulseMagnitude...impulseMagnitude)

        guard let currentVelocity = dice.physicsBody?.velocity else {
            // Apply initial impulse with random dx and dy
            dice.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
            dice.physicsBody?.applyAngularImpulse(0.5)
            return
        }

        // Amplify current velocity to ensure consistent movement
        let velocityMultiplier: CGFloat = 1.5 // Adjust this to control sustained speed
        dx += currentVelocity.dx * velocityMultiplier
        dy += currentVelocity.dy * velocityMultiplier

        // Apply the amplified impulse
        dice.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        dice.physicsBody?.applyAngularImpulse(0.5)
    }

    override func update(_ currentTime: TimeInterval) {
        guard isRolling else { return }

        // Calculate the dice speed
        let speed = dice.physicsBody?.velocity.length() ?? 0.1
        let horizontalVelocity = dice.physicsBody?.velocity.dx ?? 0 // Horizontal velocity

        // Dynamically adjust maxSpeed based on observed maximum
        let maxSpeed: CGFloat = 2600 // Match your observed peak speeds

        // Normalize speed to [0, 1] range
        let normalizedSpeed = min(max(speed / maxSpeed, 0), 1)

        // Map normalized speed to the interval range
        let minInterval: TimeInterval = 0.1 // Fastest interval
        let maxInterval: TimeInterval = 0.5 // Slowest interval
        let interval = maxInterval - (normalizedSpeed * (maxInterval - minInterval))

        // Check if enough time has passed to update the dice face
        if currentTime - lastFaceChangeTime >= interval {
            // Update the dice face sequentially based on direction
            if horizontalVelocity > 0 {
                // Moving right: Increment face index
                currentFaceIndex += 1
                if currentFaceIndex > 7 {
                    currentFaceIndex = 1 // Wrap around
                }
            } else if horizontalVelocity < 0 {
                // Moving left: Decrement face index
                currentFaceIndex -= 1
                if currentFaceIndex < 1 {
                    currentFaceIndex = 7 // Wrap around
                }
            }

            // Update the dice texture
            dice.texture = SKTexture(imageNamed: "dice_animation_0\(currentFaceIndex)")

            // Record the time of this face change
            lastFaceChangeTime = currentTime
        }
    }

    private func continueRollingDice() {
        applyImpulseToDice()
    }

    private func stopRollingDice() {
        let d6 = GKRandomDistribution.d6()
        let face = d6.nextInt()
        dice.texture = SKTexture(imageNamed: "dice_result_orthographic_0\(face)")

        // Stop the rolling action
        self.isRolling = false

        // Stop physics motion
        dice.physicsBody?.velocity = .zero
        dice.physicsBody?.angularVelocity = 0

        dice.zRotation = 0
    }

#if DEBUG
    @objc func simulateShake() {
        if isRolling {
            continueRollingDice()
        } else {
            isRolling = true
            continueRollingDice()
        }

        // Cancel any previously scheduled stopRolling
        stopRollingWorkItem?.cancel()

        // Schedule a new stopRolling action after 5 seconds of inactivity
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.stopRollingDice()
        }
        stopRollingWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: newWorkItem)
    }
#endif

    override func willMove(from view: SKView) {
        motionManager.stopAccelerometerUpdates()
#if DEBUG
        // Remove the gesture recognizer in DEBUG mode
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
#endif
    }
}

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
}
