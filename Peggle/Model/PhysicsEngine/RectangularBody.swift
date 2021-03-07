//
//  RectangularBody.swift
//  Peggle
//
//  Created by Marcus on 21/2/21.
//

import SwiftUI

protocol RectangularBody: RigidBody {
    var width: CGFloat { get set }
    var height: CGFloat { get set }
}
