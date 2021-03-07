//
//  Chances.swift
//  Peggle
//
//  Created by Marcus on 21/2/21.
//

import Foundation

struct Chances {
    var counter = 10

    var isEmpty: Bool {
        counter == 0
    }

    mutating func decrement() {
        counter = max(counter - 1, 0)
    }

    mutating func increment() {
        counter += 1
    }
}
