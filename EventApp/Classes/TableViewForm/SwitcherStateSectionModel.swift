//
//  SwitcherModel.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 30.07.2023.
//

import Foundation

extension Bool: Valuable {
    typealias T = Bool
    
    public var value: Bool {
        self
    }
}

class SwitcherStateSectionModel: ItemStateable {
    public let title: String
    public var reuseId: String
    public var stateModel: StateModel
    
    var type: String {
        stateModel.type
    }
    
    init(title: String, type: StateType, reuseId: String, state: Bool) {
        self.title = title
        self.reuseId = reuseId
        self.stateModel = .init(state: state, type: type.rawValue)
    }
}
