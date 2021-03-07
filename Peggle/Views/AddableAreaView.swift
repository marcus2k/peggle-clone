//
//  AddableAreaView.swift
//  Peggle
//
//  Created by Marcus on 25/1/21.
//

import SwiftUI

struct AddableAreaView: View {
    // var bounds: CGRect
    @ObservedObject var level: LevelManager
    private var button: ActionButton {
        palette.selectedButton
    }
    @ObservedObject var palette: PaletteManager

    var body: some View {
        let tapGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { gesture in
                    tapHandler(gesture.location)
                }
        return Rectangle()
            .opacity(.leastNonzeroMagnitude)
            .frame(minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .topLeading)
            .gesture(tapGesture)
    }

    private func tapHandler(_ point: CGPoint) {
        if button == .deletePeg || button == .editItem {
            palette.unsetEditBody()
            return
        } else if button == .addOrangePeg
                    || button == .addBluePeg
                    || button == .addGreenPeg
                    || button == .addGreyPeg {
            guard let color = button.getPegColor() else {
                return
            }
            let peg = CircularPeg(color: color, center: point)
            guard level.canAddPeg(peg) else {
                return
            }
            addPeg(peg)
        } else if button == .addBlock {
            let initWidth: CGFloat = 50
            let initHeight: CGFloat = 30
            let block = RectangularBlock(x: point.x,
                                         y: point.y,
                                         width: initWidth,
                                         height: initHeight)
            guard level.canAddBlock(block) else {
                return
            }
            level.addBlock(block)
        }
    }

    private func addPeg(_ peg: CircularPeg) {
        level.addPeg(peg)
    }
}

struct AddableAreaView_Previews: PreviewProvider {
    static var previews: some View {
        AddableAreaView(level: LevelManager(), palette: PaletteManager())
    }
}
