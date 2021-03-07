//
//  BallView.swift
//  Peggle
//
//  Created by Marcus on 8/2/21.
//

import SwiftUI

struct BallView: View {
    private(set) var ball: Ball

    var body: some View {
        getBallImage()
    }

    private var pegDiameter: CGFloat {
        ball.radius * 2
    }

    private var x: CGFloat {
        ball.position.x
    }

    private var y: CGFloat {
        ball.position.y
    }

    private func getBallImage() -> some View {
        Image(getImageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: pegDiameter)
            .position(x: x, y: y)
            .padding(.zero)
    }

    private func getImageName() -> String {
        "ball-cropped"
    }
}

struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(ball: Ball())
    }
}
