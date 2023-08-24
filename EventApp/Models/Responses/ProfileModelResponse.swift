//
//  ProfileModelResponse.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation

class ProfileModelResponse: Codable {
    let email: String
    let name_first: String
    let name_last: String
    let lang: String
    var phone: String
    
    init(email: String, name_first: String, name_last: String, lang: String, phone: String) {
        self.email = email
        self.name_first = name_first
        self.name_last = name_last
        self.lang = lang
        self.phone = phone
    }
}
