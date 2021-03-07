//
//  LevelListManager.swift
//  Peggle
//
//  Created by Marcus on 29/1/21.
//

import Foundation

class LevelListManager: ObservableObject {
    @Published private(set) var selectedLevel: LevelManager?
    @Published private(set) var levelList = LevelList()
    @Published private(set) var powerUp: PowerUp?
    private let persistence = PersistenceManager()

    init(levelList: LevelList = LevelList()) {
        self.levelList = levelList
    }

    init() {
        if let levelList = persistence.loadLevels() {
            self.levelList = levelList
        } else {
            self.levelList = LevelList()
        }
    }

    var levels: [Level] {
        levelList.levels
    }

    var levelNames: [String] {
        levelList.levelNames
    }

    func setPowerUp(to powerUp: PowerUp?) {
        self.powerUp = powerUp
    }

    func selectLevel(_ level: Level) {
        self.selectedLevel = LevelManager(level: level, powerUp: powerUp)
    }

    func unselectLevel() {
        self.selectedLevel = nil
    }

    func renameLevel(to name: String) -> NameError? {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return .emptyError
        }
        if name.count > 15 {
            return .tooLongError
        }
        let nameExists = levels.contains { level in
            level.name == name && level.id != selectedLevel?.getId()
        }
        if let level = selectedLevel, !nameExists {
            level.renameLevel(to: name)
            return nil
        }
        return .duplicateError
    }

    func deleteLevel(_ level: Level) {
        levelList.delete(level: level)
        _ = saveLevels()
    }

    func addNewLevel() {
        let level = Level(name: "")
        selectedLevel = LevelManager(level: level)
    }

    private func saveLevels() -> Bool {
        persistence.saveLevels(levelList)
    }

    func saveCurrLevel() -> Bool {
        guard let currLevel = selectedLevel else {
            return false
        }
        levelList.add(level: currLevel.level)
        return saveLevels()
    }
}
