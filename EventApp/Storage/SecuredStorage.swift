//
//  SecuredStorage.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation
import KeychainSwift

protocol Storage {
    func set(value: String, for key: LocalStorageKey)
    func get(for key: LocalStorageKey, defaultValue: String) -> String
    func get(for key: LocalStorageKey, defaultValue: String) -> String?
}

class SecuredStorage: Storage {
    private let keychain = KeychainSwift()
    
    public func set(value: String, for key: LocalStorageKey) {
        keychain.set(value, forKey: key.rawValue)
    }
    
    public func get(for key: LocalStorageKey, defaultValue: String) -> String {
        keychain.get(key.rawValue) ?? defaultValue
    }
    
    public func get(for key: LocalStorageKey, defaultValue: String) -> String? {
        keychain.get(key.rawValue)
    }
}
