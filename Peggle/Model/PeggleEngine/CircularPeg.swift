//
//  CircularPeg.swift
//  Peggle
//
//  Created by Marcus on 7/2/21.
//

import SwiftUI

struct CircularPeg: CircularBody, Identifiable, Codable {
    var velocity: Vector = .zero

    var position: Vector

    var forces: [Vector] = [Vector]()

    let mass: CGFloat = .infinity

    var radius: CGFloat

    var id = UUID()

    var isHit = false

    var color: PegColor

    var angle: CGFloat = .zero

    var isPhaseable = false

    var hiddenColor: PegColor?

    init(color: PegColor, center: CGPoint, id: UUID = UUID(), radius: CGFloat = 20) {
        let center = Vector(x: center.x, y: center.y)
        self.position = center
        self.radius = radius
        self.color = color
        self.id = id
    }

    mutating func initializeHiddenColor() {
        if color != .grey || isHit {
            return
        }
        hiddenColor = getHiddenColor()
    }

    private mutating func getHiddenColor() -> PegColor {
        let randNum = Double.random(in: 0...1)
        let orangeChance = 0.5
        let blueChance = 0.96
        if randNum < orangeChance {
            return .orange // 50% chance
        } else if randNum < blueChance {
            return .blue // 46 % chance
        } else {
            return .green // 4 % chance
        }
    }

    mutating func hit() {
        if let newColor = hiddenColor, color == .grey {
            color = newColor
            hiddenColor = nil
        } else {
            isHit = true
        }
    }

    func contains(point: Vector) -> Bool {
        position.subtract(by: point).normSquared() <= pow(radius, 2)
    }

    func overlapsWith(peg: CircularPeg) -> Bool {
        position.subtract(by: peg.position).normSquared() < pow(radius + peg.radius, 2)
    }

    func overlapsWith(block: RectangularBlock) -> Bool {
        if !getBoundingBox().intersects(block.getBoundingBox()) {
            return false
        }
        let rotatedCirclePoint = position.rotate(by: block.angle, about: block.position)
        let centerX = rotatedCirclePoint.x
        let centerY = rotatedCirclePoint.y

        // Nearest point between the two
        let nearestX = max(block.minX, min(centerX, block.maxX))
        let nearestY = max(block.minY, min(centerY, block.maxY))
        let rotatedNearestPoint = Vector(x: nearestX, y: nearestY)
        let nearestPoint = rotatedNearestPoint.rotate(by: -block.angle, about: block.position)

        let normal = position.subtract(by: nearestPoint)
        let distSquared = normal.normSquared()
        return distSquared <= pow(radius, 2)
    }

    mutating func setRadius(to radius: CGFloat) {
        self.radius = radius
    }

    // Explicitly specified to ignore radius and id from being encoded/decoded
    private enum CodingKeys: String, CodingKey {
        case position
        case radius
        case color
        case angle
    }
}
