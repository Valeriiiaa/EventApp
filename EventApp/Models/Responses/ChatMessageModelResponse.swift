//
//  ChatMessageModelResponse.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 24.08.2023.
//

import Foundation

struct ChatMessageModelResponse: Codable {
    let text: String
    let user_fullname: String
    let date: String
    let isUserMessage: Bool
}
