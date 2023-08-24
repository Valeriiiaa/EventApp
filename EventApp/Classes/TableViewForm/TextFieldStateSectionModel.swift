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
    public var isEditable: Bool
    public let didEndEditing: ((String?) -> Void)?
    
    var type: String {
        stateModel.type
    }
    
    init(title: String, reuseId: String, state: String, type: StateType, isEditable: Bool,
         didEndEditing: ((String?) -> Void)? = nil,
         keyboardType: UIKeyboardType) {
        self.title = title
        self.reuseId = reuseId
        self.stateModel = .init(state: state, type: type.rawValue)
        self.keyboardType = keyboardType
        self.isEditable = isEditable
        self.didEndEditing = didEndEditing
    }
}
