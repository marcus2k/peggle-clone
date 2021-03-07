//
//  LevelListView.swift
//  Peggle
//
//  Created by Marcus on 29/1/21.
//

import SwiftUI

struct LevelListView: View {
    @ObservedObject var levelList: LevelListManager

    var levelNames: [String] {
        levelList.levelNames
    }

    var levels: [Level] {
        levelList.levels
    }

    let horizontalPadFactor: CGFloat = 0.1
    let topPadFactor: CGFloat = 0.08
    let bottomPadFactor: CGFloat = 0.4
    let optionsPadFactor: CGFloat = 0.005

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Game Levels")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Spacer()
                    Button("Create new level") {
                        levelList.addNewLevel()
                    }
                        .font(.title2)
                        .padding()
                }
                getLevelList(padding: geometry.size.height * optionsPadFactor)
            }
                .padding(.top, geometry.size.height * topPadFactor)
                .padding(.horizontal, geometry.size.height * horizontalPadFactor)
                .padding(.bottom, geometry.size.height * bottomPadFactor)
        }
    }

    func getLevelList(padding: CGFloat) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(levels) { level in
                HStack {
                    Button(level.name) {
                        levelList.selectLevel(level)
                    }
                        .font(.largeTitle)
                        .frame(alignment: .topTrailing)
                    Spacer()
                    Button("Delete") {
                        levelList.deleteLevel(level)
                    }
                        .font(.title2)
                        .foregroundColor(.red)
                        .frame(alignment: .topTrailing)
                }
                    .padding(padding)
            }
            Spacer()
        }
            .padding()
    }
}
