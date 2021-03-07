//
//  RectangularBody+BoundingBox.swift
//  Peggle
//
//  Created by Marcus on 21/2/21.
//

import SwiftUI

extension RectangularBody {
    func getBoundingBox() -> CGRect {
        let cornerOne = Vector(x: minX, y: minY).rotate(by: angle, about: position)
        let cornerTwo = Vector(x: maxX, y: maxY).rotate(by: angle, about: position)
        let cornerThree = Vector(x: minX, y: maxY).rotate(by: angle, about: position)
        let cornerFour = Vector(x: maxX, y: minY).rotate(by: angle, about: position)
        let newMaxX = max(cornerOne.x, cornerTwo.x, cornerThree.x, cornerFour.x)
        let newMinX = min(cornerOne.x, cornerTwo.x, cornerThree.x, cornerFour.x)
        let newMaxY = max(cornerOne.y, cornerTwo.y, cornerThree.y, cornerFour.y)
        let newMinY = min(cornerOne.y, cornerTwo.y, cornerThree.y, cornerFour.y)
        return CGRect(x: newMinX,
                      y: newMinY,
                      width: newMaxX - newMinX,
                      height: newMaxY - newMinY)
    }

    private var halfWidth: CGFloat {
        width / 2
    }

    private var halfHeight: CGFloat {
        height / 2
    }

    var minX: CGFloat {
        position.x - halfWidth
    }

    var minY: CGFloat {
        position.y - halfHeight
    }

    var maxX: CGFloat {
        position.x + halfWidth
    }

    var maxY: CGFloat {
        position.y + halfHeight
    }
}
