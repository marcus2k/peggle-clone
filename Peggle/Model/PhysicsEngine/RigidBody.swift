//
//  RigidBody.swift
//  Peggle
//
//  Created by Marcus on 3/2/21.
//

import SwiftUI

protocol RigidBody {
    var velocity: Vector { get set }
    var position: Vector { get set }
    var forces: [Vector] { get set }
    var mass: CGFloat { get }
    var angle: CGFloat { get set } // degrees
    var isPhaseable: Bool { get set }

    mutating func setVelocity(to velocity: Vector)
    mutating func setPosition(to position: Vector)
    mutating func addForce(_ force: Vector)
    func getBoundingBox() -> CGRect
    mutating func translateBy(x: CGFloat, y: CGFloat)
    mutating func setAngle(to angle: CGFloat)
    mutating func setPhaseable()
    mutating func setUnphaseable()
}
