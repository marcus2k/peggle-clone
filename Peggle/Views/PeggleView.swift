//
//  PeggleView.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct PeggleView: View {
    var levelList = LevelListManager()

    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack(spacing: 0) {
                LevelDesignerView(levelList: levelList)
            }
            GameNotificationView()
        }
    }
}

struct PeggleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeggleView(levelList: LevelListManager())
        }
    }
}
