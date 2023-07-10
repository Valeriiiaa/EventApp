//
//  SelectionModel.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 03.07.2023.
//

import Foundation

class SelectionModel {
    let key: String
    let name: String
    var isSelected: Bool
    
    init(key: String, name: String, isSelected: Bool) {
        self.key = key
        self.name = name
        self.isSelected = isSelected
    }
}
