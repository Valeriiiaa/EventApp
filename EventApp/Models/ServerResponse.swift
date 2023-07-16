//
//  ServerResponse.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 15.07.2023.
//

import Foundation

struct ServerResponse: Codable {
    let status: String?
    let message: String?
    let token: String?
}
