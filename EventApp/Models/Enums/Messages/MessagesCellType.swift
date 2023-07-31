//
//  MessagesCellType.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import Foundation

enum MessagesCellType {
    case mainMessageCell(Int)
    case messageInfoCell(AlertMessagesModel)
    
    var reusedId: String {
        switch self {
        case .mainMessageCell:
            return "MainMessageCell"
        case .messageInfoCell:
            return "MessageInfoCell"
        
        }
    }
}
