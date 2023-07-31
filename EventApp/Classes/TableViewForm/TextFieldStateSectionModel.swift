//
//  TextFieldStateSectionModel.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 31.07.2023.
//

import UIKit

extension String: Valuable {
    var value: String {
        return self
    }
}

class TextFieldStateSectionModel: ItemStateable {
    public let title: String
    public var reuseId: String
    public var stateModel: StateModel
    public let keyboardType: UIKeyboardType
    
    var type: String {
        stateModel.type
    }
    
    init(title: String, reuseId: String, state: String, type: StateType, keyboardType: UIKeyboardType) {
        self.title = title
        self.reuseId = reuseId
        self.stateModel = .init(state: state, type: type.rawValue)
        self.keyboardType = keyboardType
    }
}
