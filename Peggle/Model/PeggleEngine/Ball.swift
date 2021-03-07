//
//  Ball.swift
//  Peggle
//
//  Created by Marcus on 7/2/21.
//

import SwiftUI

struct Ball: CircularBody, Identifiable {
    var velocity: Vector = .zero

    var position: Vector = .zero

    var forces = [Vector]()

    let mass: CGFloat

    let radius: CGFloat

    let id = UUID()

    var angle: CGFloat = .zero

    var isPhaseable = false

    init(position: Vector = .zero) {
        let defaultMass: CGFloat = 15
        self.velocity = .zero
        self.position = position
        self.forces = [Vector]()
        self.mass = defaultMass
        self.radius = 30
    }
}
