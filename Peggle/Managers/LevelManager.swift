//
//  LevelManager.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

import SwiftUI

class LevelManager: ObservableObject { // ViewModel
    @Published private(set) var level: Level
    @Published var powerUp: PowerUp?

    func setBounds(_ newBounds: CGRect) {
        if level.bounds != newBounds {
            level.setBounds(newBounds)
        }
    }

    func setPowerUp(_ power: PowerUp?) {
        powerUp = power
    }

    func replaceBody(_ before: RigidBody, with after: RigidBody) -> Bool {
        if let oldPeg = before as? CircularPeg,
           let newPeg = after as? CircularPeg {
            if !level.canAdd(peg: newPeg) {
                return false
            }
            deletePeg(oldPeg)
            addPeg(newPeg)
            return true
        } else if let oldBlock = before as? RectangularBlock,
                  let newBlock = after as? RectangularBlock {
            if !level.canAdd(block: newBlock) {
                return false
            }
            deleteBlock(oldBlock)
            addBlock(newBlock)
            return true
        }
        return false // cannot typecast with matching types
    }

    func getId() -> UUID {
        level.id
    }

    func getLevelName() -> String {
        level.name
    }

    var pegs: [CircularPeg] {
        level.pegs
    }

    var blocks: [RectangularBlock] {
        level.blocks
    }

    init(level: Level, powerUp: PowerUp? = nil) {
        self.level = level
        self.powerUp = powerUp
    }

    init() {
        self.level = Level()
    }

    func addPeg(_ peg: CircularPeg) {
        if canAddPeg(peg) {
            level.add(peg: peg)
        }
    }

    func deletePeg(_ peg: CircularPeg) {
        level.delete(peg: peg)
    }

    func resetPegs() {
        level.resetPegs()
    }

    func canAddPeg(_ peg: CircularPeg) -> Bool {
        level.canAdd(peg: peg)
    }

    func canAddBlock(_ block: RectangularBlock) -> Bool {
        level.canAdd(block: block)
    }

    func deleteBlock(_ block: RectangularBlock) {
        level.delete(block: block)
    }

    func addBlock(_ block: RectangularBlock) {
        if canAddBlock(block) {
            level.add(block: block)
        }
    }

    func renameLevel(to name: String) {
        level.rename(to: name)
    }
}
