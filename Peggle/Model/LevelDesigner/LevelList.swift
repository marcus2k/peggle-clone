//
//  LevelList.swift
//  Peggle
//
//  Created by Marcus on 29/1/21.
//

import Foundation

struct LevelList: Codable {
    private(set) var levels: [Level] = [Level]()

    var levelNames: [String] {
        levels.map { level in
            level.name
        }
    }

    mutating func delete(level currLevel: Level) {
        let idExists = levels.contains { level in
            currLevel.id == level.id
        }
        if !idExists {
            return
        }
        levels = levels.filter { level in
            level.id != currLevel.id
        }
    }

    mutating func add(level currLevel: Level) {
        let idExists = levels.contains { level in
            currLevel.id == level.id
        }
        if !idExists {
            levels.append(currLevel)
        } else {
            levels = levels.map { level in
                currLevel.id == level.id ? currLevel : level
            }
        }
    }
}
