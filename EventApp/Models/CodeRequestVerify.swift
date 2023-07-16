//
//  CodeRequestVerify.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 15.07.2023.
//

import Foundation

struct CodeRequestVerify: Codable {
    let phone: String
    let verification_code: String
}
