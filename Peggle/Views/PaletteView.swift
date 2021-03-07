//
//  PaletteView.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct PaletteView: View {
    @ObservedObject var palette: PaletteManager
    @ObservedObject var level: LevelManager

    private var selectedButton: ActionButton {
        palette.selectedButton
    }

    private var sliderValue: CGFloat {
        palette.sliderValue
    }

    private var cachedSliderValue: CGFloat {
        palette.cachedSliderValue
    }

    private var selectedSetting: PaletteManager.BodySetting {
        palette.selectedSetting
    }

    var body: some View {
        HStack {
            getButtonView(for: .addBluePeg)
            getButtonView(for: .addOrangePeg)
            getButtonView(for: .addGreenPeg)
            getButtonView(for: .addGreyPeg)
            getButtonView(for: .addBlock)
            Spacer()
            if let body = palette.editBody, palette.selectedButton == .editItem {
                getSettingsView(body: body)
            } else {
                getPowerUpView()
            }
            getButtonView(for: .editItem)
            getButtonView(for: .deletePeg)
        }
            .padding()
    }

    private func getPowerUpView() -> some View {
        VStack {
            Text("POWER UP: \(getPowerUpName())")
                .foregroundColor(.black)
            Menu("Change Power Up") {
                Button("None") {
                    level.setPowerUp(nil)
                }
                Button("Space Blast") {
                    level.setPowerUp(.spaceBlast)
                }
                Button("Spooky Ball") {
                    level.setPowerUp(.spookyBall)
                }
            }
        }
    }

    private func getPowerUpName() -> String {
        if let power = level.powerUp {
            if power == .spaceBlast {
                return "SPACE BLAST"
            } else {
                return "SPOOKY BALL"
            }
        }
        return "NONE"
    }

    private func getSettingsView(body: RigidBody) -> some View {
        VStack {
            Slider(value: $palette.sliderValue, in: getValueRange(), step: 1.0) { isEditing in
                if isEditing {
                    palette.cachedSliderValue = sliderValue
                } else {
                    let isUpdated = updateBody(body)
                    if !isUpdated {
                        palette.sliderValue = cachedSliderValue
                    }
                }
            }
            HStack {
                Text("\(selectedSetting.rawValue): \(getSliderValue())")
                    // Because text animation shows ... for a split second after toggle.
                    .foregroundColor(.black)
                    .animation(nil)
                Spacer()
                getSettingsMenu(body: body)
            }
        }
    }

    private func updateBody(_ body: RigidBody) -> Bool {
        var bodyCopy: RigidBody = body
        switch selectedSetting {
        case .angle:
            bodyCopy.setAngle(to: sliderValue)
        case .radius:
            var peg: CircularPeg? = bodyCopy as? CircularPeg
            peg?.setRadius(to: sliderValue)
            bodyCopy = peg ?? bodyCopy
        case .height:
            var block: RectangularBlock? = bodyCopy as? RectangularBlock
            block?.setHeight(to: sliderValue)
            bodyCopy = block ?? bodyCopy
        case .width:
            var block: RectangularBlock? = bodyCopy as? RectangularBlock
            block?.setWidth(to: sliderValue)
            bodyCopy = block ?? bodyCopy
        }
        if level.replaceBody(body, with: bodyCopy) {
            palette.updateEditBody(to: bodyCopy)
            return true
        }
        return false
    }

    private func getSettingsMenu(body: RigidBody) -> some View {
        HStack(spacing: 20) {
            Menu("Select property") {
                if let block = body as? RectangularBlock {
                    Button("Width") {
                        palette.selectedSetting = .width
                        palette.sliderValue = block.width
                    }
                    Button("Height") {
                        palette.selectedSetting = .height
                        palette.sliderValue = block.height
                    }
                } else if let peg = body as? CircularPeg {
                    Button("Radius") {
                        palette.selectedSetting = .radius
                        palette.sliderValue = peg.radius
                    }
                }
                Button("Angle") {
                    palette.selectedSetting = .angle
                    palette.sliderValue = .zero
                }
            }
            Button("Done") {
                palette.unsetEditBody()
            }
        }
    }

    private func getSliderValue() -> String {
        let prepend = selectedSetting == .angle && sliderValue > 0 ? "+" : ""
        return "\(prepend)\(Int(sliderValue))"
    }

    private func getValueRange() -> ClosedRange<CGFloat> {
        switch selectedSetting {
        case .angle:
            return -180.0...180.0
        case .radius:
            return 20.0...40.0
        case .width:
            return 20.0...200.0
        default: // height
            return 20.0...40.0
        }
    }

    private func isSelectedButton(_ button: ActionButton) -> Bool {
        button == selectedButton
    }

    private func getButtonView(for button: ActionButton) -> some View {
        ButtonView(button: button, isSelected: isSelectedButton(button))
            .onTapGesture {
                toggleButton(to: button)
                if selectedButton != .editItem {
                    palette.unsetEditBody()
                }
            }
    }

    private func toggleButton(to button: ActionButton) {
        palette.toggleButton(button)
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView(palette: PaletteManager(), level: LevelManager())
    }
}
