//
//  BlockView.swift
//  Peggle
//
//  Created by Marcus on 26/2/21.
//

import SwiftUI

struct BlockView: View {
    var rect: RectangularBlock

    @State var offset = CGSize.zero
    @State var isDragged = false
    @State var lastValidBlock: RectangularBlock?

    let minDragDistance: CGFloat = 10

    private var centerX: CGFloat {
        rect.position.x // + (rect.width / 2)
    }

    private var centerY: CGFloat {
        rect.position.y // + (rect.height / 2)
    }

    @ObservedObject var level: LevelManager
    private var selectedButton: ActionButton {
        palette.selectedButton
    }
    @ObservedObject var palette: PaletteManager

    var body: some View {
        getBlockImage()
            .offset(y: offset.height)
            .offset(x: offset.width)
            .onTapGesture {
                palette.unsetEditBody()
                if selectedButton == .deletePeg {
                    deleteBlock(rect)
                } else if selectedButton == .editItem {
                    palette.setEditBody(to: rect)
                }
            }
            .onLongPressGesture {
                palette.unsetEditBody()
                deleteBlock(rect)
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
        let newBlock = getFutureImage(at: offset)
        if level.canAddBlock(newBlock) {
            lastValidBlock = newBlock
        }
    }

    private func endShift(at translation: CGSize) {
        isDragged = false
        offset = translation
        shiftBlock(by: offset)
        offset = CGSize.zero
    }

    private func shiftBlock(by offset: CGSize) {
        let newBlock = getFutureImage(at: offset)
        if level.canAddBlock(newBlock) {
            level.deleteBlock(rect)
            level.addBlock(newBlock)
            lastValidBlock = newBlock
        } else if let nextValidBlock = lastValidBlock {
            level.deleteBlock(rect)
            level.addBlock(nextValidBlock)
        }
    }

    private func deleteBlock(_ block: RectangularBlock) {
        level.deleteBlock(block)
    }

    private func getBlockImage() -> some View {
        Image("block-blackborder")
            .resizable()
            .rotationEffect(.degrees(Double(rect.angle)), anchor: .center)
            .frame(width: rect.width, height: rect.height)
            .position(x: centerX, y: centerY)
            .opacity(opacityValue)
            .zIndex(zIndexValue)
            .padding(.zero)
    }

    private func getFutureImage(at offset: CGSize) -> RectangularBlock {
        let y = offset.height + rect.position.y
        let x = offset.width + rect.position.x
        let width = rect.width
        let height = rect.height
        let id = rect.id
        let angle = rect.angle
        return RectangularBlock(x: x, y: y, width: width, height: height, id: id, angle: angle)
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

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(rect: RectangularBlock(x: 50, y: 100, width: 50, height: 100),
                  level: LevelManager(), palette: PaletteManager())
    }
}
