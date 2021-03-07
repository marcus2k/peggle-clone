//
//  NameError.swift
//  Peggle
//
//  Created by Marcus on 29/1/21.
//

enum NameError: String {
    case emptyError = "Level Name cannot be empty!"
    case duplicateError = "Level Name is already taken!"
    case tooLongError = "Level Name length should be at most 15!"
}
