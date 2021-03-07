//
//  CircularPegView.swift
//  Peggle
//
//  Created by Marcus on 8/2/21.
//

import SwiftUI

struct CircularPegView: View {
    private(set) var peg: CircularPeg

    var body: some View {
        getPegImage()
    }

    private var pegDiameter: CGFloat {
        peg.radius * 2
    }

    private var x: CGFloat {
        peg.position.x
    }

    private var y: CGFloat {
        peg.position.y
    }

    private func getPegImage() -> some View {
        let fadeOut = AnyTransition.opacity.animation(.easeOut(duration: 0.2))
        return Image(getImageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(Double(peg.angle)), anchor: .center)
            .frame(width: pegDiameter)
            .position(x: x, y: y)
            .padding(.zero)
            .transition(.asymmetric(insertion: .identity, removal: fadeOut))
    }

    private func getImageName() -> String {
        var fileName = "peg"
        if peg.color == .orange {
            fileName += "-orange"
        } else if peg.color == .blue {
            fileName += "-blue"
        } else if peg.color == .green {
            fileName += "-green"
        } else if peg.color == .grey {
            fileName += "-grey"
        }
        if peg.isHit {
            fileName += "-glow"
        }
        return fileName
    }
}

struct PegBodyView_Previews: PreviewProvider {
    static var previews: some View {
        getPreview()
    }

    static func getPreview() -> some View {
        var peg = CircularPeg(color: .orange, center: CGPoint(x: 100.0, y: 100.0))
        peg.hit()
        return CircularPegView(peg: peg)
    }
}
