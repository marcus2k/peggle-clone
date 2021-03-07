//
//  LevelDesignerView.swift
//  Peggle
//
//  Created by Marcus on 29/1/21.
//

import SwiftUI

struct LevelDesignerView: View {
    @ObservedObject var levelList: LevelListManager
    @ObservedObject var gameEngine = PeggleEngineManager()

    var body: some View {
        Group {
            if gameEngine.simulator != nil {
                GameView(gameEngine: gameEngine)
            } else if let selectedLevel = levelList.selectedLevel {
                LevelView(levelList: levelList, level: selectedLevel, gameEngine: gameEngine)
            } else {
                LevelListView(levelList: levelList)
            }
        }
    }
}
