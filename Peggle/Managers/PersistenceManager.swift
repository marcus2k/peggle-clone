//
//  PersistenceManager.swift
//  Peggle
//
//  Created by Marcus on 27/1/21.
//

import Foundation

struct PersistenceManager {
    private func getFileURL(from name: String, with extension: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(name).appendingPathExtension(`extension`)
    }

    func saveLevels(_ levels: LevelList) -> Bool {
        let fileURL = getFileURL(from: "data", with: "json")
        do {
            let json = try JSONEncoder().encode(levels)
            try json.write(to: fileURL)
            return true
        } catch {
            print(error)
        }
        return false
    }

    func loadLevels() -> LevelList? {
        let fileURL = getFileURL(from: "data", with: "json")
        do {
            let data = try Data(contentsOf: fileURL)
            if let level = try? JSONDecoder().decode(LevelList.self, from: data) {
                return level
            }
        } catch {
            print(error)
        }
        return nil
    }
}
