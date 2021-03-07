//
//  CollisionDetector.swift
//  Peggle
//
//  Created by Marcus on 21/2/21.
//

import SwiftUI

struct CollisionDetector {
    func getCollisionNormalBetween(_ first: RigidBody, _ second: RigidBody) -> Vector? {
        if !first.getBoundingBox().intersects(second.getBoundingBox()) {
            return nil
        }
        if first.isPhaseable || second.isPhaseable {
            return nil
        }
        if let first = first as? CircularBody, let second = second as? CircularBody {
            return getCollisionNormalBetween(first, second)
        } else if let first = first as? RectangularBody, let second = second as? CircularBody {
            return getCollisionNormalBetween(first, second)
        } else if let first = first as? CircularBody, let second = second as? RectangularBody {
            return getCollisionNormalBetween(second, first)?.multiply(by: -1)
        } /* else if let first = first as? RectangularBody, let second = second as? RectangularBody {
            return pairIsColliding(first, second)
        } */
        return nil
    }

    private func getCollisionNormalBetween(_ first: CircularBody, _ second: CircularBody) -> Vector? {
        let squaredSumOfRadii = pow(first.radius + second.radius, 2)
        let normal = second.position.subtract(by: first.position)
        let distSquared = normal.normSquared()
        if distSquared > squaredSumOfRadii {
            return nil
        }
        return normal
        // return distSquared <= pow(sumOfRadii, 2)
    }

    /* private func pairIsColliding(_ first: RectangularBody, _ second: RectangularBody) -> Bool {
        first.getBoundingBox().intersects(second.getBoundingBox())
    } */

    private func getCollisionNormalBetween(_ first: RectangularBody, _ second: CircularBody) -> Vector? {
        let rotatedCirclePoint = second.position.rotate(by: first.angle, about: first.position)
        let centerX = rotatedCirclePoint.x
        let centerY = rotatedCirclePoint.y

        // Nearest point between the two
        let nearestX = max(first.minX, min(centerX, first.maxX))
        let nearestY = max(first.minY, min(centerY, first.maxY))
        let rotatedNearestPoint = Vector(x: nearestX, y: nearestY)
        let nearestPoint = rotatedNearestPoint.rotate(by: -first.angle, about: first.position)

        let normal = second.position.subtract(by: nearestPoint)
        let distSquared = normal.normSquared()
        if distSquared > pow(second.radius, 2) {
            return nil
        }
        return normal
    }

    func isCollidingWithTopWall(bounds: CGRect, _ body: RigidBody) -> Bool {
        body.getBoundingBox().minY <= bounds.minY
    }

    func isCollidingWithLeftWall(bounds: CGRect, _ body: RigidBody) -> Bool {
        body.getBoundingBox().minX <= bounds.minX
    }

    func isCollidingWithRightWall(bounds: CGRect, _ body: RigidBody) -> Bool {
        body.getBoundingBox().maxX >= bounds.maxX
    }
}
