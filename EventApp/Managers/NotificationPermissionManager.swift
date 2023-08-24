//
//  NotificationPermissionManager.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 14.08.2023.
//

import UIKit
import FirebaseMessaging
import Combine

class NotificationPermissionManager: NSObject {
    private let notificationManager: NotificationManagerProtocol
    
    init(notificationManager: NotificationManagerProtocol) {
        self.notificationManager = notificationManager
    }
    
    public func request() {
        notificationManager.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission grajkjjknted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
