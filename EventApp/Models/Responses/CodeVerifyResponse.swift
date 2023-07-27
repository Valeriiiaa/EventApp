//
//  CodeVerifyResponse.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation

struct CodeVerifyResponse: Codable {
    public let token: String?
    public let status: String?
    public let message: String?
}
