//
//  ProfileModelResponse.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation

struct ProfileModelResponse: Codable {
    let email: String
    let name_first: String
    let name_last: String
    let lang: String
    let phone: String
}
