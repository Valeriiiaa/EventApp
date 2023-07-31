//
//  StateModel.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 30.07.2023.
//

import Foundation
import Combine

protocol Valuable {
    associatedtype T
    var value: T { get }
}

class StateModel {
    @Published public var state: any Valuable
    public let type: String
    
    init(state: any Valuable, type: String) {
        self.state = state
        self.type = type
    }
}
