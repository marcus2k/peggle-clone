//
//  LevelView.swift
//  Peggle
//
//  Created by Marcus on 26/1/21.
//

import SwiftUI

struct LevelView: View {
    @ObservedObject var levelList: LevelListManager
    var palette = PaletteManager()
    @ObservedObject var level: LevelManager
    var gameEngine: PeggleEngineManager

    var body: some View {
        VStack(spacing: 0) {
            GameBoardView(level: level, palette: palette)
            Group {
                PaletteView(palette: palette, level: level)
                NavBarView(levelList: levelList, level: level, gameEngine: gameEngine)
            }
                .background(Color.secondary)
            getBottomScreenPadding(color: .secondary)
        }
    }

    private func getBottomScreenPadding(color: Color) -> some View {
        color
            .edgesIgnoringSafeArea(.bottom)
            .frame(height: .leastNonzeroMagnitude)
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(levelList: LevelListManager(), level: LevelManager(), gameEngine: PeggleEngineManager())
    }
}
