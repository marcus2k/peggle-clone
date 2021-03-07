//
//  PeggleEngineManager.swift
//  Peggle
//
//  Created by Marcus on 7/2/21.
//

import SwiftUI

class PeggleEngineManager: ObservableObject {
    @Published private(set) var simulator: PeggleSimulator?
    @Published var cannon = Cannon()
    @Published var chances = Chances()
    @Published var gameState: GameState = .default
    var displayLink: CADisplayLink?

    var powerUp: PowerUp? {
        simulator?.powerUp
    }

    func setPowerUp(to powerUp: PowerUp?) {
        if let powerUp = powerUp {
            simulator?.setPowerUp(to: powerUp)
        }
    }

    func loadGame(level: Level, powerUp: PowerUp?) {
        unloadGame() // for defensiveness
        simulator = PeggleSimulator(level: level)
        setPowerUp(to: powerUp)
    }

    func setBounds(to bounds: CGRect) {
        guard let simulator = simulator else {
            return
        }
        if simulator.physics.boundary != bounds {
            self.simulator?.setBounds(to: bounds)
        }
    }

    func startLoop() {
        if ballStillExists() || chances.isEmpty || gameState != .default {
            return
        }
        chances.decrement()
        self.displayLink?.invalidate()
        self.displayLink = CADisplayLink(target: self, selector: #selector(updateEngine))
        self.displayLink?.add(to: .current, forMode: .common)
        launchBall()
        unloadBall()
    }

    func endLoop() {
        self.displayLink?.invalidate()
        self.displayLink = nil
        if chances.isEmpty || gameState != .default {
            return
        }
        loadBall()
    }

    func unloadGame() {
        simulator = nil
        displayLink?.invalidate()
        displayLink = nil
        cannon = Cannon()
        chances = Chances()
        gameState = .default
    }

    var angle: Double {
        cannon.angle
    }

    func ballStillExists() -> Bool {
        guard let simulator = simulator else {
            return false
        }
        return simulator.ballStillExists()
    }

    func setCannonFacing(_ translation: CGSize) {
        var height = translation.height
        if height < 0 {
            height = 0
        }
        var angle = Double(atan(abs(translation.width / height)))
        angle *= -180 / Double.pi
        if translation.width < 0 {
            angle *= -1
        }
        cannon.setAngle(to: angle)
    }

    @objc func updateEngine() {
        guard let link = displayLink, simulator != nil else {
            return
        }
        if !ballStillExists() {
            if let stillHasOrangePegs = simulator?.removeLitPegs(), stillHasOrangePegs {
                // update game State (losing state) if chances = 0
                if chances.isEmpty {
                    gameState = .lose
                    simulator?.revealGreyPegColors()
                    print("You lose!")
                } else {
                    assert(gameState == .default)
                    print("No outcome yet")
                }
            } else {
                gameState = .win
                simulator?.revealGreyPegColors()
                print("You win!")
            }
            notifyOutcome()
            endLoop()
            return
        }
        let interval = link.targetTimestamp - link.timestamp
        runSimulation(at: interval)
    }

    func launchBall() {
        if !cannon.isLoaded {
            return
        }
        let magnitude: CGFloat = 500
        let x = CGFloat(-sin(cannon.angle * Double.pi / 180))
        let y = CGFloat(cos(cannon.angle * Double.pi / 180))
        let unitVector = Vector(x: x, y: y)
        let velocity = unitVector.multiply(by: magnitude)
        simulator?.launchBall(velocity: velocity)
    }

    func runSimulation(at interval: CFTimeInterval) {
        simulator?.runSimulation(at: interval)
    }

    func getBodies() -> [RigidBody] {
        simulator?.bodies ?? [RigidBody]()
    }

    func loadBall() {
        if chances.isEmpty {
            return
        }
        cannon.load()
    }

    func unloadBall() {
        cannon.unload()
    }

    func notifyOutcome() {
        if gameState == .default {
            // for defensiveness
            return
        }
        NotificationManager.default.setUntimedNotification(to: gameState.message)
    }
}
