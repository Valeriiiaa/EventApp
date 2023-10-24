//
//  NotificationResponseModel.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 31.07.2023.
//

import Foundation

struct NotificationResponseModel: Codable {
    public let id: Int
    public let idMessage: Int?
    public let text: String
    public let title: String
    public let link: String?
    public let type: String
    public let created_at: String
}
