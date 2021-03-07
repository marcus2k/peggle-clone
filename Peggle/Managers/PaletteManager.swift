//
//  PaletteManager.swift
//  Peggle
//
//  Created by Marcus on 24/1/21.
//

import SwiftUI

class PaletteManager: ObservableObject { // ViewModel
    @Published private var palette = Palette()
    @Published var sliderValue: CGFloat = .zero
    @Published var selectedSetting: BodySetting = .angle
    @Published var cachedSliderValue: CGFloat = .zero
    @Published private(set) var editBody: RigidBody?

    enum BodySetting: String {
        case angle = "Angle"
        case height = "Height"
        case width = "Width"
        case radius = "Radius"
    }

    func setEditBody(to body: RigidBody) {
        editBody = body
        selectedSetting = .angle
        sliderValue = body.angle
    }

    func updateEditBody(to body: RigidBody) {
        editBody = body
    }

    func unsetEditBody() {
        editBody = nil
        selectedSetting = .angle
        sliderValue = .zero
    }

    var selectedButton: ActionButton {
        palette.selectedButton
    }

    func toggleButton(_ button: ActionButton) {
        palette.selectButton(button)
    }
}
