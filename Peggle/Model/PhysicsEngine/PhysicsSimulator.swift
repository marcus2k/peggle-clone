//
//  PhysicsSimulator.swift
//  Peggle
//
//  Created by Marcus on 3/2/21.
//

import SwiftUI

struct PhysicsSimulator {
    var bodies: [RigidBody]
    var boundary: CGRect
    var kinematics: KinematicsSolver
    var collision: CollisionSolver
    static let accelerationDueToGravity = Vector(x: 0, y: 200)// 100)

    init(bodies: [RigidBody], boundary: CGRect) {
        self.bodies = bodies
        self.boundary = boundary
        self.collision = CollisionSolver(bounds: boundary)
        self.kinematics = KinematicsSolver()
    }

    mutating func addBody(_ body: RigidBody) {
        self.bodies.append(body)
    }

    mutating func runSimulation(at interval: CFTimeInterval) -> Set<Int> {
        kinematics.updateBodies(&bodies, at: interval)
        let collidingIndices = collision.resolveAllCollisions(for: &bodies)
        return collidingIndices
    }

    mutating func removeExitedBodies() -> [RigidBody] {
        var removedBodies = [RigidBody]()
        bodies = bodies.filter { body in
            if boundary.intersects(body.getBoundingBox()) {
                return true
            }
            removedBodies.append(body)
            return false
        }
        return removedBodies
    }
}
