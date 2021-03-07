//
//  GameView.swift
//  Peggle
//
//  Created by Marcus on 7/2/21.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameEngine: PeggleEngineManager

    var body: some View {
        GeometryReader { geo in
            getGameState(bounds: geo.frame(in: .local))
        }
    }

    private func getGameState(bounds: CGRect) -> some View {
        gameEngine.setBounds(to: bounds)
        return ZStack {
            CannonView(gameEngine: gameEngine)
                .zIndex(.leastNonzeroMagnitude)
            VStack(spacing: 0) {
                ZStack {
                    getBallView()
                    getCircularPeg()
                    getRectangularBlocks()
                }
                    .frame(minHeight: 0,
                           maxHeight: .infinity,
                           alignment: .topLeading)
                NavBarView(gameEngine: gameEngine)
                    .background(Color.secondary)
                getBottomScreenPadding(color: .secondary)
            }
        }
    }

    private func getBottomScreenPadding(color: Color) -> some View {
        color
            .edgesIgnoringSafeArea(.bottom)
            .frame(height: .leastNonzeroMagnitude)
    }

    private func getBallView() -> some View {
        let bodies = gameEngine.getBodies()
        let balls = bodies.filter { body in
            if body as? Ball != nil {
                return true
            }
            return false
        }
        return Group {
            if let balls = balls as? [Ball] {
                ForEach(balls) { ball in
                    BallView(ball: ball)
                }
            } else {
                EmptyView()
            }
        }
    }

    private func getCircularPeg() -> some View {
        let bodies = gameEngine.getBodies()
        let pegs = bodies.filter { body in
            if body as? CircularPeg != nil {
                return true
            }
            return false
        }
        return Group {
            if let pegs = pegs as? [CircularPeg] {
                ForEach(pegs) { peg in
                    CircularPegView(peg: peg)
                }
            } else {
                EmptyView()
            }
        }
    }

    private func getRectangularBlocks() -> some View {
        let bodies = gameEngine.getBodies()
        let blocks = bodies.filter { body in
            if body as? RectangularBlock != nil {
                return true
            }
            return false
        }
        return Group {
            if let blocks = blocks as? [RectangularBlock] {
                ForEach(blocks) { block in
                    RectangularBlockView(block: block)
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameEngine: PeggleEngineManager())
    }
}
