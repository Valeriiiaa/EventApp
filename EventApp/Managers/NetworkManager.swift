//
//  NetworkManager.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 13.07.2023.
//

import Foundation
import Swinject

enum NetworkError: Error {
    case serverError(String)
    case clientError(String)
    
    var errorDescription: String {
        switch self {
        case .serverError(let string):
            return string
        case .clientError(let string):
            return string
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let serverURL = "http://dev.effective-hc.com/api/"
    
    public func requestCode(phone: String, completion: @escaping(Bool) -> Void) {
        var urlRequest = URLRequest(url: URL(string: serverURL + "send-code")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try! JSONEncoder().encode(CodeRequest(phone: phone))
        urlRequest .setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let urlSession = URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        })
        urlSession.resume()
    }
    
    public func getProfile(completion: @escaping(Result<ProfileModelResponse, Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        var url = URLRequest(url: URL(string: serverURL + "get-my-info")!)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.clientError("No response data")))
                return
            }
            
            do {
                let profileResponse = try JSONDecoder().decode(ProfileModelResponse.self, from: responseData)
                completion(.success(profileResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func logout() {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        var url = URLRequest(url: URL(string: serverURL + "logout")!)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
        }
        task.resume()
    }
    
    func archiveNotification(id: Int, completion: @escaping(Result<Bool, Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        var url = URLRequest(url: URL(string: serverURL + "notifications/\(id)/archive")!)
        url.httpMethod = "PUT"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let error else {
                completion(.success(true))
                return
            }
            completion(.failure(error))
        }
        task.resume()
    }
    
    func loadArhivedNotifications(completion: @escaping(Result<[NotificationResponseModel], Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        guard let userModel = user.userModel else { return }
        var url = URLRequest(url: URL(string: serverURL + "notifications/get-archive-notifications/\(userModel.lang)" )!)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        print("[bearer] \(user.token)")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.clientError("No response data")))
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode([NotificationResponseModel].self, from: responseData)
                completion(.success(serverResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func loadNotifications(completion: @escaping(Result<[NotificationResponseModel], Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        guard let userModel = user.userModel else { return }
        var url = URLRequest(url: URL(string: serverURL + "notifications/\(userModel.lang)" )!)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        print("[bearer] \(user.token)")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.clientError("No response data")))
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode([NotificationResponseModel].self, from: responseData)
                completion(.success(serverResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func requestWithCode(phone: String, code: String, comletion: @escaping(Result<String, Error>) -> Void) {
        var url = URLRequest(url: URL(string: serverURL + "verify-code")!)
        url.httpMethod = "POST"
        url.httpBody = try! JSONEncoder().encode(CodeRequestVerify(phone: phone, verification_code: code))
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                comletion(.failure(error))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                comletion(.failure(NetworkError.clientError("No response data")))
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode(CodeVerifyResponse.self, from: responseData)
                guard let token = serverResponse.token else {
                    comletion(.failure(NetworkError.serverError(serverResponse.message ?? "")))
                    return
                }
                comletion(.success(token))
            } catch {
                comletion(.failure(error))
            }
        }
        task.resume()
    }
    
    func loadTicketTypes(completion: @escaping(Result<[TicketType], Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        guard let userModel = user.userModel else { return }
        var url = URLRequest(url: URL(string: serverURL + "tickets/get-types")!)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.clientError("No response data")))
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode([TicketType].self, from: responseData)
                completion(.success(serverResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func createTicket(text: String, typeId: Int, completion: @escaping(Result<Bool, Error>) -> Void) {
        let user: UserManager? = AppDelegate.contaienr.resolve(UserManager.self)
        guard let user else { return }
        var url = URLRequest(url: URL(string: serverURL + "tickets/create")!)
        url.httpMethod = "POST"
        url.httpBody = try! JSONEncoder().encode(TicketCreateRequest(description: text, type: typeId.description))
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            completion(.success(true))
        }
        task.resume()
    }
}
