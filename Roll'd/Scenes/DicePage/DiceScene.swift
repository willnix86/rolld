import CoreMotion
import GameKit
import SpriteKit

enum DiceCollisionCategory: UInt32 {
    // Values need to double each time
    case dice = 1
    case wall = 2
}

class DiceScene: SKScene {
    private var instructionLabel: SKLabelNode
    private var challengeLabel: SKLabelNode
    private var dice: SKSpriteNode
    private var playerName: String

    private var needsManualReset = false
    private var isRolling = false
    private var rollingAction: SKAction?
    private var lastFaceChangeTime: TimeInterval = 0
    private var currentFaceIndex: Int = 1
    private var accelerationHistory: [Double] = []
    private let historySize = 10 // Number of samples to smooth over


#if DEBUG
    private var stopRollingWorkItem: DispatchWorkItem?
#endif

    private let motionManager = CMMotionManager()
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    init(
        size: CGSize,
        playerName: String
    ) {
        self.playerName = playerName

        self.instructionLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.challengeLabel = SKLabelNode(fontNamed: "Chalkduster")

        let d6 = GKRandomDistribution.d6()
        let face = d6.nextInt()
        self.dice = SKSpriteNode(imageNamed: "dice_result_orthographic_0\(face)")

        super.init(size: size)

        self.backgroundColor = Colors.orange.uiColor
    }
    
    override func didMove(to view: SKView) {
        hapticGenerator.prepare()

        setupPhysics()

        presentInstructions()
        presentDice()

        startShakeDetection()

#if DEBUG
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(simulateShake))
        view.addGestureRecognizer(tapGesture)
#endif
    }

    private func presentInstructions() {
        instructionLabel.text = "\(playerName), let's roll!"
        instructionLabel.fontSize = 28
        instructionLabel.fontColor = Colors.red.uiColor
        instructionLabel.position = CGPoint(x: frame.midX, y: frame.height / 3)

        addChild(instructionLabel)
    }

    private func presentDice() {
        dice.size = CGSize(width: 150, height: 150)
        dice.position = CGPoint(x: size.width / 2, y: size.height / 2)

        dice.physicsBody = SKPhysicsBody(rectangleOf: dice.size)
        dice.physicsBody?.affectedByGravity = false
        dice.physicsBody?.allowsRotation = true

        // Assign category and contact bit masks
        dice.physicsBody?.categoryBitMask = DiceCollisionCategory.dice.rawValue
        dice.physicsBody?.contactTestBitMask = DiceCollisionCategory.wall.rawValue

        addChild(dice)
    }

    private func setupPhysics() {
        physicsWorld.contactDelegate = self

        let wallBody = SKPhysicsBody(
            edgeLoopFrom: CGRect(
                x: -35,
                y: 0,
                width: frame.width + 70,
                height: frame.height
            )
        )

        // Assign category and contact bit masks
        wallBody.categoryBitMask = DiceCollisionCategory.wall.rawValue
        wallBody.contactTestBitMask = DiceCollisionCategory.dice.rawValue

        physicsBody = wallBody
    }

    private func startShakeDetection() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let acceleration = data?.acceleration else { return }

            // Compute the magnitude of acceleration
            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))

            self.accelerationHistory.append(magnitude)
            if self.accelerationHistory.count > self.historySize {
                self.accelerationHistory.removeFirst()
            }

            // Compute rolling average
            let rollingAverage = self.accelerationHistory.reduce(0, +) / Double(self.accelerationHistory.count)

            let shakeThreshold: Double = 1.5
            let isShaking = rollingAverage > shakeThreshold

            switch (isShaking, self.isRolling) {
            case (true, false):
                self.isRolling = true
                self.continueRollingDice()
            case (true, true):
                self.continueRollingDice()
            case (false, true):
                self.handleStopRolling()
            default: break
            }
        }
    }

    private func applyImpulseToDice() {
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
        let velocityMultiplier: CGFloat = 1.5
        dx += currentVelocity.dx * velocityMultiplier
        dy += currentVelocity.dy * velocityMultiplier

        dice.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        dice.physicsBody?.applyAngularImpulse(0.5)
    }

    override func update(_ currentTime: TimeInterval) {
        guard isRolling, !needsManualReset else { return }

        // Ensure dice stays within bounds
       let diceMinX = dice.size.width / 2
       let diceMaxX = size.width - dice.size.width / 2
       let diceMinY = dice.size.height / 2
       let diceMaxY = size.height - dice.size.height / 2

       if dice.position.x < diceMinX {
           dice.position.x = diceMinX
       } else if dice.position.x > diceMaxX {
           dice.position.x = diceMaxX
       }

       if dice.position.y < diceMinY {
           dice.position.y = diceMinY
       } else if dice.position.y > diceMaxY {
           dice.position.y = diceMaxY
       }

        updateDiceTexture(with: currentTime)
    }

    private func updateDiceTexture(with currentTime: TimeInterval) {
        // Calculate the dice speed
        let speed = dice.physicsBody?.velocity.length() ?? 0.1
        let horizontalVelocity = dice.physicsBody?.velocity.dx ?? 0

        let maxSpeed: CGFloat = 2600

        // Normalize speed to [0, 1] range
        let normalizedSpeed = min(max(speed / maxSpeed, 0), 1)

        // Map normalized speed to the interval range
        let minInterval: TimeInterval = 0.05 // Fastest interval
        let maxInterval: TimeInterval = 0.5  // Slowest interval
        let interval = maxInterval - (normalizedSpeed * (maxInterval - minInterval))

        // Check if enough time has passed to update the dice face
        if currentTime - lastFaceChangeTime >= interval {
            // Update the dice face sequentially based on direction
            if horizontalVelocity > 0 {
                currentFaceIndex += 1
                if currentFaceIndex > 7 {
                    currentFaceIndex = 1
                }
            } else if horizontalVelocity < 0 {
                currentFaceIndex -= 1
                if currentFaceIndex < 1 {
                    currentFaceIndex = 7
                }
            }

            dice.texture = SKTexture(imageNamed: "dice_animation_0\(currentFaceIndex)")
            hapticGenerator.impactOccurred()

            // Record the time of this face change
            lastFaceChangeTime = currentTime
        }
    }

    private func continueRollingDice() {
        guard !needsManualReset else { return }

        instructionLabel.removeFromParent()

        stopRollingWorkItem?.cancel() // Cancel any scheduled stop
        stopRollingWorkItem = nil

        applyImpulseToDice()
    }

    private func handleStopRolling() {
        guard stopRollingWorkItem == nil, !needsManualReset else {
            return
        }

        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            if self.isRolling {
                self.stopRollingDice()
            }

            self.stopRollingWorkItem = nil
        }

        stopRollingWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: newWorkItem)
    }

    private func stopRollingDice() {
        let d6 = GKRandomDistribution.d6()
        let face = d6.nextInt()

        dice.texture = SKTexture(imageNamed: "dice_result_orthographic_0\(face)")
        hapticGenerator.impactOccurred()

        isRolling = false
        needsManualReset = true

        dice.physicsBody?.velocity = .zero
        dice.physicsBody?.angularVelocity = 0

        dice.zRotation = 0

        presentNextSteps()
    }

    private func presentNextSteps() {
        let moveDiceToCenter = SKAction.move(
            to: CGPoint(x: frame.midX, y: frame.midY),
            duration: 0.25
        )

        dice.run(moveDiceToCenter)

        instructionLabel.text = "Drumroll please..."
        instructionLabel.fontSize = 28
        instructionLabel.fontColor = Colors.red.uiColor

        addChild(instructionLabel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.presentChallenge()
        }
    }

    private func presentChallenge() {
        
    }

#if DEBUG
    @objc func simulateShake() {
        if isRolling {
            continueRollingDice()
        } else {
            isRolling = true
            continueRollingDice()
        }

        handleStopRolling()
    }
#endif

    override func willMove(from view: SKView) {
        motionManager.stopAccelerometerUpdates()

#if DEBUG
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
#endif
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiceScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Retrieve the nodes involved in the collision
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        if nodeA == dice || nodeB == dice {
            hapticGenerator.impactOccurred()
        }
    }
}
