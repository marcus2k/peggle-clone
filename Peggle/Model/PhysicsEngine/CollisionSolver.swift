//
//  CollisionSolver.swift
//  Peggle
//
//  Created by Marcus on 5/2/21.
//

import SwiftUI

struct CollisionSolver {
    private let collisionDetector = CollisionDetector()
    private let impulseSolver = ImpulseSolver()
    private let wallRestitutionCoefficient: CGFloat = 0.95
    var bounds: CGRect

    func resolveAllCollisions(for bodies: inout [RigidBody]) -> Set<Int> {
        let collidingIndices = resolveAllPairwiseCollisions(for: &bodies)
        resolveAllBoundaryCollisions(for: &bodies)
        return collidingIndices
    }

    private func resolveAllBoundaryCollisions(for bodies: inout [RigidBody]) {
        for (i, var body) in bodies.enumerated() {
            resolveTopWallCollision(for: &body)
            resolveLeftWallCollision(for: &body)
            resolveRightWallCollision(for: &body)
            bodies[i] = body
        }
    }

    private func resolveTopWallCollision(for body: inout RigidBody) {
        if !collisionDetector.isCollidingWithTopWall(bounds: bounds, body) {
            return
        }
        let bodyTop = body.getBoundingBox().minY
        let boundsTop = bounds.minY
        body.translateBy(y: boundsTop - bodyTop)
        body.setVelocity(to: body.velocity.verticalFlip().multiply(by: wallRestitutionCoefficient))
    }

    private func resolveLeftWallCollision(for body: inout RigidBody) {
        if !collisionDetector.isCollidingWithLeftWall(bounds: bounds, body) {
            return
        }
        let bodyLeft = body.getBoundingBox().minX
        let boundsLeft = bounds.minX
        body.translateBy(x: boundsLeft - bodyLeft)
        let velocity = body.velocity.horizontalFlip()
        body.setVelocity(to: velocity.multiply(by: wallRestitutionCoefficient))
    }

    private func resolveRightWallCollision(for body: inout RigidBody) {
        if !collisionDetector.isCollidingWithRightWall(bounds: bounds, body) {
            return
        }
        let bodyRight = body.getBoundingBox().maxX
        let boundsRight = bounds.maxX
        body.translateBy(x: boundsRight - bodyRight)
        let velocity = body.velocity.horizontalFlip()
        body.setVelocity(to: velocity.multiply(by: wallRestitutionCoefficient))
    }

    private func resolveAllPairwiseCollisions(for bodies: inout [RigidBody]) -> Set<Int> {
        var collidingIndices = Set<Int>()
        for (i, body) in bodies.enumerated() {
            let nextIndex = i + 1
            for k in nextIndex..<bodies.count {
                var first = body
                var second = bodies[k]
                guard let collisionNormal = collisionDetector
                        .getCollisionNormalBetween(first, second) else {
                    continue
                }
                resolvePairwiseCollision(&first, &second, normal: collisionNormal)
                adjustPairPositions(&first, &second, normal: collisionNormal)
                collidingIndices.insert(i)
                collidingIndices.insert(k)
                bodies[i] = first
                bodies[k] = second
            }
        }
        return collidingIndices
    }

    private func resolvePairwiseCollision(_ first: inout RigidBody,
                                          _ second: inout RigidBody,
                                          normal: Vector) {
        guard let impulse = impulseSolver.getPairwiseCollisionImpulse(first,
                                                                      second,
                                                                      normal: normal)
        else {
            return
        }
        let frictionFactor: CGFloat = 0.8 // to somewhat simulate energy loss
        let firstVelocityChange = impulse.multiply(by: frictionFactor / first.mass)
        let secondVelocityChange = impulse.multiply(by: frictionFactor / second.mass)
        first.velocity = first.velocity.subtract(by: firstVelocityChange)
        second.velocity = second.velocity.add(by: secondVelocityChange)
    }

    private func adjustPairPositions(_ first: inout RigidBody,
                                     _ second: inout RigidBody,
                                     normal: Vector) {
        /* guard let normal = getNormalBetween(first, second) else {
            return
        } */
        let penetrationDepth = getPenetrationDepth(first, second, normal: normal)
        let treshold: CGFloat = 0.01
        if penetrationDepth < treshold {
            // no penetration or small penetration due to floating point error
            return
        }
        let unitNormal = normal.normalize()
        let totalShiftVector = unitNormal.multiply(by: penetrationDepth)

        let firstInversedMass = 1 / first.mass
        let secondInversedMass = 1 / second.mass
        let sumOfInversedMass = firstInversedMass + secondInversedMass
        let firstShiftFactor = firstInversedMass / sumOfInversedMass
        let secondShiftFactor = secondInversedMass / sumOfInversedMass

        let firstShiftVector = totalShiftVector.multiply(by: firstShiftFactor)
        let secondShiftVector = totalShiftVector.multiply(by: secondShiftFactor)

        let firstNewPosition = first.position.subtract(by: firstShiftVector)
        let secondNewPosition = second.position.add(by: secondShiftVector)

        first.setPosition(to: firstNewPosition)
        second.setPosition(to: secondNewPosition)
    }

    private func getPenetrationDepth(_ first: CircularBody,
                                     _ second: CircularBody,
                                     normal: Vector) -> CGFloat {
        let sumOfRadiiSquared = first.radius + second.radius
        let normalLength = normal.normSquared().squareRoot()
        return sumOfRadiiSquared - normalLength
    }

    private func getPenetrationDepth(_ first: RigidBody,
                                     _ second: RigidBody,
                                     normal: Vector) -> CGFloat {
        if let firstCircle = first as? CircularBody, let secondCircle = second as? CircularBody {
            return getPenetrationDepth(firstCircle, secondCircle, normal: normal)
        }
        if let rect = first as? RectangularBody, let circle = second as? CircularBody {
            return getPenetrationDepth(rect, circle, normal: normal)
        }
        if let circle = first as? CircularBody, let rect = second as? RectangularBody {
            return getPenetrationDepth(rect, circle, normal: normal)
        }
        return .zero
    }

    private func getPenetrationDepth(_ first: RectangularBody,
                                     _ second: CircularBody,
                                     normal: Vector) -> CGFloat {
        let normalLength = normal.normSquared().squareRoot()
        return second.radius - normalLength
    }
}
