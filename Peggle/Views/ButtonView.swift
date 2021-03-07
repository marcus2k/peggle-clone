//
//  ButtonView.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct ButtonView: View {
    var button: ActionButton
    var isSelected: Bool

    var buttonDiameter: CGFloat {
        switch button {
        case .addBlock:
            return 80
        default:
            return 40
        }
    }

    var body: some View {
        getButtonView()
    }

    private func getButtonView() -> some View {
        getButtonImage()
            .aspectRatio(contentMode: .fit)
            .frame(width: buttonDiameter)
            .colorMultiply(getColorTint())
    }

    private func getButtonImage() -> some View {
        Image(getImageFileName())
            .resizable()
            .overlay(getShapeView().stroke(Color.clear, lineWidth: 4))
            .shadow(radius: 7)
    }

    private func getColorTint() -> Color {
        isSelected ? .white : .secondary
    }

    private func getShapeView() -> some Shape {
        switch button {
        case .addBlock:
            return DynamicShape(Rectangle())
        default:
            return DynamicShape(Circle())
        }
    }

    private func getImageFileName() -> String {
        switch button {
        case .addOrangePeg:
            return "peg-orange"
        case .addBluePeg:
            return "peg-blue"
        case .addBlock:
            return "block-blackborder"
        case .editItem:
            return "edit"
        case .addGreenPeg:
            return "peg-green"
        case .addGreyPeg:
            return "peg-grey"
        default: // delete
            return "delete"
        }
    }

    struct DynamicShape: Shape {
        init<S: Shape>(_ shape: S) {
            _path = { rect in
                let path = shape.path(in: rect)
                return path
            }
        }

        func path(in rect: CGRect) -> Path {
            _path(rect)
        }

        private let _path: (CGRect) -> Path
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(button: .addOrangePeg, isSelected: true)
            ButtonView(button: .addBluePeg, isSelected: false)
        }
    }
}
