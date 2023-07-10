//
//  ArchiveModel.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import Foundation

class ArchiveMessagesModel {
    let image: String
    let label: Bool
    let text: String
    let data: String
    
    init(image: String, label: Bool, text: String, data: String) {
        self.image = image
        self.label = label
        self.text = text
        self.data = data
    }
    
}
