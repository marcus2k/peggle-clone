//
//  GameBackgroundView.swift
//  Peggle
//
//  Created by Marcus on 23/1/21.
//

import SwiftUI

struct GameBackgroundView: View {
    var wallpaper = "background"
    var body: some View {
        Image(wallpaper)
            .resizable()
            .ignoresSafeArea(.all)
            .zIndex(-1)
    }
}

struct GameBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GameBackgroundView()
    }
}
