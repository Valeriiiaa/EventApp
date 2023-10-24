//
//  SaveTokenRequest.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 14.08.2023.
//

import Foundation

struct SaveTokenRequest: Codable {
    let token: String
    let deviceType: String
    
    init(token: String, deviceType: String = "ios") {
        self.token = token
        self.deviceType = deviceType
    }
}
