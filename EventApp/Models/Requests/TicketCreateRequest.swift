//
//  TicketCreateRequest.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 10.08.2023.
//

import Foundation

struct TicketCreateRequest: Codable {
    public let description: String
    public let id: String
}
