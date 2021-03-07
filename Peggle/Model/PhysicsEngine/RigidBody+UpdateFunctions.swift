//
//  RigidBody+UpdateFunctions.swift
//  Peggle
//
//  Created by Marcus on 8/2/21.
//

import SwiftUI

extension RigidBody {
    mutating func addForce(_ force: Vector) {
        self.forces.append(force)
    }

    mutating func setVelocity(to velocity: Vector) {
        self.velocity = velocity
    }

    mutating func setPosition(to position: Vector) {
        self.position = position
    }

    mutating func translateBy(x: CGFloat = .zero, y: CGFloat = .zero) {
        let translation = Vector(x: x, y: y)
        let newPosition = position.add(by: translation)
        position = newPosition
    }

    mutating func setAngle(to angle: CGFloat) {
        self.angle = angle
    }

    mutating func setPhaseable() {
        self.isPhaseable = true
    }

    mutating func setUnphaseable() {
        self.isPhaseable = false
    }
}
