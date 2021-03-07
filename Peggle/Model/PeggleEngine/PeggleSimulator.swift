//
//  PeggleSimulator.swift
//  Peggle
//
//  Created by Marcus on 7/2/21.
//

import SwiftUI

struct PeggleSimulator {
    var physics: PhysicsSimulator
    private var lastBallLocation = Vector.zero
    private var locationCount: Double = .zero
    var powerUp: PowerUp?
    var powerUpActive: Bool = false
    var bodies: [RigidBody] {
        physics.bodies
    }

    mutating func setPowerUp(to power: PowerUp) {
        self.powerUp = power
    }

    init(level: Level) {
        var bodies = [RigidBody]()
        let processedPegs: [CircularPeg] = level.pegs.map { peg in
            var pegCopy = peg
            pegCopy.initializeHiddenColor()
            return pegCopy
        }
        bodies.append(contentsOf: processedPegs)
        bodies.append(contentsOf: level.blocks)
        self.physics = PhysicsSimulator(bodies: bodies, boundary: level.bounds)
    }

    mutating func setBounds(to bounds: CGRect) {
        physics.boundary = bounds
        physics.collision.bounds = bounds
    }

    mutating func launchBall(velocity: Vector) {
        setBlocksToUnphaseable()
        var ball = Ball()
        let position = Vector(x: physics.boundary.maxX / 2, y: ball.radius)
        let gravity = PhysicsSimulator.accelerationDueToGravity.multiply(by: ball.mass)
        lastBallLocation = position
        locationCount = .zero
        ball.addForce(gravity)
        ball.setVelocity(to: velocity)
        ball.setPosition(to: position)
        physics.addBody(ball)
    }

    mutating func runSimulation(at interval: CFTimeInterval) {
        let collidingIndices = physics.runSimulation(at: interval)
        let removedBodies = physics.removeExitedBodies()
        var prematureDeletion = false
        for i in collidingIndices {
            if i >= bodies.count {
                continue
            }
            if var body = bodies[i] as? CircularPeg {
                if body.color == .green, !body.isHit {
                    handleGreenPegHit(body: body)
                }
                body.hit()
                physics.bodies[i] = body
            } else if let body = bodies[i] as? Ball {
                prematureDeletion = prematurelyRemovePegs(ball: body)
            }
        }
        for body in removedBodies {
            if !powerUpActive || powerUp != .spookyBall {
                break
            }
            if var ball = body as? Ball {
                let topPosition = Vector(x: ball.position.x, y: 0)
                ball.setPosition(to: topPosition)
                physics.bodies.append(ball)
                deactivatePowerUp()
            }
        }
        if prematureDeletion {
            setCollidingBlocksToPhaseable(indices: collidingIndices)
            _ = removeLitPegs()
            locationCount = .zero
        }
    }

    mutating func revealGreyPegColors() {
        physics.bodies = bodies.map { body in
            if var peg = body as? CircularPeg, peg.color == .grey {
                peg.hit()
                return peg
            }
            return body
        }
    }

    private mutating func setBlocksToUnphaseable() {
        physics.bodies = physics.bodies.map { body in
            var rect = body as? RectangularBlock
            rect?.setUnphaseable()
            return rect ?? body
        }
    }

    private mutating func handleGreenPegHit(body: CircularPeg) {
        if let powerUp = powerUp {
            switch powerUp {
            case .spaceBlast:
                lightenPegs(near: body.position)
            case .spookyBall:
                activatePowerUp()
            }
        }
    }

    private mutating func activatePowerUp() {
        if powerUp == nil {
            powerUpActive = false
            return
        }
        powerUpActive = true
    }

    private mutating func deactivatePowerUp() {
        powerUpActive = false
    }

    private mutating func lightenPegs(near pos: Vector) {
        let treshold: CGFloat = 22_500
        physics.bodies = physics.bodies.map { body in
            if var peg = body as? CircularPeg {
                let distSquared = peg.position.subtract(by: pos).normSquared()
                if distSquared > treshold {
                    return peg
                }
                peg.hit()
                return peg
            }
            return body
        }
    }

    private mutating func prematurelyRemovePegs(ball: Ball) -> Bool {
        let distSquared = Double(ball.position.subtract(by: lastBallLocation).normSquared())
        let minimumDistSquared = 0.01
        if distSquared < minimumDistSquared {
            locationCount += 1
            let maximumSameLocationCount: Double = 50
            if locationCount >= maximumSameLocationCount {
                return true
            }
        }
        lastBallLocation = ball.position
        return false
    }

    mutating func setCollidingBlocksToPhaseable(indices: Set<Int>) {
        for i in indices {
            if var body = bodies[i] as? RectangularBlock {
                body.setPhaseable()
                physics.bodies[i] = body
            }
        }
    }

    func ballStillExists() -> Bool {
        var ballStillExists = false
        for body in bodies where body as? Ball != nil {
            ballStillExists = true
            break
        }
        return ballStillExists
    }

    mutating func removeLitPegs() -> Bool {
        var orangePegStillExists = false
        physics.bodies = bodies.filter { body in
            if let body = body as? CircularPeg {
                if body.isHit {
                    return false
                } else if body.color == .orange || body.hiddenColor == .orange {
                    // orange peg is not hit
                    orangePegStillExists = true
                }
            }
            return true
        }
        return orangePegStillExists
    }
}
