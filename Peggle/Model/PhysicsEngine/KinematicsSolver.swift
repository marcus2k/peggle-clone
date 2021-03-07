//
//  KinematicsSolver.swift
//  Peggle
//
//  Created by Marcus on 5/2/21.
//

import SwiftUI

struct KinematicsSolver {
    private func getAcceleration(_ body: RigidBody) -> Vector {
        let netForce = body.forces.reduce(Vector.zero) { first, second in
            first.add(by: second)
        }
        let acceleration = netForce.multiply(by: 1 / body.mass)
        return acceleration
    }

    func updateBodies(_ bodies: inout [RigidBody], at interval: CFTimeInterval) {
        for i in 0..<bodies.count {
            updateBody(&bodies[i], at: interval)
        }
    }

    private func updateBody(_ body: inout RigidBody, at interval: CFTimeInterval) {
        if body.mass == .infinity {
            return
        }
        let acceleration = getAcceleration(body)
        let velocity = body.velocity.add(by: acceleration.multiply(by: CGFloat(interval)))
        let position = body.position.add(by: velocity.multiply(by: CGFloat(interval)))

        body.setVelocity(to: velocity)
        body.setPosition(to: position)
    }
}
