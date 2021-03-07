//
//  Palette.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

struct Palette {
    private(set) var selectedButton: ActionButton = .addBluePeg

    mutating func selectButton(_ button: ActionButton) {
        if selectedButton == button {
            return
        }
        selectedButton = button
    }
}
