//
//  NavBarView.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct NavBarView: View {
    @ObservedObject var levelList: LevelListManager
    @ObservedObject var level: LevelManager
    @ObservedObject var gameEngine: PeggleEngineManager

    @State private(set) var levelName: String

    init(levelList: LevelListManager, level: LevelManager, gameEngine: PeggleEngineManager) {
        self.levelList = levelList
        self.level = level
        self.gameEngine = gameEngine
        _levelName = State(initialValue: level.getLevelName())
    }

    init(gameEngine: PeggleEngineManager) {
        self.gameEngine = gameEngine
        self.level = LevelManager()
        self.levelList = LevelListManager()
        _levelName = State(initialValue: "")
    }

    var body: some View {
        if gameEngine.simulator != nil {
            HStack {
                Text("BALLS LEFT: \(gameEngine.chances.counter)")
                    .foregroundColor(Color.black)
                Spacer()
                getButton(label: "QUIT GAME") {
                    levelList.unselectLevel()
                    gameEngine.unloadGame()
                    denotify()
                }
            }
                .padding()
        } else if levelList.selectedLevel != nil {
            HStack {
                getButton(label: "LOAD") {
                    denotify()
                    levelList.unselectLevel()
                }
                getButton(label: "SAVE") {
                    if let invalidMsg = levelList.renameLevel(to: levelName)?.rawValue {
                        notify(invalidMsg)
                    } else {
                        if levelList.saveCurrLevel() {
                            notify("Successfully saved!")
                        } else {
                            notify("Unable to save!")
                        }
                    }
                }
                getButton(label: "RESET") {
                    denotify()
                    resetLevel()
                }
                getLevelNameField()
                getButton(label: "START") {
                    denotify()
                    gameEngine.loadGame(level: level.level, powerUp: level.powerUp)
                }
            }
                .padding()
        }
    }

    private func denotify() {
        NotificationManager
            .default
            .removeNotification()
    }

    private func notify(_ notif: String) {
        NotificationManager
            .default
            .setNotification(to: notif)
    }

    private func resetLevel() {
        level.resetPegs()
    }

    private func getLevelNameField() -> some View {
        TextField("Enter a Level Name", text: $levelName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.twitter)
            .disableAutocorrection(true)
    }

    private func getButton(label: String, action: @escaping () -> Void) -> some View {
        Button(label, action: action)
            .foregroundColor(Color.black)
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavBarView(levelList: LevelListManager(), level: LevelManager(), gameEngine: PeggleEngineManager())
        }
    }
}
