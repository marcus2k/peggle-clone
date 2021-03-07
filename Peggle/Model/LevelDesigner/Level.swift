//
//  Level.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct Level: Codable, Identifiable {
    private(set) var name = ""
    private(set) var pegs: [CircularPeg] = [CircularPeg]()
    private(set) var blocks: [RectangularBlock] = [RectangularBlock]()
    private(set) var id = UUID()
    private(set) var bounds = CGRect(x: 0, y: 0, width: 768, height: 826)

    mutating func setBounds(_ newBounds: CGRect) {
        bounds = newBounds
    }

    private func isWithinBounds(peg: CircularPeg) -> Bool {
        let x = peg.position.x
        let y = peg.position.y
        let radius = peg.radius

        let leftBounded = bounds.contains(CGPoint(x: x - radius, y: y))
        let rightBounded = bounds.contains(CGPoint(x: x + radius, y: y))
        let upperBounded = bounds.contains(CGPoint(x: x, y: y + radius))
        let lowerBounded = bounds.contains(CGPoint(x: x, y: y - radius))

        return leftBounded && rightBounded && upperBounded && lowerBounded
    }

    private func isWithinBounds(block: RectangularBlock) -> Bool {
        bounds.contains(block.getBoundingBox())
    }

    mutating func add(peg: CircularPeg) {
        if !canAdd(peg: peg) {
            return
        }
        pegs.append(peg)
    }

    mutating func delete(peg: CircularPeg) {
        pegs = pegs.filter { item in
            item.id != peg.id
        }
    }

    mutating func resetPegs() {
        pegs = [CircularPeg]()
        blocks = [RectangularBlock]()
    }

    func canAdd(peg: CircularPeg) -> Bool {
        for p in pegs {
            if p.overlapsWith(peg: peg) && p.id != peg.id {
                return false
            }
        }
        for b in blocks {
            if peg.overlapsWith(block: b) {
                return false
            }
        }
        return isWithinBounds(peg: peg)
    }

    func canAdd(block: RectangularBlock) -> Bool {
        for p in pegs {
            if p.overlapsWith(block: block) {
                return false
            }
        }
        for b in blocks {
            if block.overlapsWith(block: b) && block.id != b.id {
                return false
            }
        }
        return isWithinBounds(block: block)
    }

    mutating func delete(block: RectangularBlock) {
        blocks = blocks.filter { b in
            b.id != block.id
        }
    }

    mutating func add(block: RectangularBlock) {
        if !canAdd(block: block) {
            return
        }
        blocks.append(block)
    }

    mutating func rename(to newName: String) {
        name = newName
    }

    // Explicitly specified to ignore id from being encoded/decoded
    private enum CodingKeys: String, CodingKey {
        case name
        case pegs
        case blocks
    }
}
