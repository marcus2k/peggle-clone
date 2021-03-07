//
//  NotificationManager.swift
//  Peggle
//
//  Created by Marcus on 28/1/21.
//

import Foundation

class NotificationManager: ObservableObject {
    static let `default` = NotificationManager()

    private init() { }

    @Published private(set) var notification: String?
    private var timer: Timer?

    func setUntimedNotification(to newNotif: String) {
        if newNotif.isEmpty {
            removeNotification()
            return
        }
        notification = newNotif
    }

    func setNotification(to newNotif: String) {
        if newNotif.isEmpty {
            removeNotification()
            return
        }
        notification = newNotif
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            if timer != self.timer {
                return
            }
            self.timer?.invalidate()
            self.notification = nil
        }
    }

    func removeNotification() {
        self.notification = nil
        self.timer?.invalidate()
        self.timer = nil
    }
}
