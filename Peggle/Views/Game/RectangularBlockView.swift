//
//  RectangularBlockView.swift
//  Peggle
//
//  Created by Marcus on 27/2/21.
//

import SwiftUI

struct RectangularBlockView: View {
    private(set) var block: RectangularBlock

    private var centerX: CGFloat {
        block.position.x
    }

    private var centerY: CGFloat {
        block.position.y
    }

    var body: some View {
        ZStack {
            Image(getImageName())
                .resizable()
                .rotationEffect(.degrees(Double(block.angle)), anchor: .center)
                .frame(width: block.width, height: block.height)
                .position(x: centerX, y: centerY)
                .padding(.zero)
        }
    }

    private func getImageName() -> String {
        "block-blackborder"
    }
}

struct RectangularBodyView_Previews: PreviewProvider {
    static var previews: some View {
        RectangularBlockView(block: RectangularBlock(x: 50, y: 100, width: 50, height: 100))
    }
}
