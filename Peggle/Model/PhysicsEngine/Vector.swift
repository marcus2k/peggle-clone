//
//  Vector.swift
//  Peggle
//
//  Created by Marcus on 3/2/21.
//

import SwiftUI

struct Vector: Hashable, Identifiable, Codable {
    static let zero = Vector(x: 0, y: 0)
    let x: CGFloat
    let y: CGFloat
    let id = UUID()

    func dot(with vector: Vector) -> CGFloat {
        x * vector.x + y * vector.y
    }

    func add(by vector: Vector) -> Vector {
        Vector(x: x + vector.x, y: y + vector.y)
    }

    func subtract(by vector: Vector) -> Vector {
        Vector(x: x - vector.x, y: y - vector.y)
    }

    func normSquared() -> CGFloat {
        self.dot(with: self)
    }

    func normalize() -> Vector {
        let length = self.normSquared().squareRoot()
        return self.multiply(by: 1 / length)
    }

    func multiply(by scalar: CGFloat) -> Vector {
        Vector(x: x * scalar, y: y * scalar)
    }

    func horizontalFlip() -> Vector {
        Vector(x: -x, y: y)
    }

    func verticalFlip() -> Vector {
        Vector(x: x, y: -y)
    }

    func rotate(by angle: CGFloat, about pivot: Vector) -> Vector {
        let angleInRadians = Double(2 * .pi - angle * .pi / 180)
        let firstXTerm = Double(x - pivot.x) * cos(angleInRadians)
        let secondXTerm = Double(y - pivot.y) * sin(angleInRadians)
        let firstYTerm = Double(x - pivot.x) * sin(angleInRadians)
        let secondYTerm = Double(y - pivot.y) * cos(angleInRadians)
        let x = firstXTerm - secondXTerm + Double(pivot.x)
        let y = firstYTerm + secondYTerm + Double(pivot.y)
        return Vector(x: CGFloat(x), y: CGFloat(y))
    }

    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(id)
    }

    // Explicitly specified to ignore radius and id from being encoded/decoded
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}
