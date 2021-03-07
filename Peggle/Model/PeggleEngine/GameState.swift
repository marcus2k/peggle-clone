//
//  GameState.swift
//  Peggle
//
//  Created by Marcus on 21/2/21.
//

import Foundation

enum GameState: String {
    case win = "YOU WIN!"
    case `default` = ""
    case lose = "YOU LOSE!"

    var message: String {
        rawValue
    }
}
