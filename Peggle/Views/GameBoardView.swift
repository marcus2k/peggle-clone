//
//  GameBoardView.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

import SwiftUI

struct GameBoardView: View {
    @ObservedObject var level: LevelManager
    @ObservedObject var palette: PaletteManager

    private var selectedColor: PegColor? {
        palette.selectedButton.getPegColor()
    }

    private var pegs: [CircularPeg] {
        level.pegs
    }

    private var blocks: [RectangularBlock] {
        level.blocks
    }

    var body: some View {
        GeometryReader { geometry in
            initializeGameBoard(bounds: geometry.frame(in: .local))
        }
    }

    private func initializeGameBoard(bounds: CGRect) -> some View {
        level.setBounds(bounds)
        return ZStack {
            AddableAreaView(level: level, palette: palette)
            getPegs()
        }
    }

    private func getPegs() -> some View {
        ZStack {
            ForEach(pegs) { peg in
                getPegView(peg: peg)
            }
            ForEach(blocks) { block in
                getBlockView(block: block)
            }
        }
            .frame(minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .topLeading)
    }

    private func getPegView(peg: CircularPeg) -> some View {
        PegView(peg: peg, level: level, palette: palette)
    }

    private func getBlockView(block: RectangularBlock) -> some View {
        BlockView(rect: block, level: level, palette: palette)
    }
}

struct PegAreaView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(level: LevelManager(), palette: PaletteManager())
    }
}
