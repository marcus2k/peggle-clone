//
//  PegView.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

import SwiftUI

struct PegView: View {
    private(set) var peg: CircularPeg
    @ObservedObject var level: LevelManager
    private var selectedButton: ActionButton {
        palette.selectedButton
    }
    @ObservedObject var palette: PaletteManager

    @State var offset = CGSize.zero
    @State var isDragged = false
    @State var lastValidPeg: CircularPeg?

    let minDragDistance: CGFloat = 10

    var body: some View {
        getPegImage()
            .offset(y: offset.height)
            .offset(x: offset.width)
            .onTapGesture {
                palette.unsetEditBody()
                if selectedButton == .deletePeg {
                    deletePeg(peg)
                } else if selectedButton == .editItem {
                    palette.setEditBody(to: peg)
                }
            }
            .onLongPressGesture {
                palette.unsetEditBody()
                deletePeg(peg)
            }
            .gesture(DragGesture(minimumDistance: minDragDistance)
                        .onChanged { value in
                            palette.unsetEditBody()
                            dragShiftBy(value.translation)
                        }
                        .onEnded { value in
                            endShift(at: value.translation)
                        }
            )
    }

    private func dragShiftBy(_ translation: CGSize) {
        isDragged = true
        offset = translation
        let newPeg = getFutureImage(peg: peg, by: offset)
        if level.canAddPeg(newPeg) {
            lastValidPeg = newPeg
        }
    }

    private func endShift(at translation: CGSize) {
        isDragged = false
        offset = translation
        shiftPeg(peg, by: offset)
        offset = CGSize.zero
    }

    private func shiftPeg(_ peg: CircularPeg, by offset: CGSize) {
        let newPeg = getFutureImage(peg: peg, by: offset)
        if level.canAddPeg(newPeg) {
            deletePeg(peg)
            addPeg(newPeg)
            lastValidPeg = newPeg
        } else if let nextValidPeg = lastValidPeg {
            deletePeg(peg)
            addPeg(nextValidPeg)
        }
    }

    private func deletePeg(_ peg: CircularPeg) {
        level.deletePeg(peg)
    }

    private func addPeg(_ peg: CircularPeg) {
        level.addPeg(peg)
    }

    private func getFutureImage(peg: CircularPeg, by offset: CGSize) -> CircularPeg {
        let y = offset.height + peg.position.y
        let x = offset.width + peg.position.x
        let point = CGPoint(x: x, y: y)
        let color = peg.color
        let id = peg.id
        return CircularPeg(color: color, center: point, id: id, radius: peg.radius)
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

    var angle: Angle {
        Angle(degrees: Double(peg.angle))
    }

    private func getPegImage() -> some View {
        Image(peg.color.getImageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(angle, anchor: .center)
            .frame(width: pegDiameter)
            .position(x: x, y: y)
            .opacity(opacityValue)
            .zIndex(zIndexValue)
            .padding(.zero)
    }

    private var zIndexValue: Double {
        isDragged ? .leastNonzeroMagnitude : .zero
    }

    private var opacityValue: Double {
        let sixtyPercent = 0.6
        let hundredPercent = 1.0
        return isDragged ? sixtyPercent : hundredPercent
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView(peg: CircularPeg(color: .orange, center: CGPoint(x: 1.0, y: 1.0)),
                level: LevelManager(), palette: PaletteManager()
        )
    }
}
