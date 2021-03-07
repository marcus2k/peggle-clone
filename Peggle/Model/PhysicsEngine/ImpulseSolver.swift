//
//  ImpulseSolver.swift
//  Peggle
//
//  Created by Marcus on 27/2/21.
//

import SwiftUI

struct ImpulseSolver {
    private let pairwiseRestitutionCoefficient: CGFloat = 0.9

    private func getPairwiseCollisionImpulse(_ first: RectangularBody,
                                             _ second: CircularBody,
                                             normal: Vector) -> Vector? {
        let relativeVelocity = second.velocity.subtract(by: first.velocity)
        let unitNormal = normal.normalize()
        let speedAlongNormal = relativeVelocity.dot(with: unitNormal)
        if speedAlongNormal > 0 {
            return nil
        }
        let sumOfInversedMasses = 1 / first.mass + 1 / second.mass
        let impulseMagnitude = -(1 + pairwiseRestitutionCoefficient)
            * speedAlongNormal / sumOfInversedMasses
        let impulse = unitNormal.multiply(by: impulseMagnitude)
        return impulse
    }

    func getPairwiseCollisionImpulse(_ first: RigidBody,
                                     _ second: RigidBody,
                                     normal: Vector) -> Vector? {
        if let firstCircle = first as? CircularBody, let secondCircle = second as? CircularBody {
            return getPairwiseCollisionImpulse(firstCircle, secondCircle, normal: normal)
        }
        if let rect = first as? RectangularBody, let circle = second as? CircularBody {
            return getPairwiseCollisionImpulse(rect, circle, normal: normal)
        }
        if let circle = first as? CircularBody, let rect = second as? RectangularBody {
            return getPairwiseCollisionImpulse(rect, circle, normal: normal)?.multiply(by: -1)
        }
        return nil
    }

    private func getPairwiseCollisionImpulse(_ first: CircularBody,
                                             _ second: CircularBody,
                                             normal: Vector) -> Vector? {
        let relativeVelocity = second.velocity.subtract(by: first.velocity)
        let unitNormal = normal.normalize()
        let speedAlongNormal = relativeVelocity.dot(with: unitNormal)
        if speedAlongNormal > 0 {
            return nil
        }
        let sumOfInversedMasses = 1 / first.mass + 1 / second.mass
        let impulseMagnitude = -(1 + pairwiseRestitutionCoefficient)
            * speedAlongNormal / sumOfInversedMasses
        let impulse = unitNormal.multiply(by: impulseMagnitude)
        return impulse
    }

}
