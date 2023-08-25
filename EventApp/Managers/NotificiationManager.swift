//
//  NotificiationManager.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 24.08.2023.
//

import Foundation
import Combine
import UserNotifications
import UIKit

protocol NotificationManagerProtocol {
    var notification: PassthroughSubject<String, Never> { get set }
    var notificationCenter: UNUserNotificationCenter { get set }
}

class NotificationManager: NSObject, NotificationManagerProtocol {
    var notification: PassthroughSubject<String, Never> = .init()
    
    public lazy var notificationCenter: UNUserNotificationCenter = {
        return .current()
    }()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        return [[.banner, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let notificationId = response.notification.request.content.userInfo["notificationID"] as? Int ?? 5
        DispatchQueue.main.async {
            DrawerMenuViewController.shared.openChatAskAQuestion(chatId: notificationId)
        }
    }
}
