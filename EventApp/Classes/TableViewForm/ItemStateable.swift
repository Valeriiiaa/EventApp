//
//  ItemStateable.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 31.07.2023.
//

import Foundation

protocol ItemStateable {
//    associatedtype T where T == any Valuable,
    var stateModel: StateModel { get set }
    var type: String { get }
    var reuseId: String { get set }
}
