//
//  CircularBody+BoundingBox.swift
//  Peggle
//
//  Created by Marcus on 13/2/21.
//

import SwiftUI

extension CircularBody {
    func getBoundingBox() -> CGRect {
        let radius = self.radius
        let diameter = radius * 2
        let minX = self.position.x - radius
        let minY = self.position.y - radius
        return CGRect(x: minX, y: minY, width: diameter, height: diameter)
    }
}
