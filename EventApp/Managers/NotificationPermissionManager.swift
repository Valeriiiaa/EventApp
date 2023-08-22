//
//  NotificationPermissionManager.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 14.08.2023.
//

import UIKit

class NotificationPermissionManager {
    public func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
