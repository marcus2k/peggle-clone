//
//  PegColor.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

enum PegColor: String, Codable {
    case orange = "peg-orange"
    case blue = "peg-blue"
    case green = "peg-green"
    case grey = "peg-grey"

    func getImageName() -> String {
        rawValue
    }
}
