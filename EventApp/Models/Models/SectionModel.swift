//
//  SectionModel.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import Foundation

class SectionModel {
    let titleHeader: String
    let itemsInside: [any ItemStateable]
    
    init(titleHeader: String, itemsInside: [any ItemStateable]) {
        self.titleHeader = titleHeader
        self.itemsInside = itemsInside
    }
}
