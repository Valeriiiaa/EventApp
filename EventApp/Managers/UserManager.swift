//
//  UserManager.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation

class UserManager {
    private(set) var token: String
    @Published public var userModel: ProfileModelResponse?
    
    init(token: String) {
        self.token = token
    }
}
