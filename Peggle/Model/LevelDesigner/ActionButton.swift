//
//  File.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

enum ActionButton: String {
    case addBluePeg = "peg-blue"
    case addOrangePeg = "peg-orange"
    case addGreenPeg = "peg-green"
    case addBlock = "block"
    case deletePeg = "delete"
    case editItem = "edit"
    case addGreyPeg = "peg-grey"

    func getImageName() -> String {
        rawValue
    }

    func getPegColor() -> PegColor? {
        if rawValue == "peg-blue" {
            return .blue
        }
        if rawValue == "peg-orange" {
            return .orange
        }
        if rawValue == "peg-green" {
            return .green
        }
        if rawValue == "peg-grey" {
            return .grey
        }
        return nil
    }
}
