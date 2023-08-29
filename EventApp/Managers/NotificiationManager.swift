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
        let type = userInfo["gcm.notification.type"] as? String ?? ""
        let showNews = UserDefaultsStorage.shared.get(key: .showNews, defaultValue: true)
        let showAttention = UserDefaultsStorage.shared.get(key: .showAttention, defaultValue: true)
        let showAlarm = UserDefaultsStorage.shared.get(key: .showAlarm, defaultValue: true)
        let showPersonal = UserDefaultsStorage.shared.get(key: .showPersonal, defaultValue: true)
        let showQuestion = UserDefaultsStorage.shared.get(key: .showAQuestion, defaultValue: true)
        switch type {
        case "Ticket":
            guard showQuestion else { return [] }
            break
        case "News":
            guard showNews else { return [] }
            break
        case "Alarm":
            guard showAlarm else { return [] }
            break
        case "Personal":
            guard showPersonal else { return [] }
            break
        case "Attention":
            guard showAttention else { return [] }
            break
        default: break
        }
        return [[.banner, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let notificationIdString = response.notification.request.content.userInfo["gcm.notification.id"] as? String ?? ""
        let notificationId = Int(notificationIdString) ?? 0
        guard response.notification.request.content.userInfo["gcm.notification.type"] as? String == "Ticket" else { return }
        DispatchQueue.main.async {
            DrawerMenuViewController.shared.openChatAskAQuestion(chatId: notificationId)
        }
    }
}
