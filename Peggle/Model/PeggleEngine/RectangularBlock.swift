//
//  RectangularBlock.swift
//  Peggle
//
//  Created by Marcus on 24/2/21.
//

import SwiftUI

struct RectangularBlock: RectangularBody, Codable, Identifiable {
    var width: CGFloat

    var height: CGFloat

    var velocity: Vector = .zero

    var position: Vector // center

    var forces: [Vector] = [Vector]()

    let mass: CGFloat = .infinity

    var id = UUID()

    var angle: CGFloat = .zero

    var isPhaseable = false

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, id: UUID = UUID(), angle: CGFloat = .zero) {
        self.position = Vector(x: x, y: y)
        self.width = width
        self.height = height
        self.id = id
        self.angle = angle
    }

    private func getCorners() -> [Vector] {
        [Vector(x: minX, y: minY).rotate(by: -angle, about: position),
         Vector(x: minX, y: maxY).rotate(by: -angle, about: position),
         Vector(x: maxX, y: maxY).rotate(by: -angle, about: position),
         Vector(x: maxX, y: minY).rotate(by: -angle, about: position)]
    }

    func overlapsWith(block: RectangularBlock) -> Bool {
        if !getBoundingBox().intersects(block.getBoundingBox()) {
            return false
        }

        let cornersA = getCorners()
        let cornersB = block.getCorners()

        for corners in [[Vector]](arrayLiteral: cornersA, cornersB) {
            for (i, firstCorner) in corners.enumerated() {
                let secondCorner = corners[(i + 1) % corners.count]
                let normal = Vector(x: secondCorner.y - firstCorner.y,
                                    y: firstCorner.x - secondCorner.x)

                var minA: CGFloat?
                var maxA: CGFloat?
                for p in cornersA {
                    let projectedA = normal.dot(with: p)
                    minA = min(projectedA, minA ?? projectedA)
                    maxA = max(projectedA, maxA ?? projectedA)
                }

                var minB: CGFloat?
                var maxB: CGFloat?
                for p in cornersB {
                    let projectedB = normal.dot(with: p)
                    minB = min(projectedB, minB ?? projectedB)
                    maxB = max(projectedB, maxB ?? projectedB)
                }

                if let maxA = maxA, let minB = minB, maxA < minB {
                    return false
                }

                if let maxB = maxB, let minA = minA, maxB < minA {
                    return false
                }
            }
        }
        return true
    }

    mutating func setWidth(to width: CGFloat) {
        self.width = width
    }

    mutating func setHeight(to height: CGFloat) {
        self.height = height
    }

    // Explicitly specified to ignore radius and id from being encoded/decoded
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case position
        case angle
    }
}
