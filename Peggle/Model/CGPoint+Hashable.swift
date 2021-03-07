//
//  CGPoint+Hashable.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

import SwiftUI

extension CGPoint: Hashable {
    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(Double(x))
        hasher.combine(Double(x))
    }

    func getSquaredDistanceTo(point: CGPoint) -> CGFloat {
        let horizontalDist = x - point.x
        let verticalDist = y - point.y
        let distSquared = pow(horizontalDist, 2) + pow(verticalDist, 2)
        return distSquared
    }
}
