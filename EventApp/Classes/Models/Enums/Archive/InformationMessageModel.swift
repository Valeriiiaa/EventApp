//
//  WarningMessageModel.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import Foundation

class InformationMessageModel {
    let image: String
    let text: String
    let data: String
    let info: String
    
    init(imageMessage: String, textMessage: String, dataMessage: String, infoMessage: String) {
        self.image = imageMessage
        self.text = textMessage
        self.data = dataMessage
        self.info = infoMessage
    }
    
}
