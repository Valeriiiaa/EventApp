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

class UserDefaultsStorage {
    
    static let shared = UserDefaultsStorage()
    
    private let storage = UserDefaults.standard
    
    func set<T>(key: LocalStorageKey, value: T) where T : Codable {
        storage.set(try? JSONEncoder().encode(value), forKey: key.rawValue)
    }
    
    func add<T>(key: LocalStorageKey, value: T) where T : Codable & Equatable {
        guard var array: [T] = get(key: key) else {
            set(key: key, value: [value])
            return
        }
        array.removeAll(where: { $0 == value })
        array.append(value)
        set(key: key, value: array)
    }
    
    func replace<T>(key: LocalStorageKey, value: T) where T: Codable, T: Equatable {
        guard var array: [T] = get(key: key) else {
            return
        }
        guard let index = array.firstIndex(of: value) else { return }
        array[index] = value
        
        set(key: key, value: array)
    }
 
    func remove<T>(key: LocalStorageKey, value: T) where T : Codable, T : Equatable {
        guard var array: [T] = get(key: key) else {
            return
        }
        array.removeAll(where: {value == $0} )
        set(key: key, value: array)
    }
    
    func get<T>(key: LocalStorageKey) -> T? where T : Decodable {
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T>(key: LocalStorageKey, defaultValue: T) -> T where T : Decodable {
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }
    
    func clear(key: LocalStorageKey) {
        storage.setValue(nil, forKey: key.rawValue)
    }
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
