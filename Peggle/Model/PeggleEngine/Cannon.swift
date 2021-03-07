//
//  Cannon.swift
//  Peggle
//
//  Created by Marcus on 8/2/21.
//

import Foundation

struct Cannon {
    var angle: Double = 0
    var isLoaded = true

    mutating func setAngle(to angle: Double) {
        switch angle {
        case -90...90:
            self.angle = angle
        case ..<(-90):
            self.angle = -90
        default:
            self.angle = 90
        }
    }

    mutating func load() {
        self.isLoaded = true
    }

    mutating func unload() {
        self.isLoaded = false
    }
}
