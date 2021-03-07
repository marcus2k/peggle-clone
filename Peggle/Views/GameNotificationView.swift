//
//  GameNotificationView.swift
//  Peggle
//
//  Created by Marcus on 28/1/21.
//

import SwiftUI

struct GameNotificationView: View {
    @ObservedObject var notifier = NotificationManager.default

    var body: some View {
        Group {
            if let notif = notifier.notification {
                Text(notif)
                    .font(.largeTitle)
                    .bold()
                    .zIndex(.greatestFiniteMagnitude)
            } else {
                EmptyView()
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        GameNotificationView()
    }
}
