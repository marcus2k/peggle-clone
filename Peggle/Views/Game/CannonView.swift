//
//  CannonView.swift
//  Peggle
//
//  Created by Marcus on 8/2/21.
//

import SwiftUI

struct CannonView: View {
    @ObservedObject var gameEngine: PeggleEngineManager

    var cannon: Cannon {
        gameEngine.cannon
    }

    let cannonHeight: CGFloat = 190
    let cannonHorizontalPosition: CGFloat = 30
    let minDragDistance: CGFloat = 10

    var angle: Angle {
        Angle(degrees: gameEngine.angle)
    }

    init(gameEngine: PeggleEngineManager) {
        self.gameEngine = gameEngine
    }

    var body: some View {
        GeometryReader { geo in
            getCannonImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(angle, anchor: .center)
                .position(x: geo.size.width / 2, y: cannonHorizontalPosition)
                .opacity(cannon.isLoaded ? 1 : 0.3)
                .frame(height: cannonHeight)
                .gesture(DragGesture(minimumDistance: minDragDistance)
                            .onChanged { value in
                                gameEngine.setCannonFacing(value.translation)
                            }
                            .onEnded { value in
                                gameEngine.setCannonFacing(value.translation)
                                gameEngine.startLoop()
                            }
                )
        }
    }

    func getCannonImage() -> Image {
        if cannon.isLoaded {
            return Image("cannon-loaded")
        } else {
            return Image("cannon-empty")
        }
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView(gameEngine: PeggleEngineManager())
    }
}
