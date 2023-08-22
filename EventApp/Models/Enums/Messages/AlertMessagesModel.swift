//
//  AlertMessagesModel.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import Foundation

class AlertMessagesModel {
    let image: String
    let type: String
    let text: String
    let data: String
    
    init(image: String, type: String, text: String, data: String) {
        self.image = image
        self.type = type
        self.text = text
        self.data = data
    }
    
}
